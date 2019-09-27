/*
===========================================================================

Copyright (c) 2018 Darkstar Dev Teams

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/

This file is part of DarkStar-server source code.

===========================================================================
*/

#include <string.h>

#include "trustentity.h"
#include "../mob_spell_container.h"
#include "../mob_spell_list.h"
#include "../packets/char_health.h"
#include "../packets/entity_update.h"
#include "../packets/trust_sync.h"
#include "../packets/action.h"
#include "../ai/ai_container.h"
#include "../ai/controllers/trust_controller.h"
#include "../ai/helpers/pathfind.h"
#include "../ai/helpers/targetfind.h"
#include "../ai/states/ability_state.h"
#include "../ai/states/mobskill_state.h"
#include "../utils/battleutils.h"
#include "../utils/petutils.h"
#include "../utils/mobutils.h"
#include "../../common/utils.h"
#include "../mob_modifier.h"

CTrustEntity::CTrustEntity(CCharEntity* PChar)
{
    objtype = TYPE_TRUST;
    m_EcoSystem = SYSTEM_UNCLASSIFIED;
    allegiance = ALLEGIANCE_PLAYER;
    m_MobSkillList = 0;
    PMaster = PChar;
    PAI = std::make_unique<CAIContainer>(this, std::make_unique<CPathFind>(this), std::make_unique<CTrustController>(PChar, this), std::make_unique<CTargetFind>(this));
}

CTrustEntity::~CTrustEntity()
{
}

void CTrustEntity::PostTick()
{
    CBattleEntity::PostTick();
    if (loc.zone && updatemask && status != STATUS_DISAPPEAR)
    {

        loc.zone->PushPacket(this, CHAR_INRANGE, new CEntityUpdatePacket(this, ENTITY_UPDATE, updatemask));
        if (PMaster != nullptr)
        {
            for (auto PTrust : ((CCharEntity*)PMaster)->PTrusts)
            {
                if (PTrust == this)
                {
                    ((CCharEntity*)PMaster)->pushPacket(new CTrustSyncPacket((CCharEntity*)PMaster, this));
                }
            }
        }

        if (updatemask & UPDATE_HP)
        {
            if (PMaster != nullptr)
            {
                if (PMaster->PParty != nullptr)
                {
                    PMaster->ForParty([this](auto PMember)
                    {
                        if (PMember->objtype == TYPE_PC)
                        {
                            static_cast<CCharEntity*>(PMember)->pushPacket(new CCharHealthPacket(this));
                        }
                    });
                }
            }
        }

        updatemask = 0;
    }
}

void CTrustEntity::FadeOut()
{
    CMobEntity::FadeOut();
    loc.zone->PushPacket(this, CHAR_INRANGE, new CEntityUpdatePacket(this, ENTITY_DESPAWN, UPDATE_NONE));
}

void CTrustEntity::Die()
{
    PAI->ClearStateStack();
    PAI->Internal_Die(0s);
    luautils::OnMobDeath(this, nullptr);
    CBattleEntity::Die();
    if (PMaster != nullptr)
    {
        CCharEntity* PChar = (CCharEntity*)PMaster;
        PChar->RemoveTrust(this);
        //PChar->RemoveTrust((CTrustEntity*)PTrust);
    }
}

void CTrustEntity::Spawn()
{
    //we need to skip CMobEntity's spawn because it calculates stats (and our stats are already calculated)
    CBattleEntity::Spawn();
    ((CCharEntity*)PMaster)->pushPacket(new CTrustSyncPacket((CCharEntity*)PMaster, this));
    luautils::OnMobSpawn(this);
}

bool CTrustEntity::ValidTarget(CBattleEntity* PInitiator, uint16 targetFlags)
{
    if (targetFlags & TARGET_PLAYER && PInitiator->allegiance == allegiance)
    {
        return false;
    }
    return CMobEntity::ValidTarget(PInitiator, targetFlags);
}

void CTrustEntity::OnAbility(CAbilityState& state, action_t& action)
{
    ShowWarning(CL_GREEN"An Ability has been Fired off!!!\n" CL_RESET);
    auto PAbility = state.GetAbility();
    auto PTarget = static_cast<CBattleEntity*>(state.GetTarget());

    std::unique_ptr<CBasicPacket> errMsg;
    if (IsValidTarget(PTarget->targid, PAbility->getValidTarget(), errMsg))
    {
        if (this != PTarget && distance(this->loc.p, PTarget->loc.p) > PAbility->getRange())
        {
            return;
        }
        if (battleutils::IsParalyzed(this)) {
            // display paralyzed
            loc.zone->PushPacket(this, CHAR_INRANGE_SELF, new CMessageBasicPacket(this, PTarget, 0, 0, MSGBASIC_IS_PARALYZED));
            return;
        }

        action.id = this->id;
        action.actiontype = PAbility->getActionType();
        //#TODO: unoffset this
        action.actionid = PAbility->getID() + 16;

        if (PAbility->isAoE())
        {
            ShowWarning(CL_GREEN"ABILITY IS AOE!\n" CL_RESET);
            PAI->TargetFind->reset();

            float distance = PAbility->getRange();

            PAI->TargetFind->findWithinArea(this, AOERADIUS_ATTACKER, distance);

            uint16 msg = 0;
            for (auto&& PTarget : PAI->TargetFind->m_targets)
            {
                actionList_t& actionList = action.getNewActionList();
                actionList.ActionTargetID = PTarget->id;
                actionTarget_t& actionTarget = actionList.getNewActionTarget();
                actionTarget.reaction = REACTION_NONE;
                actionTarget.speceffect = SPECEFFECT_NONE;
                actionTarget.animation = PAbility->getAnimationID();
                actionTarget.messageID = PAbility->getMessage();

                if (msg == 0) {
                    msg = PAbility->getMessage();
                }
                else {
                    msg = PAbility->getAoEMsg();
                }

                if (actionTarget.param < 0)
                {
                    msg = ability::GetAbsorbMessage(msg);
                    actionTarget.param = -actionTarget.param;
                }

                actionTarget.messageID = msg;
                actionTarget.param = luautils::OnUseAbility(this, PTarget, PAbility, &action);
            }
        }
        else
        {
            ShowWarning(CL_GREEN"ABILITY NOT AOE\n" CL_RESET);
            actionList_t& actionList = action.getNewActionList();
            actionList.ActionTargetID = PTarget->id;
            actionTarget_t& actionTarget = actionList.getNewActionTarget();
            actionTarget.reaction = REACTION_NONE;
            actionTarget.speceffect = SPECEFFECT_RECOIL;
            actionTarget.animation = PAbility->getAnimationID();
            actionTarget.param = 0;
            auto prevMsg = actionTarget.messageID;

            int32 value = luautils::OnUseAbility(this, PTarget, PAbility, &action);
            if (prevMsg == actionTarget.messageID) actionTarget.messageID = PAbility->getMessage();
            if (actionTarget.messageID == 0) actionTarget.messageID = MSGBASIC_USES_JA;
            actionTarget.param = value;

            if (value < 0)
            {
                actionTarget.messageID = ability::GetAbsorbMessage(actionTarget.messageID);
                actionTarget.param = -value;
            }
        }
    }
}

