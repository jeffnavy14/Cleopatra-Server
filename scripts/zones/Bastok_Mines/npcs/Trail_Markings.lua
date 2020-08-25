-----------------------------------
-- Area: Bastok Mines
--  NPC: Trail Markings
-- Dynamis-Bastok Enter
-- !pos 99 1 -67 234
-----------------------------------
require("scripts/globals/settings");
require("scripts/globals/keyitems");
require("scripts/globals/dynamis");
local ID = require("scripts/zones/Bastok_Mines/IDs");
-----------------------------------

function onTrade(player,npc,trade)
end;

function onTrigger(player,npc)

    if bit.band(player:getVar("Dynamis_Status"),1) == 1 then
        player:startEvent(203); -- cs with Cornelia
    elseif (player:getVar("DynaBastok_Win") == 1) then
        player:startEvent(215,dsp.ki.HYDRA_CORPS_EYEGLASS); -- Win CS
    elseif (player:hasKeyItem(dsp.ki.VIAL_OF_SHROUDED_SAND)) then
        local firstDyna = 0;
        local realDay = os.time();
        local dynaWaitxDay = player:getVar("dynaWaitxDay");
        local dynaUniqueID = GetServerVariable("[DynaBastok]UniqueID");

        if (checkFirstDyna(player,2)) then  -- First Dyna-Bastok => CS
            firstDyna = 1;
        end

        if (player:getMainLvl() < DYNA_LEVEL_MIN) then
            player:messageSpecial(ID.text.PLAYERS_HAVE_NOT_REACHED_LEVEL,DYNA_LEVEL_MIN);
        elseif ((dynaWaitxDay + (BETWEEN_2DYNA_WAIT_TIME * 60 * 60)) < realDay or (player:getVar("DynamisID") == dynaUniqueID and dynaUniqueID > 0)) then
            player:startEvent(201,2,firstDyna,0,BETWEEN_2DYNA_WAIT_TIME,64,dsp.ki.VIAL_OF_SHROUDED_SAND,4236,4237);
        else
            dayRemaining = math.floor(((dynaWaitxDay + (BETWEEN_2DYNA_WAIT_TIME * 60 * 60)) - realDay)/3456);
            player:messageSpecial(ID.text.YOU_CANNOT_ENTER_DYNAMIS,dayRemaining,2);
        end
    else
        player:messageSpecial(ID.text.UNUSUAL_ARRANGEMENT_PEBBLES);
    end

end;

function onEventUpdate(player,csid,option)
    -- printf("updateRESULT: %u",option);
end;

function onEventFinish(player,csid,option)
    -- printf("finishRESULT: %u",option);

    if (csid == 203) then
        player:addKeyItem(dsp.ki.VIAL_OF_SHROUDED_SAND);
        player:messageSpecial(ID.text.KEYITEM_OBTAINED,dsp.ki.VIAL_OF_SHROUDED_SAND);
        player:setVar("Dynamis_Status",bit.band(player:getVar("Dynamis_Status"),bit.bnot(1)));
    elseif (csid == 215) then
        player:setVar("DynaBastok_Win",0);
    elseif (csid == 201 and option == 0) then
        if (checkFirstDyna(player,2)) then
            player:setVar("Dynamis_Status",bit.bor(player:getVar("Dynamis_Status"),4));
        end

		-- Store information about Key Items Gained and relay re-enter time to variable


		local d1 = 0;
		local d2 = 0;
		local d3 = 0;
		local d4 = 0;
		local d5 = 0;
		local d6 = 0;
		local reduction = 0;
		local reentertime = 43200;


		if (player:hasKeyItem(dsp.ki.HYDRA_CORPS_COMMAND_SCEPTER)) then
		d1 = 1;
		end
		if (player:hasKeyItem(dsp.ki.HYDRA_CORPS_EYEGLASS)) then
		d2 = 1;
		end
		if (player:hasKeyItem(dsp.ki.HYDRA_CORPS_LANTERN)) then
		d3 = 1;
		end
		if (player:hasKeyItem(dsp.ki.HYDRA_CORPS_TACTICAL_MAP)) then
		d4 = 1;
		end
		if (player:hasKeyItem(dsp.ki.HYDRA_CORPS_INSIGNIA)) then
		d5 = 1;
		end
		if (player:hasKeyItem(dsp.ki.HYDRA_CORPS_BATTLE_STANDARD)) then
		d6 = 1;
		end

		reduction = d1 + d2 + d3 + d4 + d5 + d6;

		if (reduction == 1) then
		reentertime = 28800;
		player:setVar("Dyna_KI_Counter",1);
		elseif (reduction == 2) then
		reentertime = 21600;
		player:setVar("Dyna_KI_Counter",2);
		elseif (reduction == 3) then
		reentertime = 14400;
		player:setVar("Dyna_KI_Counter",3);
		elseif (reduction == 4) then
		reentertime = 10800;
		player:setVar("Dyna_KI_Counter",4);
		elseif (reduction == 5) then
		reentertime = 7200;
		player:setVar("Dyna_KI_Counter",5);
		elseif (reduction == 6) then
		reentertime = 0;
		player:setVar("Dyna_KI_Counter",6);
		else
		reentertime = 43200;
		player:setVar("Dyna_KI_Counter",0);
		end

		player:setVar("Dyna_Reduction", reentertime);


		player:setVar("Dynamis_Bastok_Enter",1);
        player:setVar("[DYNAMIS]PRISM_ALIGN",0)
        player:setVar("Dynamis_Entry",os.time());
        player:setVar("enteringDynamis",1);
        player:setPos(116.482,0.994,-72.121,128,186);
    end
end;