-----------------------------------
require("scripts/globals/keyitems")
require("scripts/globals/status")
-----------------------------------

function enmityCalc(mob, player, target)

    local trustID = mob:getID()
    local trustEnmity = 0
    local party = player:getParty()
    local ce = 0
    local ve = 0
    local total = 0
    local highest = 0
    local highestID = 0
    local diff = 0
    local enmityList = {}

    for i, member in ipairs(party) do
        ce = target:getCE(member)
        ve = target:getVE(member)
        total = ve + ce
        local id = member:getID()
        if (id == trustID) then
            -- printf("Trust Enmity ID Triggered")
            -- printf("CE is %u \n",ce)
            -- printf("VE is %u \n",ve)
            -- printf("New Total is %u \n",total)
            trustEnmity = total
        end

        table.insert(enmityList, i, {total, id})
    end

    -- printf("Trust Total Enmity is %u \n",trustEnmity)

    for i, v in pairs(enmityList) do
        if (v[1] > highest) then
            highest = v[1]
            highestID = v[2]
        end
    end

    if (trustID ~= highestID) then
        -- printf("Trust Enmity is: %u \n",trustEnmity)
        -- printf("Highest Enmity is: %u \n",highest)
        diff = (highest - trustEnmity)
        -- printf("HATE LEVEL DIFF IS: %u \n",diff)
    else
        diff = 0
        -- printf("Trust Enmity is: %u \n",trustEnmity)
        -- printf("Highest Enmity is: %u \n",highest)
        -- printf("TRUST HAS HATE!! DIFF IS: %u \n",diff)
    end

    return diff
end

function getWeakness(mob, player, target)

    local weak = 0

    local fire = target:getMod(dsp.mod.FIRERES)
    local ice = target:getMod(dsp.mod.ICERES)
    local wind = target:getMod(dsp.mod.WINDRES)
    local earth = target:getMod(dsp.mod.EARTHRES)
    local thunder = target:getMod(dsp.mod.THUNDERRES)
    local water = target:getMod(dsp.mod.WATERRES)
    local light = target:getMod(dsp.mod.LIGHTRES)
    local dark = target:getMod(dsp.mod.DARKRES)

    if (fire > 1000) then
        weak = 1
    elseif (ice > 1000) then
        weak = 5
    elseif (wind > 1000) then
        weak = 2
    elseif (earth > 1000) then
        weak = 6
    elseif (thunder > 1000) then
        weak = 3
    elseif (water > 1000) then
        weak = 7
    elseif (light > 1000) then
        weak = 4
    elseif (dark > 1000) then
        weak = 8
    end

    return weak
end

function isLionInParty(mob, player, target)
    local lion = 0
    local party = player:getParty()

    for i, member in ipairs(party) do
        if (member:getName() == "Lion") then
            lion = 1
            break
        end
    end

    return lion
end

function isZeidInParty(mob, player, target)
    local zeid = 0
    local party = player:getParty()

    for i, member in ipairs(party) do
        if (member:getName() == "Zeid-S") then
            zeid = 1
            break
        end
    end

    return zeid
end

function getZeidTP(mob, player, target)
    local tp = 0
    local party = player:getParty()

    for i, member in ipairs(party) do
        if (member:getName() == "Zeid-S") then
            tp = member:getTP()
            break
        end
    end
    return tp
end

function getLionTP(mob, player, target)
    local tp = 0
    local lastWStime = 0
    local lastWS = 0
    local party = player:getParty()


    for i, member in ipairs(party) do
        if (member:getName() == "Lion") then
            tp = member:getTP()
            lastWStime = member:getLocalVar("lastWSTime")
            lastWS = member:getLocalVar("lastWS")
            break
        end
    end

    return tp,lastWStime,lastWS
end

function doRangedAttack(target, mob, numhits, dmg)
    if (mob:getSubJob() == dsp.job.SAM) then
        if (dmg > 0) then
            target:addTP(20 * numhits)
            mob:addTP(175 * numhits)
            if (mob:hasStatsEffect(dsp.effect.BARRAGE)) then
                mob:delStatusEffect(dsp.effect.BARRAGE)
            end
        end
    else
        if (dmg > 0) then
            target:addTP(20 * numhits)
            mob:addTP(150 * numhits)
            if (mob:hasStatusEffect(dsp.effect.BARRAGE)) then
                mob:delStatusEffect(dsp.effect.BARRAGE)
            end
        end
    end
