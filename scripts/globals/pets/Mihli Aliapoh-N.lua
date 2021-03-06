-------------------------------------------------
--  Trust: Mihli
--  Magic: Cure I-VI, Protect/ra I-IV Shell/ra I-IV
--    -na Spells, Slow, Paralyze, Erase, Flash
--  JA: None
--  WS: Starlight, Moonlight
--  Source: http://bg-wiki.com/bg/Category:Trust
-------------------------------------------------
require("scripts/globals/status")
require("scripts/globals/msg")
require("scripts/globals/trustpoints")

function onMobSpawn(mob)
    -- doKupipiTrustPoints(mob)
    local weaponskill = 0
    local cureCooldown = 14
    local debuffCooldown = 10
    local buffCooldown = 7
    local ailmentCooldown = 20
    local master = mob:getMaster()
    local kupipi = mob:getID()
    local angle = 115
    local wsCooldown = 4
    local utsuIchiCooldown = 30
    local utsuNiCooldown = 45

    mob:setLocalVar("wsTime",0)
    mob:setLocalVar("cureTime",0)
    mob:setLocalVar("debuffTime",0)
    mob:setLocalVar("ailmentTime",0)
    mob:setLocalVar("buffTime",0)
    mob:setLocalVar("paraTime",0)
    mob:setLocalVar("slowTime",0)
    mob:setLocalVar("flashTime",0)
    mob:setLocalVar("utsuIchiTime",0)
    mob:setLocalVar("utsuNiTime",0)


    mob:addListener("COMBAT_TICK", "MIHLI_BUFF_TICK", function(mob, player, target)
        local battletime = os.time()
        local buffTime = mob:getLocalVar("buffTime")

        if (battletime > buffTime + buffCooldown) then
            doBuff(mob, player)
        end
    end)

    mob:addListener("COMBAT_TICK", "MIHLI_AILMENT_TICK", function(mob, player, target)
        local battletime = os.time()
        local ailmentTime = mob:getLocalVar("ailmentTime")

        if (battletime > ailmentTime + ailmentCooldown) then
            local spell = doMihliStatusRemoval(mob)
            if (spell > 0 ) then
                mob:castSpell(spell, mob)
            end
            mob:setLocalVar("ailmentTime",battletime)
        end
    end)

    mob:addListener("COMBAT_TICK", "MIHLI_CURE_TICK", function(mob, player, target)
        local battletime = os.time()
        local cureTime = mob:getLocalVar("cureTime")

        if (battletime > cureTime + cureCooldown) then
            local party = player:getPartyWithTrusts()
            for _,member in ipairs(party) do
                if (member:getHPP() <= 25) then
                    local spell = doEmergencyCureMihli(mob)
                    if (spell > 0) then
                        mob:castSpell(spell, member)
                        mob:setLocalVar("cureTime",battletime)
                        break
                    end
                elseif (member:getHPP() <= 60) then
                    local spell = doCureMihli(mob)
                    if (spell > 0) then
                        mob:castSpell(spell, member)
                        mob:setLocalVar("cureTime",battletime)
                        break
                    end
                end
            end
            mob:setLocalVar("cureTime",battletime - 4)  -- If no member has low HP change global check to 8 seconds
        end
    end)

    mob:addListener("COMBAT_TICK", "MIHLI_COMBAT_TICK", function(mob, player, target)
        local tlvl = target:getMainLvl()
        local lvl = mob:getMainLvl()
        local dlvl = tlvl - lvl
        if (dlvl >= 5) then
            trustMageMove(mob, player, target, angle)
        else
            trustMeleeMove(mob, mob, target, angle)
        end

        local battletime = os.time()
        local weaponSkillTime = mob:getLocalVar("wsTime")
        if (mob:getTP() >= 1000 and (battletime > weaponSkillTime + wsCooldown)) then
            weaponskill = doMihliWeaponskill(mob)
            mob:useMobAbility(weaponskill, target)
            mob:setLocalVar("wsTime",battletime)
        end
    end)

    mob:addListener("COMBAT_TICK", "MIHLI_UTSU_TICK", function(mob, player, target)
        local battletime = os.time()
        local utsuIchi = mob:getLocalVar("utsuIchiTime")
        local utsuNi = mob:getLocalVar("utsuNiTime")
        local shadows = mob:getStatusEffect(dsp.effect.COPY_IMAGE)
        local count = 0
        if (shadows ~= nil) then
            count = shadows:getPower()
        else
            count = 0
        end

        if ((battletime > utsuNi + utsuNiCooldown) and lvl >= 37 and (count == nil or count <= 1)) then
            mob:castSpell(339, mob)
            mob:setLocalVar("utsuNiTime",battletime)
        elseif ((battletime > utsuIchi + utsuIchiCooldown) and lvl >= 12 and (count == nil)) then
            mob:castSpell(338, mob)
            mob:setLocalVar("utsuIchiTime",battletime)
        end
    end)

end

