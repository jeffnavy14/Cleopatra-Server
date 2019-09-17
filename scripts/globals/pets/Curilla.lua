-------------------------------------------------
--  TRUST: Curilla
--  Magic: None
--  JA: Provoke
--  WS: Burning Blade, Red Lotus Blade, Vorpal Blade
--  Source: http://bg-wiki.com/bg/Category:Trust
-------------------------------------------------
require("scripts/globals/status")
require("scripts/globals/msg")
require("scripts/globals/enmitycalc")
require("scripts/globals/trustpoints")

function onMobSpawn(mob)
    doCurillaTrustPoints(mob)
    local weaponskill = 0
    local cureCooldown = 25
    local provokeCooldown = 30
    local lvl = mob:getMainLvl()
    mob:setLocalVar("cureTimeCurilla",0)
    mob:setLocalVar("provokeTime",0)
    mob:setLocalVar("flashTime",0)
    mob:setLocalVar("flashCooldown",45)
    mob:setLocalVar("sentinelTime",0)
    mob:setLocalVar("sentinelCooldown",300)
    mob:setLocalVar("bashTime",0)
    mob:setLocalVar("bashCooldown",300)
    mob:setLocalVar("chivalryTime",0)
    mob:setLocalVar("chivalryCooldown",600)

    mob:addListener("COMBAT_TICK", "DISTANCE_TICK", function(mob, player, target)
        local distanceTime = mob:getLocalVar("distanceTime")
        local battletime = os.time()
        mob:moveToTarget()
         --    mob:setLocalVar("distanceTime", battletime)
        -- end
    end)

    mob:addListener("COMBAT_TICK", "COMBAT_TICK", function(mob)
        if (mob:getTP() > 1000) then
            local targ = mob:getTarget()
            weaponskill = doWeaponskill(mob)
            mob:useMobAbility(weaponskill)
        end
    end)

    mob:addListener("COMBAT_TICK", "SHIELD_BASH_TICK", function(mob, player, target)
        local battletime = os.time()
        local bashTime = mob:getLocalVar("bashTime")
        local bashCooldown = mob:getLocalVar("bashCooldown")
        if (battletime > bashTime + bashCooldown) then
            mob:useJobAbility(30, target)
            mob:setLocalVar("bashTime",battletime)
        end
    end)

    mob:addListener("COMBAT_TICK", "PROVOKE_TICK", function(mob, player, target)
        local battletime = os.time()
        local provoke = mob:getLocalVar("provokeTime")
        if (battletime > provoke + provokeCooldown) then
            mob:useJobAbility(19, target)
            mob:setLocalVar("provokeTime",battletime)
        end
    end)

    mob:addListener("COMBAT_TICK", "CUR_FLASH_TICK", function(mob, player, target)
        local battletime = os.time()
        local flashTime = mob:getLocalVar("flashTime")
        local flashCooldown = mob:getLocalVar("flashCooldown")
        if (battletime > flashTime + flashCooldown) then
            doCurillaFlash(mob, player, target)
            mob:setLocalVar("flashTime",battletime)
        end
    end)

    mob:addListener("COMBAT_TICK", "CUR_SENTINEL_TICK", function(mob, player, target)
        local battletime = os.time()
        local sentinelTime = mob:getLocalVar("sentinelTime")
        local sentinelCooldown = mob:getLocalVar("sentinelCooldown")
        if (battletime > sentinelTime + sentinelCooldown) then
            doCurillaSentinel(mob, target)
        end
    end)

    mob:addListener("COMBAT_TICK", "CUR_CURE_TICK", function(mob, player, target)
        local battletime = os.time()
        local cureTime = mob:getLocalVar("cureTimeCurilla")
        if (battletime > cureTime + cureCooldown) then
            doCurillaCure(mob, player, target)
        end
    end)

    mob:addListener("COMBAT_TICK", "CUR_CHIVALRY_TICK", function(mob, player, target)
        local battletime = os.time()
        local chivalryTime = mob:getLocalVar("chivalryTime")
        local chivalryCooldown = mob:getLocalVar("chivalryCooldown")
        local trustPointChivalry = player:getVar("TrustTrait1_Cur")
        local mp = mob:getMP()
        local maxmp = mob:getMaxMP()
        local dif = (mp / maxmp) * 100
        if (trustPointChivalry == 5) then
            if ((battletime > chivalryTime + chivalryCooldown) and dif < 20) then
                mob:useJobAbility(142, mob)
                mob:setLocalVar("chivalryTime",battletime)
            end
        end
    end)

end

function doWeaponskill(mob)
    local wsList = {{65,41},{60,40}, {17,34}, {1,33}}
    local newWsList = {}
    local lvl = mob:getMainLvl()
    local maxws = 0 -- Maximum number of weaponskills to choose from randomly
    local wscount = 0

    local finalWS = 0

    if (lvl >= 65) then
        maxws = 2
    else
        maxws = 3
    end

    for i = 1, #wsList do
        if (lvl >= wsList[i][1]) then
            table.insert(newWsList, wscount + 1, wsList[i][2])
            wscount = wscount + 1
            if (wscount >= maxws) then
                break
            end
        end
    end

    finalWS = newWsList[math.random(1,#newWsList)]
    return finalWS
end

function doCurillaFlash(mob, player, target)
    local mp = mob:getMP()
    local lvl = mob:getMainLvl()
    local battletime = os.time()
    -- Only use flash if Curilla doesn't have hate?
    local hate = enmityCalc(mob, player, target)

    if (hate > 0) then
        if (lvl >= 37 and mp >= 25) then
            mob:castSpell(112, target)
            mob:setLocalVar("flashTime",battletime)
        end
    end
end

function doCurillaSentinel(mob, target)
    local lvl = mob:getMainLvl()
    local tlvl = target:getMainLvl()
    local dlvl = tlvl - lvl
    local battletime = os.time()

    if (dlvl > 4 and lvl >= 30) then
        mob:useJobAbility(32, target)
        mob:setLocalVar("sentinelTime",battletime)
    end
end

function doCurillaCure(mob, player, target)
    local cureList = {{55,46,3}, {30,24,2}, {17,8,1}, {5,8,1}}
    local mp = mob:getMP()
    local lvl = mob:getMainLvl()
    local cure = 0
    local party = player:getParty()
    local battletime = os.time()
    for _,member in ipairs(party) do
        if (member:getHPP() <= 35) then
            cure = doEmergencyCureCur(mob)
            if (cure > 0) then
                mob:castSpell(cure, member)
                mob:setLocalVar("cureTimeCurilla",battletime)
                break
            end
        elseif (member:getHPP() <= 72) then
            for i = 1, #cureList do
                if (lvl >= cureList[i][1] and mp >= cureList[i][2]) then
                    cure = cureList[i][3]
                    if (cure > 0) then
                        mob:castSpell(cure, member)
                        mob:setLocalVar("cureTimeCurilla",battletime)
                        break
                    end
                end
            end
        end
    end

    if (cure == 0) then
        mob:setLocalVar("cureTimeCurilla",battletime - 4)
    end

end

function doEmergencyCureCur(mob)
    local cureList = {{55,88,4}, {30,46,3}, {17,24,2}, {5,8,1}}
    local mp = mob:getMP()
    local lvl = mob:getMainLvl()
    local spell = 0

    for i = 1, #cureList do
        if (lvl >= cureList[i][1] and mp >= cureList[i][2]) then
            spell = cureList[i][3]
            break
        end
    end

    return spell
end