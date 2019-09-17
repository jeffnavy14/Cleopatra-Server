-----------------------------------
-- Area: Mamook
--  NPC: Iriri Samariri(ZNM T1)
-- @pos F-7
-----------------------------------
package.loaded["scripts/zones/Mamook/IDs"] = nil;
-----------------------------------
require("scripts/zones/Mamook/IDs");
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
    local nm = 11;
    znmTherionT2(mob, player, nm)	
end;