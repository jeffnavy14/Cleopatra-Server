-----------------------------------
-- Area: Windurst Walls
--  NPC: Nanaa Mihgo
-- Starts and Finishes Quest: Mihgo's Amigo (R), The Tenshodo Showdown (start), Rock Racketeer (start)
-- Involved In Quest: Crying Over Onions
-- Involved in Mission 2-1
-- !pos 62 -4 240 241
-----------------------------------
require("scripts/globals/keyitems")
require("scripts/globals/missions")
require("scripts/globals/npc_util")
require("scripts/globals/settings")
require("scripts/globals/quests")
require("scripts/globals/status")
require("scripts/globals/titles")
-----------------------------------

function onTrade(player,npc,trade)
    if npcUtil.tradeHas(trade, {{498,4}}) then -- Yagudo Necklace x4
        local mihgosAmigo = player:getQuestStatus(WINDURST,dsp.quest.id.windurst.MIHGO_S_AMIGO)

        if mihgosAmigo == QUEST_ACCEPTED then
            player:startEvent(88, GIL_RATE*200)
        elseif mihgosAmigo == QUEST_COMPLETED then
            player:startEvent(494, GIL_RATE*200)
        end
    end

    local currentTokens = player:getVar("CurrentTokens_Nanaa");

    local sjQuest = player:getVar("TRUST_SJ_QUEST")
    local war = 11988;
    local rdm = 11992;
    local sam = 11999;
    local nin = 12000;
    if (trade:hasItemQty(war, 1) and sjQuest >= 1) then
        player:setVar("NANAA_TYPE", 1)
        player:PrintToPlayer("Nanaa Mihgo: Ok my subjob is now Warrior", 0x15);
    elseif (trade:hasItemQty(nin, 1) and sjQuest == 4) then
        player:setVar("NANAA_TYPE", 2)
        player:PrintToPlayer("Nanaa Mihgo: Subjob is now Ninja!", 0x15);
    end

    if ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 0) and (trade:hasItemQty(65535, 1000)) and (currentTokens >= 1)) then
      player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's Attack is raised by 5 points! (Total: 5)", 0x15);
	  player:setVar("TrustAtt_Nanaa",5);
	  player:setVar("TributeRank_Nanaa",1);
	  currentTokens = currentTokens - 1;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    elseif ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 1) and (trade:hasItemQty(65535, 2000)) and (currentTokens >= 2)) then
	  player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's Accuracy is raised by 5 points! (Total: 5)", 0x15);
	  player:setVar("TrustAcc_Nanaa",5);
	  player:setVar("TributeRank_Nanaa",2);
	  currentTokens = currentTokens - 2;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    elseif ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 2) and (trade:hasItemQty(65535, 3000)) and (currentTokens >= 3)) then
      player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's DEX has been raised by 5! (Total: 5)", 0x15);
	  player:setVar("TrustDEX_Nanaa",5);
	  player:setVar("TributeRank_Nanaa",3);
	  currentTokens = currentTokens - 3;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    elseif ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 3) and (trade:hasItemQty(65535, 4000)) and (currentTokens >= 4)) then
      player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's Attack is raised by 5 points! (Total: 10)", 0x15);
	  player:setVar("TrustAtt_Nanaa",10);
	  player:setVar("TributeRank_Nanaa",4);
	  currentTokens = currentTokens - 4;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    elseif ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 4) and (trade:hasItemQty(65535, 5000)) and (currentTokens >= 5)) then
      player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's Accuracy is raised by 5 points! (Total: 10)", 0x15);
	  player:setVar("TrustAcc_Nanaa",10);
	  player:setVar("TributeRank_Nanaa",5);
	  currentTokens = currentTokens - 5;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    elseif ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 5) and (trade:hasItemQty(65535, 10000)) and (currentTokens >= 10)) then
      player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's DEX has been raised by 5! (Total: 10)", 0x15);
	  player:setVar("TrustDEX_Nanaa",10);
	  player:setVar("TributeRank_Nanaa",6);
	  currentTokens = currentTokens - 10;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    elseif ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 6) and (trade:hasItemQty(65535, 15000)) and (currentTokens >= 15)) then
      player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's Attack is raised by 5 points! (Total: 15)", 0x15);
	  player:setVar("TrustAtt_Nanaa",15);
	  player:setVar("TributeRank_Nanaa",7);
	  currentTokens = currentTokens - 15;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    elseif ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 7) and (trade:hasItemQty(65535, 30000)) and (currentTokens >= 20)) then
      player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's Accuracy is raised by 5 points! (Total: 15)", 0x15);
	  player:setVar("TrustAcc_Nanaa",15);
	  player:setVar("TributeRank_Nanaa",8);
	  currentTokens = currentTokens - 20;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    elseif ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 8) and (trade:hasItemQty(65535, 75000)) and (currentTokens >= 30)) then
      player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's Triple Attack has been increased by 3 (Total: 3)", 0x15);
	  player:setVar("TrustTA_Nanaa",3);
	  player:setVar("TributeRank_Nanaa",9);
	  currentTokens = currentTokens - 30;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    elseif ((player:getVar("NANAA_TRIB_FIGHT") == 3) and (player:getVar("TributeRank_Nanaa") == 9) and (trade:hasItemQty(65535, 150000)) and (currentTokens >= 35)) then
      player:PrintToPlayer("Nanaa Mihgo : Thank you for your Tribute.",0x0D);
      player:PrintToPlayer("Nanaa Mihgo's obtains the trait 'Treasure Hunter II'!", 0x15);
	  player:setVar("TrustTH_Nanaa",1);
	  player:setVar("TributeRank_Nanaa",10);
	  currentTokens = currentTokens - 35;
	  player:setVar("CurrentTokens_Nanaa",currentTokens);
    else
      player:PrintToPlayer("Nanaa Mihgo : Please trade the correct amount of Tokens and Gil.",0x0D);
	end