function doMihliStatusRemoval(mob)
    local mp = mob:getMP()
    local lvl = mob:getMainLvl()
    local spell = 0

    if (mob:hasStatusEffect(dsp.effect.POISON) and lvl >= 6 and mp >= 8) then
        spell = 14
    elseif (mob:hasStatusEffect(dsp.effect.PARALYSIS) and lvl >= 9 and mp >= 12) then
        spell = 15
    elseif (mob:hasStatusEffect(dsp.effect.BLINDNESS) and lvl >= 14 and mp >= 16) then
        spell = 16
    elseif (mob:hasStatusEffect(dsp.effect.SILENCE) and lvl >= 19 and mp >= 24) then
        spell = 17
    elseif (mob:hasStatusEffect(dsp.effect.CURSE_I) and lvl >= 29 and mp >= 30) then
        spell = 20
    elseif (mob:hasStatusEffectByFlag(dsp.effectFlag.ERASABLE) and lvl >= 32 and mp >= 18) then
        spell = 143
    elseif (mob:hasStatusEffect(dsp.effect.DISEASE) and lvl >= 34 and mp >= 20) then
        spell = 19
    elseif (mob:hasStatusEffect(dsp.effect.PETRIFICATION) and lvl >= 39 and mp >= 40) then
        spell = 18
    end

    return spell
end

function doMihliWeaponskill(mob)
    local wsList = {{2092, 72}, {65,168},{60, 167}{55,165}, {20,161}, {1,160}}
    local maxws = 3

    local newWsList = {}
    local maxws = 3 -- Maximum number of weaponskills to choose from randomly
    local wscount = 0
    local lvl = mob:getMainLvl()
    local finalWS = 0

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

function doBuff(mob, player)
    local proRaList = {}
    local shellRaList = {}
    if (player:getVar("TrustPro_Mihli") == 1) then
        proRaList = {{75,84,129},{63,65,128}, {47,46,127}, {27,28,126}, {7,9,125}}
    else
        proRaList = {{63,65,128}, {47,46,127}, {27,28,126}, {7,9,125}}
    end

    if (player:getVar("TrustShell_Mihli") == 1) then
        shellRaList = {{75,93,134},{68,75,133}, {57,56,132}, {37,37,131}, {17,18,130}}
    else
        shellRaList = {{68,75,133}, {57,56,132}, {37,37,131}, {17,18,130}}
    end

    local proList = {{63,65,46}, {47,46,45}, {27,28,44}, {7,9,43}}
    local shellList = {{68,75,51}, {57,56,50}, {37,37,49}, {17,18,48}}
    local battletime = os.time()
    local mp = mob:getMP()
    local lvl = mob:getMainLvl()
    local party = player:getPartyWithTrusts()
    local pro = 0
    local shell = 0
    local procount = 0
    local shellcount = 0

    for i,member in pairs(party) do
        if (not member:hasStatusEffect(dsp.effect.PROTECT)) then
            procount = procount + 1
            if (procount >= 2) then -- do protectra instead
                for i = 1, #proRaList do
                    if (lvl >= proRaList[i][1] and mp >= proRaList[i][2]) then
                        pro = proRaList[i][3]
                        break
                    end
                end
                mob:castSpell(pro, mob)
                mob:setLocalVar("buffTime",battletime)
                break
            end
        end
    end

    if (procount == 1) then
        for i,member in pairs(party) do
            if (not member:hasStatusEffect(dsp.effect.PROTECT)) then
                for i = 1, #proList do
                    if (lvl >= proList[i][1] and mp >= proList[i][2]) then
                        pro = proList[i][3]
                        break
                    end
                end
                mob:castSpell(pro, member)
                mob:setLocalVar("buffTime",battletime)
                break
            end
        end
    end

    for i,member in pairs(party) do
        if (not member:hasStatusEffect(dsp.effect.SHELL)) then
            shellcount = shellcount + 1
            if (shellcount >= 2) then
                for i = 1, #shellRaList do
                    if (lvl >= shellRaList[i][1] and mp >= shellRaList[i][2]) then
                        shell = shellRaList[i][3]
                        break
                    end
                end
                mob:castSpell(shell, mob)
                mob:setLocalVar("buffTime",battletime)
                break
            end
        end
    end

    if (shellcount == 1) then
        for i,member in pairs(party) do
            if (not member:hasStatusEffect(dsp.effect.SHELL)) then
                for i = 1, #proList do
                    if (lvl >= shellList[i][1] and mp >= shellList[i][2]) then
                        shell = shellList[i][3]
                        break
                    end
                end
                mob:castSpell(shell, member)
                mob:setLocalVar("buffTime",battletime)
                break
            end
        end
    end
end

function doCureMihli(mob)
    local cureList = {{41,88,4}, {21,46,3}, {11,24,2}, {1,8,1}}
    local mp = mob:getMP()
    local lvl = mob:getMainLvl()
    local cure = 0

    for i = 1, #cureList do
        if (lvl >= cureList[i][1] and mp >= cureList[i][2]) then
            cure = cureList[i][3]
            break
        end
    end

    return cure
end

function doEmergencyCureMihli(mob)
    local cureList = {{61,135,5}, {41,88,4}, {21,46,3}, {11,24,2}, {1,8,1}}
    local mp = mob:getMP()
    local lvl = mob:getMainLvl()
    local cure = 0

    for i = 1, #cureList do
        if (lvl >= cureList[i][1] and mp >= cureList[i][2]) then
            cure = cureList[i][3]
            break
        end
    end

    return cure
end