-----------------------------------
--
--
--
-----------------------------------

function onEffectGain(target,effect)
    local power = effect:getPower();
	local bonus = power + 2;
	local res = power + 2;
	local ref = (power / 2);
end

function onEffectTick(target,effect)
    if (not target:isPet()) then
        return;
    end
    local owner = target:getMaster();

    local party = owner:getParty();
	local pet = owner:getPet();
    if (party ~= nil) then
        for i,member in ipairs(party) do
		    if (member:checkDistance(pet) < 10) then
            member:addStatusEffect(dsp.effect.DIABLOS_S_FAVOR, effect:getPower(), 0, 3);

			end
        end
    end
end

function onEffectLose(target,effect)
end