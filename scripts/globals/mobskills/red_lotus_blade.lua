---------------------------------------------
-- Red lotus Blade
--
-- Description: Deals fire elemental damage. Damage varies with TP.
-- Type: Physical
-- Utsusemi/Blink absorb: 1 Shadow?
-- Range: Melee
---------------------------------------------
require("scripts/globals/monstertpmoves")
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/msg")

function onMobSkillCheck(target,mob,skill)
    if (mob:getPool() ~= 4006 and mob:getPool() ~= 4249) then
        mob:messageBasic(dsp.msg.basic.READIES_WS, 0, 34)
    end
    return 0
end

function onMobWeaponSkill(target, mob, skill)
    if (mob:getPool() == 4006) then -- Trion@QuBia_Arena only
        target:showText(mob,zones[dsp.zone.QUBIA_ARENA].text.RLB_LAND)
    elseif (mob:getPool() == 4249) then -- Volker@Throne_Room only
        target:showText(mob,zones[dsp.zone.THRONE_ROOM].text.FEEL_MY_PAIN)
    end

    if (mob:getName() == "Curilla" or mob:getName() == "Naji" or mob:getName() == "Naji-N") then
        local basemod = 1
        local numhits = 1
        local attmod = 1
        local accmod = 1
        local str_wsc = 0.2
        local dex_wsc = 0.2
        local agi_wsc = 0
        local vit_wsc = 0
        local mnd_wsc = 0



    	local info = TrustPhysicalMove(mob,target,skill,basemod,numhits,attmod,accmod,str_wsc,dex_wsc,agi_wsc,vit_wsc,mnd_wsc,TP_DMG_VARIES,1.0,2.0,3.0)

        local dmg = MobFinalAdjustments(info.dmg,mob,skill,target,dsp.attackType.PHYSICAL,dsp.damageType.SLASHING,info.hitslanded)


        target:delHP(dmg)
        return dmg
    else


        local dmgmod = 1.25
        local info = MobMagicalMove(mob,target,skill,mob:getWeaponDmg()*4,dsp.magic.ele.FIRE,dmgmod,TP_DMG_BONUS,1)
        local dmg = MobFinalAdjustments(info.dmg,mob,skill,target,dsp.attackType.MAGICAL,dsp.damageType.FIRE,MOBPARAM_1_SHADOW)

        target:takeDamage(dmg, mob, dsp.attackType.MAGICAL, dsp.damageType.FIRE)
        return dmg
    end
end
