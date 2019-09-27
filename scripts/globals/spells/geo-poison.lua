-----------------------------------------
-- Spell: Geo-Poison
-- Gradually restores target party member's MP
-- Composure increases duration 3x
-----------------------------------------

require("scripts/globals/status");
require("scripts/globals/pets");
require("scripts/globals/summon");
require("scripts/globals/job_util");
require("scripts/globals/msg");

-----------------------------------------
-- OnSpellCast
-----------------------------------------

local geoBuff = "poison";
local buffType = 2;  -- Buff / 2 = debuff
local dot = 0;


function onMagicCastingCheck(caster,target,spell)
    if (caster:getPet() ~= nil) then
        return caster:messageBasic(dsp.msg.basic.LUOPAN_HAS_PET, 0);
    else
        return 0, 0;
    end
end;

function onSpellCast(caster,target,spell)
    -- spawnLuopan(caster, target, spell, geoBuff, dot, buffType);
	local potency = doGeoPotency(caster, target, spell)
    local pos = target:getPos()
    caster:spawnPet(dsp.pet.id.LUOPAN)
    local pet = caster:getPet()
    local hploss = math.floor((pet:getMaxHP())/70);  -- Sets DoT
    pet:setPos(pos.x,pos.y,pos.z);


    pet:setModelId(2855)
    pet:addStatusEffectEx(dsp.effect.INDI_POISON,dsp.effect.COLURE_ACTIVE,potency,3,500)
    pet:addMod(dsp.mod.REGEN_DOWN, hploss);
    caster:setVar("FullCircle",25);
	return 0;
end;