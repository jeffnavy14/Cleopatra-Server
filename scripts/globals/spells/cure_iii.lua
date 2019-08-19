-----------------------------------------
-- Spell: Cure III
-- Restores target's HP.
-- Shamelessly stolen from http://members.shaw.ca/pizza_steve/cure/Cure_Calculator.html
-----------------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/magic")
require("scripts/globals/msg")
-----------------------------------------

function onMagicCastingCheck(caster,target,spell)
    return 0
end

function onSpellCast(caster,target,spell)
    local divisor = 0
    local constant = 0
    local basepower = 0
    local power = 0
    local basecure = 0
    local final = 0

    local minCure = 130
    if (USE_OLD_CURE_FORMULA == true) then
        power = getCurePowerOld(caster)
        divisor = 1
        constant = 70
        if (power > 300) then
            divisor = 15.6666
            constant = 180.43
        elseif (power > 180) then
            divisor = 2
            constant = 115
        end
    else
        power = getCurePower(caster)
        if (power < 125) then
            divisor = 2.2
            constant = 130
            basepower = 70
        elseif (power < 200) then
            divisor =  75/65
            constant = 155
            basepower = 125
        elseif (power < 300) then
            divisor = 2.5
            constant = 220
            basepower = 200
        elseif (power < 700) then
            divisor = 5
            constant = 260
            basepower = 300
        else
            divisor = 999999
            constant = 340
            basepower = 0
        end
    end

    if (target:getAllegiance() == caster:getAllegiance() and (target:getObjType() == dsp.objType.PC or target:getObjType() == dsp.objType.MOB or target:getObjType() == dsp.objType.TRUST))then
        if (USE_OLD_CURE_FORMULA == true) then
            basecure = getBaseCureOld(power,divisor,constant)
        else
            basecure = getBaseCure(power,divisor,constant,basepower)
        end
        final = getCureFinal(caster,spell,basecure,minCure,false)
        if (caster:hasStatusEffect(dsp.effect.AFFLATUS_SOLACE) and target:hasStatusEffect(dsp.effect.STONESKIN) == false) then
            local solaceStoneskin = 0
            local equippedBody = caster:getEquipID(dsp.slot.BODY)
            if (equippedBody == 11186) then
                solaceStoneskin = math.floor(final * 0.30)
            elseif (equippedBody == 11086) then
                solaceStoneskin = math.floor(final * 0.35)
            else
                solaceStoneskin = math.floor(final * 0.25)
            end
            target:addStatusEffect(dsp.effect.STONESKIN,solaceStoneskin,0,25,0,0,1)
        end
        final = final + (final * (target:getMod(dsp.mod.CURE_POTENCY_RCVD)/100))

        --Applying server mods....
        final = final * CURE_POWER

        local diff = (target:getMaxHP() - target:getHP())
        if (final > diff) then
            final = diff
        end
        target:addHP(final)

        target:wakeUp()
        caster:updateEnmityFromCure(target,final)
    else
        if (target:isUndead()) then
            spell:setMsg(dsp.msg.basic.MAGIC_DMG)
            local params = {}
            params.dmg = minCure
            params.multiplier = 1
            params.skillType = dsp.skill.HEALING_MAGIC
            params.attribute = dsp.mod.MND
            params.hasMultipleTargetReduction = false

            local dmg = calculateMagicDamage(caster, target, spell, params)*0.5
            local params = {}
            params.diff = caster:getStat(dsp.mod.MND)-target:getStat(dsp.mod.MND)
            params.attribute = dsp.mod.MND
            params.skillType = dsp.skill.HEALING_MAGIC
            params.bonus = 1.0
            local resist = applyResistance(caster, target, spell, params)
            dmg = dmg*resist
            dmg = addBonuses(caster,spell,target,dmg)
            dmg = adjustForTarget(target,dmg,spell:getElement())
            dmg = finalMagicAdjustments(caster,target,spell,dmg)
            final = dmg
            target:takeDamage(final, caster, dsp.attackType.MAGICAL, dsp.damageType.LIGHT)
            target:updateEnmityFromDamage(caster,final)
        elseif (caster:getObjType() == dsp.objType.PC) then
            spell:setMsg(dsp.msg.basic.MAGIC_NO_EFFECT)
        else
            -- e.g. monsters healing themselves.
            if (USE_OLD_CURE_FORMULA == true) then
                basecure = getBaseCureOld(power,divisor,constant)
            else
                basecure = getBaseCure(power,divisor,constant,basepower)
            end
            final = getCureFinal(caster,spell,basecure,minCure,false)
            local diff = (target:getMaxHP() - target:getHP())
            if (final > diff) then
                final = diff
            end
            target:addHP(final)
        end
    end

    local mpBonusPercent = (final*caster:getMod(dsp.mod.CURE2MP_PERCENT))/100
    if (mpBonusPercent > 0) then
        caster:addMP(mpBonusPercent)
    end

    return final
end