end

function onTrigger(player,npc)
    local missionStatus = player:getVar("MissionStatus")
    local wildcatWindurst = player:getVar("WildcatWindurst")
    local mihgosAmigo = player:getQuestStatus(WINDURST,dsp.quest.id.windurst.MIHGO_S_AMIGO)
    local tenshodoShowdown = player:getQuestStatus(WINDURST,dsp.quest.id.windurst.THE_TENSHODO_SHOWDOWN)
    local tenshodoShowdownCS = player:getVar("theTenshodoShowdownCS")
    local rockRacketeer = player:getQuestStatus(WINDURST,dsp.quest.id.windurst.ROCK_RACKETEER)
    local rockRacketeerCS = player:getVar("rockracketeer_sold")
    local thickAsThieves = player:getQuestStatus(WINDURST,dsp.quest.id.windurst.AS_THICK_AS_THIEVES)
    local thickAsThievesCS = player:getVar("thickAsThievesCS")
    local thickAsThievesGrapplingCS = player:getVar("thickAsThievesGrapplingCS")
    local thickAsThievesGamblingCS = player:getVar("thickAsThievesGamblingCS")
    local hittingTheMarquisate = player:getQuestStatus(WINDURST,dsp.quest.id.windurst.HITTING_THE_MARQUISATE)
    local hittingTheMarquisateYatnielCS = player:getVar("hittingTheMarquisateYatnielCS")
    local hittingTheMarquisateHagainCS = player:getVar("hittingTheMarquisateHagainCS")
    local hittingTheMarquisateNanaaCS = player:getVar("hittingTheMarquisateNanaaCS")
    local job = player:getMainJob()
    local lvl = player:getMainLvl()

    local srank = player:getRank();
	local wrank = player:getRank();
	local brank = player:getRank();
    local pNation = player:getNation();

    local tribfight = player:getVar("NANAA_TRIB_FIGHT");
	local mainlvl = player:getMainLvl();


	if ((pNation == 0 and player:hasCompletedMission(pNation,2) == true) and (player:hasKeyItem(dsp.ki.RED_INSTITUTE_CARD)) and (player:hasSpell(901) == false)) then  -- Sandy Rnak 4 or higher
        player:PrintToPlayer("Your Red Institute Card flashes brilliantly!", 0x1C);
        player:PrintToPlayer("Nanaa Mihgo : Ah a Red Institute Card.  From now on, you can summon me to help you with your battles", 0xD);
        player:addSpell(901);
	elseif ((pNation == 2 and player:hasCompletedMission(pNation,0) == true) and (player:hasKeyItem(dsp.ki.GREEN_INSTITUTE_CARD)) and (player:hasSpell(901) == false)) then  -- Sandy Rnak 4 or higher
        player:PrintToPlayer("Your Green Institute Card flashes brilliantly!", 0x1C);
        player:PrintToPlayer("Nanaa Mihgo : Ah a Green Institute Card.  From now on, you can summon me to help you with your battles", 0xD);
        player:addSpell(901);
	elseif ((pNation == 1 and player:hasCompletedMission(pNation,2) == true) and (player:hasKeyItem(dsp.ki.BLUE_INSTITUTE_CARD)) and (player:hasSpell(901) == false)) then  -- Sandy Rnak 4 or higher
        player:PrintToPlayer("Your Green Institute Card flashes brilliantly!", 0x1C);
        player:PrintToPlayer("Nanaa Mihgo : Ah a Blue Institute Card.  From now on, you can summon me to help you with your battles", 0xD);
        player:addSpell(901);
	elseif ((mainlvl >= 71 and tribfight == 0 and (player:hasSpell(901)) and (player:getVar("FerretoryAura") >= 7) and (player:getVar("TRIB_FIGHT") ~= 1))) then
        player:PrintToPlayer("Nanaa Mihgo : There is someone running around claming to be me at Balgas Dias.  Please head there and I'll join you.", 0xD);
        player:PrintToPlayer("Nanaa Mihgo : When you are ready, examine the Burning Circle in Balgas Dias and call me to your side.", 0xD);
        player:setVar("NANAA_TRIB_FIGHT",1);
        player:setVar("TRIB_FIGHT",1);
	elseif (mainlvl >= 75 and tribfight == 2 and (player:hasSpell(901))) then
        player:PrintToPlayer("Nanaa Mihgo : You have done well to help with the imposter investigation.  I am in your debt.", 0xD);
        player:PrintToPlayer("You are now able to collect Trust Tokens for Nanaa Mihgo!", 0x15);
        player:setVar("NANAA_TRIB_FIGHT",3);
        player:setVar("TRIB_FIGHT",0);
    end

    -- WINDURST 2-1: LOST FOR WORDS
    if player:getCurrentMission(WINDURST) == dsp.mission.id.windurst.LOST_FOR_WORDS and missionStatus > 0 and missionStatus < 5 then
        if missionStatus == 1 then
            player:startEvent(165, 0, dsp.ki.LAPIS_CORAL, dsp.ki.LAPIS_MONOCLE)
        elseif missionStatus == 2 then
            player:startEvent(166, 0, dsp.ki.LAPIS_CORAL, dsp.ki.LAPIS_MONOCLE)
        elseif missionStatus == 3 then
            player:startEvent(169)
        else
            player:startEvent(170)
        end

    -- LURE OF THE WILDCAT (WINDURST)
    elseif player:getQuestStatus(WINDURST, dsp.quest.id.windurst.LURE_OF_THE_WILDCAT_WINDURST) == QUEST_ACCEPTED and not player:getMaskBit(wildcatWindurst,4) then
        player:startEvent(732)

    -- CRYING OVER ONIONS
    elseif player:getVar("CryingOverOnions") == 1 then
        player:startEvent(598)

    -- THE TENSHODO SHOWDOWN
    elseif job == dsp.job.THF and lvl >= AF1_QUEST_LEVEL and tenshodoShowdown == QUEST_AVAILABLE then
        player:startEvent(496) -- start quest
    elseif tenshodoShowdownCS == 1 then
        player:startEvent(497) -- before cs at tensho HQ
    elseif tenshodoShowdownCS >= 2 then
        player:startEvent(498) -- after cs at tensho HQ
    elseif job == dsp.job.THF and lvl < AF2_QUEST_LEVEL and tenshodoShowdown == QUEST_COMPLETED then
        player:startEvent(503) -- standard dialog after

    -- THICK AS THIEVES
    elseif job == dsp.job.THF and lvl >= AF2_QUEST_LEVEL and thickAsThieves == QUEST_AVAILABLE and tenshodoShowdown == QUEST_COMPLETED then
        player:startEvent(504) -- start quest
    elseif thickAsThievesCS >= 1 and thickAsThievesCS <= 4 and thickAsThievesGamblingCS <= 7 and thickAsThievesGrapplingCS <= 7 then
        player:startEvent(505, 0, dsp.ki.GANG_WHEREABOUTS_NOTE) -- before completing grappling and gambling sidequests
    elseif thickAsThievesGamblingCS == 8 and thickAsThievesGrapplingCS == 8 then
        player:startEvent(508) -- complete quest

    -- HITTING THE MARQUISATE
    elseif job == dsp.job.THF and lvl >= AF3_QUEST_LEVEL and thickAsThieves == QUEST_COMPLETED and hittingTheMarquisate == QUEST_AVAILABLE then
        player:startEvent(512) -- start quest
    elseif hittingTheMarquisateYatnielCS == 3 and hittingTheMarquisateHagainCS == 9 then
        player:startEvent(516) -- finish first part
    elseif hittingTheMarquisateNanaaCS == 1 then
        player:startEvent(517) -- second part

    -- ROCK RACKETEER
    elseif mihgosAmigo == QUEST_COMPLETED and rockRacketeer == QUEST_AVAILABLE and player:getFameLevel(WINDURST) >= 3 then
        if player:needToZone() then
            player:startEvent(89) -- complete
        else
            player:startEvent(93) -- quest start
        end
    elseif rockRacketeer == QUEST_ACCEPTED and rockRacketeerCS == 1 then
        player:startEvent(98) -- advance quest talk to Varun
    elseif rockRacketeer == QUEST_ACCEPTED and rockRacketeerCS == 2 then
        player:startEvent(95) -- not sold reminder
    elseif rockRacketeer == QUEST_ACCEPTED then
        player:startEvent(94) -- quest reminder

    -- MIHGO'S AMIGO
    elseif mihgosAmigo == QUEST_AVAILABLE then
        if player:getQuestStatus(WINDURST, dsp.quest.id.windurst.CRYING_OVER_ONIONS) == QUEST_AVAILABLE then
            player:startEvent(81) -- Start Quest "Mihgo's Amigo" with quest "Crying Over Onions" Activated
        else
            player:startEvent(80) -- Start Quest "Mihgo's Amigo"
        end
    elseif mihgosAmigo == QUEST_ACCEPTED then
        player:startEvent(82)

    -- STANDARD DIALOG
    elseif rockRacketeer == QUEST_COMPLETED then
        player:startEvent(99) -- new dialog after Rock Racketeer
    elseif mihgosAmigo == QUEST_COMPLETED then
        player:startEvent(89) -- new dialog after Mihgo's Amigos
    else
        player:startEvent(76) -- standard dialog
    end
