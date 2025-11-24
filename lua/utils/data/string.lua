--=============================================================================
-- string.lua --- spacevim data#string api
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.trim(str)
    return str:match('^%s*(.-)%s*$')
end

function M.fill(str, length, char)
    local l = vim.fn.strdisplaywidth(str)
    if l <= length then
        return str .. string.rep(char or ' ', length - l)
    end

    return str
end

function M.strcharpart(str, start, _end)
    local chars = M.string2chars(str)
    local new_chars = {}
    for i = start, math.min(_end, #chars) do
        table.insert(new_chars, chars[i])
    end
    return table.concat(new_chars, '')
end

function M.toggle_case(str)
    local chars = {}
    for _, char in pairs(M.string2chars(str)) do
        local cn = string.byte(char)
        if cn >= 97 and cn <= 122 then
            table.insert(chars, string.char(cn - 32))
        elseif cn >= 65 and cn <= 90 then
            table.insert(chars, string.char(cn + 32))
        else
            table.insert(chars, char)
        end
    end
    return table.concat(chars, '')
end

function M.fill_left(str, length, char)
    local l = vim.fn.strdisplaywidth(str)
    if l <= length then
        return string.rep(char or ' ', length - l) .. str
    end

    return str
end

function M.fill_middle(str, length, ...) end

function M.trim_start(str)
    return str:gsub('^%s+', '')
end

function M.trim_end(str)
    return str:gsub('%s+$', '')
end

function M.string2chars(str)
    local list = {}
    for uchar in string.gmatch(str, '[^\128-\191][\128-\191]*') do
        table.insert(list, uchar)
    end
    return list
end

function M.matchstrpos(str, need, ...)
    local matchedstr = vim.fn.matchstr(str, need, ...)
    local matchbegin = vim.fn.match(str, need, ...)
    local matchend = vim.fn.matchend(str, need, ...)
    return { matchedstr, matchbegin, matchend }
    -- return vim.fn.matchstrpos(str, need, ...)
end

function M.strAllIndex(str, need, use_expr)
    local rst = {}
    if use_expr then
        local idx = M.matchstrpos(str, need)
        while idx[2] ~= -1 do
            table.insert(rst, { idx[2], idx[3] })
            idx = M.matchstrpos(str, need, idx[3])
        end
    else
        local pattern = [[\<\V]] .. need .. [[\ze\W\|\<\V]] .. need .. [[\ze\$]]
        local idx = vim.fn.match(str, pattern)
        while idx ~= -1 do
            table.insert(rst, { idx, idx + vim.fn.len(need) })
            idx = vim.fn.match(str, pattern, idx + 1 + vim.fn.len(need))
        end
    end
    return rst
end

function M.strQ2B(str) end

function M.strB2Q(str) end

function M.split(str, ...) end

return M

-- @todo add lua string api
