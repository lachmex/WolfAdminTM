
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

local util = wolfa_requireModule("util.util")

local tables = {}

function tables.merge(tbl1, tbl2)
    util.typecheck("tables.merge", {tbl1}, {"table"})
    util.typecheck("tables.merge", {tbl2}, {"table"})

    local exists = {}

    for _, value in ipairs(tbl1) do
        exists[value] = true
    end

    for _, value in ipairs(tbl2) do
        if not exists[value] then
            table.insert(tbl1, value)
        end
    end

    return tbl1
end

function tables.mergeKeys(tbl1, tbl2)
    util.typecheck("tables.mergeKeys", {tbl1}, {"table"})
    util.typecheck("tables.mergeKeys", {tbl2}, {"table"})

    for key, value in pairs(tbl2) do
        tbl1[key] = value
    end

    return tbl1
end

function tables.copy(tbl)
    util.typecheck("tables.copy", {tbl}, {"table"})

    local copy = {}

    for key, value in pairs(tbl) do
        copy[key] = value
    end

    return copy
end

function tables.unpack(tbl)
    util.typecheck("tables.contains", {tbl}, {"table"})

    if table.unpack ~= nil then
        return table.unpack(tbl)
    elseif unpack ~= nil then
        return unpack(tbl)
    end
end

function tables.contains(tbl, needle)
    util.typecheck("tables.contains", {tbl}, {"table"})

    for _, value in pairs(tbl) do
        if value == needle then
            return true
        end
    end

    return false
end

function tables.find(tbl, needle)
    util.typecheck("tables.contains", {tbl}, {"table"})

    for key, value in pairs(tbl) do
        if value == needle then
            return key
        end
    end

    return nil
end

return tables
