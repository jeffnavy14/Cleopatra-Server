-----------------------------------
-- Area: Waughroon Shrine
-- NPC:  Ayame
-- Tactics NPC
-----------------------------------

require("scripts/globals/titles");

-----------------------------------
-- onMobSpawn Action
-----------------------------------

function onMobInitialize(mob)

end;

function onMobSpawn(mob)


	mob:AnimationSub(1);
end;

function onMobRoam(mob)
   -- mob:setModelId(1005);
	-- mob:AnimationSub(1);
end;

function onMobEngaged(mob,target)
    if (target:getObjType() == dsp.objType.PET or target:getObjType() == dsp.objType.TRUST) then
		local master = target:getMaster();
		master:PrintToPlayer("??? : You may have defeated my clone...no matter...This is where you perish!!", 0xD);
    else
        target:PrintToPlayer("??? : You may have defeated my clone...no matter...This is where you perish!!", 0xD);
    end
end;


function onMobFight(mob,target)








end;



function onCriticalHit(mob)

end;

-----------------------------------
-- onMobDeath Action
-----------------------------------

function onMobDeath(mob,player,isKiller)
	player:setVar("AYAME_TRIB_FIGHT",2);
end;