RAID_CLASS_COLORS["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87 }; -- ** cough cough, if any addons still relay on this **

BSF = {
	orig = {},
	class = {
		["Druid"] = "FF7D0A",
		["Hunter"] = "ABD473",
		["Mage"] = "69CCF0",
		["Paladin"] = "F58CBA",
		["Priest"] = "FFFFFF",
		["Rogue"] = "FFF569",
		["Shaman"] = "0070DE",
		["Warlock"] = "9482C9",
		["Warrior"] = "C79C6E"
	}
}

-- copied from aux because i am lazy
function BSF.Hook(name, handler, object)
    local orig
    if object then
        BSF.orig[object] = BSF.orig[object] or {}
        orig = BSF.orig[object]
    else
        object = object or getfenv(0)
        orig = BSF.orig
    end

    if orig[name] then
        error('Already got a hook for '..name)
    end

    orig[name] = object[name]
    object[name] = handler
end

function BSF.Log(message)
	DEFAULT_CHAT_FRAME:AddMessage("[BSF] " .. message or "", 1, 1, 0)
end

function BSF.SetHooks()
	BSF.Hook("WorldStateScoreFrame_Update", BSF.WorldStateScoreFrame_Update)
end

function BSF.On_Load()
	BSF.SetHooks()
end

function BSF.WorldStateScoreFrame_Update()
	BSF.orig.WorldStateScoreFrame_Update()

	local numScores = GetNumBattlefieldScores();
	local buttonName;
	local name, honorableKills, killingBlows, deaths, honorGained, faction, rank, race, class;
	local index;

	for i=1, MAX_WORLDSTATE_SCORE_BUTTONS do
		index = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame) + i;
		if ( index <= numScores ) then
			buttonName = getglobal("WorldStateScoreButton"..i.."NameButtonName");
			name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class = GetBattlefieldScore(index);
			if name and class then
				buttonName:SetText(format("|cff%s%s|r", BSF.class[class], name));
			end
		end
	end
end