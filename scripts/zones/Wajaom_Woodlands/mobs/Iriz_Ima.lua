-----------------------------------
-- Area: Wajaom Woodlands
--  NPC: Iriz Ima(ZNM T2)
-- @pos J-8
-----------------------------------
package.loaded["scripts/zones/Wajaom_Woodlands/IDs"] = nil;
-----------------------------------
require("scripts/zones/Wajaom_Woodlands/IDs");
require("scripts/globals/status");
require("scripts/globals/mobscaler");

-----------------------------------
-- onMobSpawn Action
-----------------------------------

function onMobSpawn(mob)
    znmT2Size(mob)  
end;

function onMobFight(mob, target)
    znmScalerT2(mob,target)
end;

function onCriticalHit(mob)



end;

-----------------------------------
-- onMobDeath
-----------------------------------

function onMobDeath(mob, player, isKiller)
    local nm = 10;
    znmTherionT2(mob, player, nm)	
end;