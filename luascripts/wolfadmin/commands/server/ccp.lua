
-- WolfAdmin module for Wolfenstein: Enemy Territory servers.
-- Copyright (C) 2015-2020 Timo 'Timothy' Smit

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

local commands = wolfa_requireModule("commands.commands")

local util = wolfa_requireModule("util.util")

function commandClientCenterPrint(command, clientId, text)
    local clientId = tonumber(clientId)

    if clientId and clientId ~= -1337 then -- -1337 because -1 is a magic number/broadcasted to all clients
        et.trap_SendServerCommand(clientId, "cp \""..text.."\";")
    elseif clientId then
        et.G_Print(util.removeColors(text).."\n")
    end

    return true
end
commands.addserver("ccp", commandClientCenterPrint)