end

function doBarrage(target, mob)
    local racc = mob:getRACC()
    local eva = target:getEVA()
    local lvl = mob:getMainLvl()
    local barrage = 0
    local hits = 0

    printf("Ranged Acc is %u",racc)

    if (lvl < 50) then
        barrage = 4
    elseif (lvl < 74) then
        barrage = 5
    else
        barrage = 6
    end

    local hitRate = 75 + math.floor((racc - eva) / 2)
    if (hitRate >= 95) then
        hitRate = 95
    elseif (hitRate <= 20) then
        hitRate = 20
    end

    printf("Hit Rate is %u",hitRate)
    for i = 1, barrage, 1 do
        local chance = math.random(1,100)
        printf("Chance is %u",chance)

        if (chance > hitRate) then
            break
        else
            hits = hits + 1
        end
    end

    printf("Number of hits is %u",hits)
    return hits

end

function doKupipiTrustPoints(mob)
    local player = mob:getMaster()
    local acc = 0
    local att = 0
    local curePot = 0
    local cureTime = 0

    if (player:getVar("KUPIPI_TRIB_FIGHT") == 3) then
        att = player:getVar("TrustAtt_Kup")
        acc = player:getVar("TrustAcc_Kup")
        curePot = player:getVar("TrustCure_Kup")
        cureTime = player:getVar("TrustCast_Kup")

        mob:addMod(dsp.mod.ATT,att)
        mob:addMod(dsp.mod.ACC,acc)
        mob:addMod(dsp.mod.CURE_POTENCY,curePot)
        mob:addMod(dsp.mod.CURE_CAST_TIME,cureTime)
    end
end

function doCurillaTrustPoints(mob)
    local player = mob:getMaster()
    local acc = 0
    local att = 0
    local curePot = 0
    local cureTime = 0

    if (player:getVar("CURILLA_TRIB_FIGHT") == 3) then
        att = player:getVar("TrustAtt_Cur")
        acc = player:getVar("TrustAcc_Cur")
        def = player:getVar("TrustDEF_Cur")
        enmity = player:getVar("TrustENM_Cur")

        mob:addMod(dsp.mod.ATT,att)
        mob:addMod(dsp.mod.ACC,acc)
        mob:addMod(dsp.mod.DEF,def)
        mob:addMod(dsp.mod.ENMITY,enmity)
    end
end

function doNajiTrustPoints(mob)
    local player = mob:getMaster()
    local acc = 0
    local att = 0
    local da = 0
    local berserk = 0
    local lvl = mob:getMainLvl()
    local sjob = mob:getSubJob()



    doDualWield(mob)

    if (player:getVar("CURILLA_TRIB_FIGHT") == 3) then
        att = player:getVar("TrustAtt_Naji")
        acc = player:getVar("TrustAcc_Naji")
        da = player:getVar("TrustDA_Naji")
        berserk = player:getVar("TrustBerserk_Naji")

        if (att ~= 0) then
            mob:addMod(dsp.mod.ATT,att)
        end
        if (acc ~= 0) then
            mob:addMod(dsp.mod.ACC,acc)
        end
        if (da ~= 0) then
            mob:addMod(dsp.mod.DEF,def)
        end
        if (berserk ~= 0) then
            mob:addMod(dsp.mod.BERSERK_EFFECT,berserk)
        end
    end

    -- Setup Dual Wield Delay
    if (sjob == 13) then
        if (lvl >= 50) then
            mob:addMod(dsp.mod.DELAY,-80)
        elseif (lvl >= 20) then
           mob:addMod(dsp.mod.DELAY,-70)
        end
    end

end

function doDualWield(mob)
    local level = mob:getMainLvl()
    local job = mob:getMainJob()
    if (level >= 20) then
        if (job == 1) then  -- This is to make the main hand swing twice for normal dual wield and three times for DA on "offhand"
            mob:setMod(dsp.mod.MYTHIC_OCC_ATT_TWICE,90)
            mob:setMod(dsp.mod.MYTHIC_OCC_ATT_THRICE,10)
        else
            mob:setMod(dsp.mod.MYTHIC_OCC_ATT_TWICE,100)
        end
    end
