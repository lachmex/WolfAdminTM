
-- WolfAdmin module for Wolfenstein: Enemy Territory servers.
-- Copyright (C) 2015-2020 Timo 'Timothy' Smit
-- and extended by EAGLE_CZ, www.teammuppet.com

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- at your option any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local auth = wolfa_requireModule("auth.auth")
local commands = wolfa_requireModule("commands.commands")
local players = wolfa_requireModule("players.players")
local constants = wolfa_requireModule("util.constants")
local settings = wolfa_requireModule("util.settings")

function commandFreeze(clientId, command, victim)
    local cmdClient

    if victim == nil then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dfreeze usage: "..commands.getadmin("freeze")["syntax"].."\";")

        return true
    elseif tonumber(victim) == nil or tonumber(victim) < 0 or tonumber(victim) > tonumber(et.trap_Cvar_Get("sv_maxclients")) then
        cmdClient = et.ClientNumberFromString(victim)
    else
        cmdClient = tonumber(victim)
    end

    if cmdClient == -1 or cmdClient == nil then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dfreeze: ^9no or multiple matches for '^7"..victim.."^9'.\";")

        return true
    elseif not et.gentity_get(cmdClient, "pers.netname") then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dfreeze: ^9no connected player by that name or slot #\";")

        return true
    end

    if auth.isPlayerAllowed(cmdClient, "!") then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dfreeze: ^7"..et.gentity_get(cmdClient, "pers.netname").." ^9is immune to this command.\";")

        return true
    elseif auth.getPlayerLevel(cmdClient) > auth.getPlayerLevel(clientId) then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dfreeze: ^9sorry, but your intended victim has a higher admin level than you do.\";")

        return true
    elseif et.gentity_get(cmdClient, "sess.sessionTeam") ~= constants.TEAM_AXIS and et.gentity_get(cmdClient, "sess.sessionTeam") ~= constants.TEAM_ALLIES then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dfreeze: ^7"..et.gentity_get(cmdClient, "pers.netname").." ^9is not playing.\";")

        return true
    elseif et.gentity_get(cmdClient, "health") <= 0 then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dfreeze: ^7"..et.gentity_get(cmdClient, "pers.netname").." ^9is not alive.\";")

        return true
    end
	
	if tonumber(et.gentity_get(cmdClient,"freezed")) == 0 then
	
		et.gentity_set(cmdClient,"freezed", 1)
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "cchat -1 \"^dfreeze: ^7"..players.getName(cmdClient).." ^9was frozen.\";")
		
		if settings.get("g_playerHistory") ~= 0 then
			history.add(cmdClient, clientId, "freeze", reason)
		end
	else
		
		et.gentity_set(cmdClient,"freezed", 0)
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "cchat -1 \"^dfreeze: ^7"..players.getName(cmdClient).." ^9is no longer frozen.\";")
		
		if settings.get("g_playerHistory") ~= 0 then
			history.add(cmdClient, clientId, "unfreeze", reason)
		end
	end

    return true
end
commands.addadmin("freeze", commandFreeze, auth.PERM_FREEZE, "freeze a player", "^9(^3name|slot#^9)", nil, (settings.get("g_standalone") == 0))