end

function onEventUpdate(player,csid,option)
end

function onEventFinish(player,csid,option)
    -- WINDURST 2-1: LOST FOR WORDS
    if csid == 165 and option == 1 then
        npcUtil.giveKeyItem(player, dsp.ki.LAPIS_MONOCLE)
        player:setVar("MissionStatus", 2)
    elseif csid == 169 then
        player:setVar("MissionStatus", 4)
        player:setVar("MissionStatus_randfoss", 0)
        player:delKeyItem(dsp.ki.LAPIS_MONOCLE)
        player:delKeyItem(dsp.ki.LAPIS_CORAL)
        npcUtil.giveKeyItem(player, dsp.ki.HIDEOUT_KEY)

    -- LURE OF THE WILDCAT (WINDURST)
    elseif csid == 732 then
        player:setMaskBit(player:getVar("WildcatWindurst"),"WildcatWindurst",4,true)

    -- THE TENSHODO SHOWDOWN
    elseif (csid == 496) then
        player:addQuest(WINDURST,dsp.quest.id.windurst.THE_TENSHODO_SHOWDOWN)
        player:setVar("theTenshodoShowdownCS",1)
        npcUtil.giveKeyItem(player, dsp.ki.LETTER_FROM_THE_TENSHODO)

    -- THICK AS THIEVES
    elseif (csid == 504 and option == 1) then  -- start quest "as thick as thieves"
        player:addQuest(WINDURST,dsp.quest.id.windurst.AS_THICK_AS_THIEVES)
        player:setVar("thickAsThievesCS",1)
        npcUtil.giveKeyItem(player, {dsp.ki.GANG_WHEREABOUTS_NOTE, dsp.ki.FIRST_FORGED_ENVELOPE, dsp.ki.SECOND_FORGED_ENVELOPE})
    elseif (csid == 508 and npcUtil.completeQuest(player, WINDURST, dsp.quest.id.windurst.AS_THICK_AS_THIEVES, {item=12514, var={"thickAsThievesCS", "thickAsThievesGrapplingCS", "thickAsThievesGamblingCS"}})) then
        player:delKeyItem(dsp.ki.GANG_WHEREABOUTS_NOTE)
        player:delKeyItem(dsp.ki.FIRST_SIGNED_FORGED_ENVELOPE)
        player:delKeyItem(dsp.ki.SECOND_SIGNED_FORGED_ENVELOPE)

    -- HITTING THE MARQUISATE
    elseif csid == 512 then
        player:addQuest(WINDURST, dsp.quest.id.windurst.HITTING_THE_MARQUISATE)
        player:setVar("hittingTheMarquisateYatnielCS", 1)
        player:setVar("hittingTheMarquisateHagainCS", 1)
        npcUtil.giveKeyItem(player, dsp.ki.CAT_BURGLARS_NOTE)
    elseif csid == 516 then
        player:setVar("hittingTheMarquisateNanaaCS", 1)
        player:setVar("hittingTheMarquisateYatnielCS", 0)
        player:setVar("hittingTheMarquisateHagainCS", 0)

    -- ROCK RACKETEER
    elseif csid == 93 then
        player:addQuest(WINDURST, dsp.quest.id.windurst.ROCK_RACKETEER)
        npcUtil.giveKeyItem(player, dsp.ki.SHARP_GRAY_STONE)
    elseif csid == 98 then
        player:delGil(10*GIL_RATE)
        player:setVar("rockracketeer_sold", 3)

    -- MIHGO'S AMIGO
    elseif csid == 80 or csid == 81 then
        player:addQuest(WINDURST, dsp.quest.id.windurst.MIHGO_S_AMIGO)
    elseif csid == 88 and npcUtil.completeQuest(player, WINDURST, dsp.quest.id.windurst.MIHGO_S_AMIGO, {gil=200, title=dsp.title.CAT_BURGLAR_GROUPIE, fameArea=NORG, fame=60}) then
        player:confirmTrade()
        player:needToZone(true)
    elseif csid == 494 then
        player:confirmTrade()
        player:addTitle(dsp.title.CAT_BURGLAR_GROUPIE)
        player:addGil(GIL_RATE*200)
        player:addFame(NORG, 30)
    end
end