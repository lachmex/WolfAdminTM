
-- WolfAdmin module for Wolfenstein: Enemy Territory servers.
-- Copyright (C) 2015-2020 Timo 'Timothy' Smit
-- extended by EAGLE_CZ, www.teammuppet.com

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
local rules = wolfa_requireModule("admin.rules")

function commandRules(clientId, command, rule)
    if not rule then
        local amountOfRules = 0
        
        local list = rules.get()
        
        for shortcut, rule in pairs(list) do
            et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^f"..string.format("%12s", shortcut).." ^9- "..rule.."\";")
            
            amountOfRules = amountOfRules + 1
        end
        
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "cchat "..clientId.." \"^drules: ^9"..amountOfRules.." rules (open console for the full list)\";")
        et.trap_SendConsoleCommand(et.EXEC_APPEND, "csay "..clientId.." \"^9Type ^2!rules ^d[rule] ^9to announce a specific rule.\";")
    else
        local ruleText = rules.get(string.lower(rule))
        
        if ruleText then
            et.trap_SendConsoleCommand(et.EXEC_APPEND, "cchat -1 \"^drules: "..ruleText.."\";")
        end
    end
    
    return true
end
commands.addclient("rules", commandRules, auth.PERM_LISTRULES, "display the rules on the server", "^9(^hrule^9)")
