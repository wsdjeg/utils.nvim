--=============================================================================
-- spinners.lua --- spinners api
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}
-- https://raw.githubusercontent.com/sindresorhus/cli-spinners/master/spinners.json
local icons = {
    default = {
        frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
        strwidth = 1,
        timeout = 80,
    },
}

function M:new(func)
    local spinners = {}
    spinners.func = func

    function spinners:start()
        if self.id then
            return
        end
        local index = 1
        self.func(icons.default.frames[index])
        self.id = vim.fn.timer_start(icons.default.timeout, function(...)
            if index < #icons.default.frames then
                index = index + 1
            else
                index = 1
            end

            self.func(icons.default.frames[index])
        end, { ['repeat'] = -1 })
    end

    function spinners:stop()
        pcall(vim.fn.timer_stop(self.id))
    end

    return spinners
end

return M