end


function trustPoints(mob, player)
local trustTokens = player:getVar("TrustTokens");
local tokenCap = 35;

local AdelheidTokens = player:getVar("CurrentTokens_Adelheid");
local AdelheidPoints = player:getVar("CurrentPoints_Adelheid");

local AyameTokens = player:getVar("CurrentTokens_Ayame");
local AyamePoints = player:getVar("CurrentPoints_Ayame");

local CurillaTokens = player:getVar("CurrentTokens_Curilla");
local CurillaPoints = player:getVar("CurrentPoints_Curilla");

local DarcullinTokens = player:getVar("CurrentTokens_Darcullin");
local DarcullinPoints = player:getVar("CurrentPoints_Darcullin");

local ExcenmilleTokens = player:getVar("CurrentTokens_Excenmille");
local ExcenmillePoints = player:getVar("CurrentPoints_Excenmille");

local KupipiTokens = player:getVar("CurrentTokens_Kupipi");
local KupipiPoints = player:getVar("CurrentPoints_Kupipi");

local LionTokens = player:getVar("CurrentTokens_Lion");
local LionPoints = player:getVar("CurrentPoints_Lion");

local NanaaTokens = player:getVar("CurrentTokens_Nanaa");
local NanaaPoints = player:getVar("CurrentPoints_Nanaa");

local NajiTokens = player:getVar("CurrentTokens_Naji");
local NajiPoints = player:getVar("CurrentPoints_Naji");

local ZeidTokens = player:getVar("CurrentTokens_Zeid");
local ZeidPoints = player:getVar("CurrentPoints_Zeid");


local curillaTrib = player:getVar("CURILLA_TRIB_FIGHT");
local excenmilleTrib = player:getVar("EXCEN_TRIB_FIGHT");
local ayameTrib = player:getVar("AYAME_TRIB_FIGHT");
local najiTrib = player:getVar("NAJI_TRIB_FIGHT");

local kupipiTrib = player:getVar("KUPIPI_TRIB_FIGHT");
local nanaaTrib = player:getVar("NANAA_TRIB_FIGHT");


local lionTrib = player:getVar("LION_TRIB_FIGHT");
local darcullinTrib = player:getVar("DARC_TRIB_FIGHT");
local zeidTrib = player:getVar("ZEID_TRIB_FIGHT");
local adelheidTrib = player:getVar("ADEL_TRIB_FIGHT");

