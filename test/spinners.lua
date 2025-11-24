local spinners = require('utils.unicode.spinners')
local nt = require('notify')

local function update_icon(t)
    nt.notify(t)
end


local s = spinners:new(update_icon)
s:start()
