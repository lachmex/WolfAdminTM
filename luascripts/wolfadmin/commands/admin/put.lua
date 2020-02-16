
-- WolfAdmin module for Wolfenstein: Enemy Territory servers.
-- Copyright (C) 2015-2019 Timo 'Timothy' Smit

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

local admin = wolfa_requireModule("admin.admin")

local auth = wolfa_requireModule("auth.auth")

local commands = wolfa_requireModule("commands.commands")

local util = wolfa_requireModule("util.util")
local constants = wolfa_requireModule("util.constants")
local settings = wolfa_requireModule("util.settings")

function commandPlayerPut(clientId, command, victim, team)
    local cmdClient

    if victim == nil or team == nil or (team ~= constants.TEAM_AXIS_SC and team ~= constants.TEAM_ALLIES_SC and team ~= constants.TEAM_SPECTATORS_SC) then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dput usage: "..commands.getadmin("put")["syntax"].."\";")
        
        return true
    elseif tonumber(victim) == nil or tonumber(victim) < 0 or tonumber(victim) > tonumber(et.trap_Cvar_Get("sv_maxclients")) then
        cmdClient = et.ClientNumberFromString(victim)
    else
        cmdClient = tonumber(victim)
    end

    if cmdClient == -1 or cmdClient == nil then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dput: ^9no or multiple matches for '^7"..victim.."^9'.\";")
        
        return true
    elseif not et.gentity_get(cmdClient, "pers.netname") then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dput: ^9no connected player by that name or slot #\";")
        
        return true
    end

    if auth.isPlayerAllowed(cmdClient, "!") then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dput: ^7"..et.gentity_get(cmdClient, "pers.netname").." ^9is immune to this command.\";")
        
        return true
    elseif auth.getPlayerLevel(cmdClient) > auth.getPlayerLevel(cmdClient) then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^dput: ^9sorry, but your intended victim has a higher admin level than you do.\";")
        
        return true
    end
    
    local team = util.getTeamFromCode(team)

    -- cannot unbalance teams in certain mods (see g_svcmds.c:SetTeam)
    -- fixed in legacymod
    et.trap_SendConsoleCommand(et.EXEC_APPEND, "cchat -1 \"^dput: ^7"..et.gentity_get(cmdClient, "pers.netname").." ^9has been put to "..util.getTeamColor(team)..util.getTeamName(team).."\";")

    admin.putPlayer(cmdClient, team)

    return true
end
commands.addadmin("put", commandPlayerPut, auth.PERM_PUT, "move a player to a specified team", "^9[^3name|slot#^9] [^3r|b|s^9]", nil, (settings.get("g_standalone") == 0))
