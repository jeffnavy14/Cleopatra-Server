---------------------------------------------
-- Bubble Curtain
--
-- Description: Reduces magical damage received by 50%
-- Type: Enhancing
-- Utsusemi/Blink absorb: N/A
-- Range: Self
-- Notes:Nightmare Crabs use an enhanced version that applies a Magic Defense Boost that cannot be dispelled.
---------------------------------------------
require("scripts/globals/monstertpmoves")
require("scripts/globals/settings")
require("scripts/globals/status")
---------------------------------------------

function onMobSkillCheck(target,mob,skill)
    return 0
end

function onMobWeaponSkill(target, mob, skill)
    local typeEffect = dsp.effect.SHELL
    local power = 50

    skill:setMsg(MobBuffMove(mob, typeEffect, power, 0, 180))
    if (mob:getMaster() ~= nil) then
        local master = mob:getMaster()
        master:addStatusEffect(typeEffect, power, 0, duration)
    end

    return typeEffect
end
