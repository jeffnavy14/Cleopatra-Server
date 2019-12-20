---------------------------------------------
-- Vorpal Blade
--
-- Description: Delivers a four-hit attack. Chance of critical varies with TP.
-- Type: Physical
-- Utsusemi/Blink absorb: Shadow per hit
-- Range: Melee
---------------------------------------------
require("scripts/globals/monstertpmoves")
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/msg")

function onMobSkillCheck(target,mob,skill)
    -- Check for Grah Family id 122,123,124
    -- if not in Paladin form, then ignore.
    if ((mob:getFamily() == 122 or mob:getFamily() == 123 or mob:getFamily() == 124) and mob:AnimationSub() ~= 1) then
        return 1
    elseif (mob:getPool() ~= 4249) then
        mob:messageBasic(dsp.msg.basic.READIES_WS, 0, 40)
    end

    local gettp = mob:getTP()
        -- printf("Get TP is %u", gettp)

    return 0
end

function onMobWeaponSkill(target, mob, skill)
    if (mob:getPool() == 4249) then -- Volker@Throne_Room only
        target:showText(mob,zones[dsp.zone.THRONE_ROOM].text.BLADE_ANSWER)
    end



    if (mob:getName() == "Curilla" or mob:getName() == "Naji" or mob:getName() == "Naji-N") then
        local basemod = 1
        local numhits = 4
        local attmod = 1
        local accmod = 1
        local str_wsc = 0.60
        local dex_wsc = 0
        local agi_wsc = 0
        local vit_wsc = 0
        local mnd_wsc = 0



    	local info = TrustPhysicalMove(mob,target,skill,basemod,numhits,attmod,accmod,str_wsc,dex_wsc,agi_wsc,vit_wsc,mnd_wsc,TP_CRIT_VARIES,1.375,1.375,1.375);

        local dmg = MobFinalAdjustments(info.dmg,mob,skill,target,dsp.attackType.PHYSICAL,dsp.damageType.SLASHING,info.hitslanded)


        target:delHP(dmg);
        return dmg;
    else
        local numhits = 4
        local accmod = 1
        local dmgmod = 1.25
        local info = MobPhysicalMove(mob,target,skill,numhits,accmod,dmgmod,TP_CRIT_VARIES,1.1,1.2,1.3)
        local dmg = MobFinalAdjustments(info.dmg,mob,skill,target,dsp.attackType.PHYSICAL,dsp.damageType.SLASHING,info.hitslanded)

        -- AA EV: Approx 900 damage to 75 DRG/35 THF.  400 to a NIN/WAR in Arhat, but took shadows.
        target:takeDamage(dmg, mob, dsp.attackType.PHYSICAL, dsp.damageType.SLASHING)
        return dmg
    end
end