local pet;
local trustpoint = mob:getBaseExp() * 1;





	if ((((not player:isUniqueAlly(75)) and (najiTrib == 3)) or ((not player:isUniqueAlly(76)) and (kupipiTrib == 3)) or
		    ((not player:isUniqueAlly(77)) and (ayameTrib == 3)) or ((not player:isUniqueAlly(78)) and (nanaaTrib == 3)) or
			((not player:isUniqueAlly(79)) and (curillaTrib == 3)) or ((not player:isUniqueAlly(80)) and (excenmilleTrib == 3)) or
			((not player:isUniqueAlly(81)) and (darcullinTrib == 3)) or ((not player:isUniqueAlly(82)) and (adelheidTrib == 3)) or
			((not player:isUniqueAlly(86)) and (lionTrib == 3)) or ((not player:isUniqueAlly(91)) and (zeidTrib == 3))) and player:getMainLvl() >= 75) then-- Means that they are in the party.  Need to list all because it displays trust points
	        player:PrintToPlayer("You receive "..trustpoint.." Trust Points!!!", 0x15);
            -- Naji
	        if ((not player:isUniqueAlly(75)) and (najiTrib == 3)) then
		        player:setVar("CurrentPoints_Naji", NajiPoints + trustpoint);
			    NajiPoints = player:getVar("CurrentPoints_Naji");
			    if (NajiPoints > 10000) then
			        player:setVar("CurrentTokens_Naji", NajiTokens + 1);
					if (player:getVar("CurrentTokens_Naji", NajiTokens) >= 35) then
					    player:setVar("CurrentTokens_Naji", 35);
					end
				    NajiTokens = player:getVar("CurrentTokens_Naji");
	                player:PrintToPlayer("You obtain "..NajiTokens.." Trust Token(Naji).  Total: ("..NajiTokens.."/"..tokenCap..").", 0x15);
				    player:setVar("CurrentPoints_Naji", NajiPoints - 10000);
	            end
	        end
            -- Kupipi
	        if ((not player:isUniqueAlly(76)) and (kupipiTrib == 3)) then
		        player:setVar("CurrentPoints_Kupipi", KupipiPoints + trustpoint);
			    KupipiPoints = player:getVar("CurrentPoints_Kupipi");
			    if (KupipiPoints > 10000) then
					player:setVar("CurrentTokens_Kupipi", KupipiTokens + 1);
					if (player:getVar("CurrentTokens_Kupipi", KupipiTokens) >= 35) then
					    player:setVar("CurrentTokens_Kupipi", 35);
					end
					KupipiTokens = player:getVar("CurrentTokens_Kupipi");
					player:PrintToPlayer("You obtain "..KupipiTokens.." Trust Token(Kupipi).  Total: ("..KupipiTokens.."/"..tokenCap..").", 0x15);
					player:setVar("CurrentPoints_Kupipi", KupipiPoints - 10000);
				end
			end
			-- Ayame
			if ((not player:isUniqueAlly(77)) and (ayameTrib == 3)) then
				player:setVar("CurrentPoints_Ayame", AyamePoints + trustpoint);
				AyamePoints = player:getVar("CurrentPoints_Ayame");
				if (AyamePoints > 10000) then
					player:setVar("CurrentTokens_Ayame", AyameTokens + 1);
					if (player:getVar("CurrentTokens_Ayame", AyameTokens) >= 35) then
					    player:setVar("CurrentTokens_Ayame", 35);
					end
					AyameTokens = player:getVar("CurrentTokens_Ayame");
					player:PrintToPlayer("You obtain "..AyameTokens.." Trust Token(Ayame).  Total: ("..AyameTokens.."/"..tokenCap..").", 0x15);
					player:setVar("CurrentPoints_Ayame", AyamePoints - 10000);
				end
			end
			-- Nanaa
			if ((not player:isUniqueAlly(78)) and (nanaaTrib == 3)) then
				player:setVar("CurrentPoints_Nanaa", NanaaPoints + trustpoint);
				NanaaPoints = player:getVar("CurrentPoints_Nanaa");
				if (NanaaPoints > 10000) then
					player:setVar("CurrentTokens_Nanaa", NanaaTokens + 1);
					if (player:getVar("CurrentTokens_Nanaa", NanaaTokens) >= 35) then
					    player:setVar("CurrentTokens_Nanaa", 35);
					end
					NanaaTokens = player:getVar("CurrentTokens_Nanaa");
					player:PrintToPlayer("You obtain "..NanaaTokens.." Trust Token(Nanaa).  Total: ("..NanaaTokens.."/"..tokenCap..").", 0x15);
					player:setVar("CurrentPoints_Nanaa", NanaaPoints - 10000);
				end
			end
			-- Curilla
			if ((not player:isUniqueAlly(79)) and (curillaTrib == 3)) then
				player:setVar("CurrentPoints_Curilla", CurillaPoints + trustpoint);
				CurillaPoints = player:getVar("CurrentPoints_Curilla");
				if (CurillaPoints > 10000) then
					player:setVar("CurrentTokens_Curilla", CurillaTokens + 1);
					if (player:getVar("CurrentTokens_Curilla", CurillaTokens) >= 35) then
					    player:setVar("CurrentTokens_Curilla", 35);
					end
					CurillaTokens = player:getVar("CurrentTokens_Curilla");
					player:PrintToPlayer("You obtain "..CurillaTokens.." Trust Token(Curilla).  Total: ("..CurillaTokens.."/"..tokenCap..").", 0x15);
					player:setVar("CurrentPoints_Curilla", CurillaPoints - 10000);
				end
			end
			-- Excenmille
			if ((not player:isUniqueAlly(80)) and (excenmilleTrib == 3)) then
				player:setVar("CurrentPoints_Excenmille", ExcenmillePoints + trustpoint);
				ExcenmillePoints = player:getVar("CurrentPoints_Excenmille");
				if (ExcenmillePoints > 10000) then
					player:setVar("CurrentTokens_Excenmille", ExcenmilleTokens + 1);
					if (player:getVar("CurrentTokens_Excenmille", ExcenmilleTokens) >= 35) then
					    player:setVar("CurrentTokens_Excenmille", 35);
					end
					ExcenmilleTokens = player:getVar("CurrentTokens_Excenmille");
					player:PrintToPlayer("You obtain "..ExcenmilleTokens.." Trust Token(Excenmille).  Total: ("..ExcenmilleTokens.."/"..tokenCap..").", 0x15);
					player:setVar("CurrentPoints_Excenmille", ExcenmillePoints - 10000);
				end
			end
			-- Darcullin
			if ((not player:isUniqueAlly(81)) and (darcullinTrib == 3)) then
				player:setVar("CurrentPoints_Darcullin", DarcullinPoints + trustpoint);
				DarcullinPoints = player:getVar("CurrentPoints_Darcullin");
				if (DarcullinPoints > 10000) then
					player:setVar("CurrentTokens_Darcullin", DarcullinTokens + 1);
					if (player:getVar("CurrentTokens_Darcullin", DarcullinTokens) >= 35) then
					    player:setVar("CurrentTokens_Darcullin", 35);
					end
					DarcullinTokens = player:getVar("CurrentTokens_Darcullin");
					player:PrintToPlayer("You obtain "..DarcullinTokens.." Trust Token(Darcullin).  Total: ("..DarcullinTokens.."/"..tokenCap..").", 0x15);
					player:setVar("CurrentPoints_Darcullin", DarcullinPoints - 10000);
				end
			end
			-- Adelheid
			if ((not player:isUniqueAlly(82)) and (adelheidTrib == 3)) then
				player:setVar("CurrentPoints_Adelheid", AdelheidPoints + trustpoint);
				AdelheidPoints = player:getVar("CurrentPoints_Adelheid");
				if (AdelheidPoints > 10000) then
					player:setVar("CurrentTokens_Adelheid", AdelheidTokens + 1);
					if (player:getVar("CurrentTokens_Adelheid", AdelheidTokens) >= 35) then
					    player:setVar("CurrentTokens_Adelheid", 35);
					end
					AdelheidTokens = player:getVar("CurrentTokens_Adelheid");
					player:PrintToPlayer("You obtain "..AdelheidTokens.." Trust Token(Adelheid).  Total: ("..AdelheidTokens.."/"..tokenCap..").", 0x15);
					player:setVar("CurrentPoints_Adelheid", AdelheidPoints - 10000);
				end
			end
			-- Lion
			if ((not player:isUniqueAlly(86)) and (lionTrib == 3)) then
				player:setVar("CurrentPoints_Lion", LionPoints + trustpoint);
				LionPoints = player:getVar("CurrentPoints_Lion");
				if (LionPoints > 10000) then
					player:setVar("CurrentTokens_Lion", LionTokens + 1);
					if (player:getVar("CurrentTokens_Lion", LionTokens) >= 35) then
					    player:setVar("CurrentTokens_Lion", 35);
					end
					LionTokens = player:getVar("CurrentTokens_Lion");
					player:PrintToPlayer("You obtain "..LionTokens.." Trust Token(Lion).  Total: ("..LionTokens.."/"..tokenCap..").", 0x15);
					player:setVar("CurrentPoints_Lion", LionPoints - 10000);
				end
			end

			-- Zeid
			if ((not player:isUniqueAlly(91)) and (zeidTrib == 3)) then
				player:setVar("CurrentPoints_Zeid", ZeidPoints + trustpoint);
				ZeidPoints = player:getVar("CurrentPoints_Zeid");
				if (ZeidPoints > 10000) then
					player:setVar("CurrentTokens_Zeid", ZeidTokens + 1);
					if (player:getVar("CurrentTokens_Zeid", ZeidTokens) >= 35) then
					    player:setVar("CurrentTokens_Zeid", 35);
					end
					ZeidTokens = player:getVar("CurrentTokens_Zeid");
					player:PrintToPlayer("You obtain "..ZeidTokens.." Trust Token(Zeid).  Total: ("..ZeidTokens.."/"..tokenCap..").", 0x15);
					player:setVar("CurrentPoints_Zeid", ZeidPoints - 10000);
				end
			end

		end
end;