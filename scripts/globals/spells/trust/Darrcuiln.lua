-----------------------------------------
-- Spell: Darrcullin
-----------------------------------------
-- require("scripts/globals/trust");
-----------------------------------------

function onMagicCastingCheck(caster,target,spell)
    -- if (caster:hasHate()) then
	   -- caster:messageBasic(700,0,0)
    -- else
        return 0
    -- end
end

function onSpellCast(caster,target,spell)
    -- Todo: put Trusts's spawn in dialog here or in entity script?
    -- Todo: automate entity spawn in core for trust spells?
    local darrcuilnType = caster:getVar("DARRCUILN_TYPE")
    if (darrcuilnType == 1) then
        caster:spawnTrust(99)
    elseif (darrcuilnType == 2) then
        caster:spawnTrust(100)
    else
        caster:spawnTrust(98)
    end
    return 0
end