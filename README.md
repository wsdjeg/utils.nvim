# utils.nvim

A collection of useful Lua utilities for Neovim, extracted from [SpaceVim](https://spacevim.org).

## Features

- **Color manipulation** — Comprehensive color space conversions (RGB, HSL, HSV, CMYK, HWB, HEX, Linear, XYZ, Lab, LCH)
- **Data structures** — Dictionary, list, string, and TOML parsing utilities
- **File operations** — Filetype icons, path unification, file read/write, file/directory finding
- **Highlight** — Syntax group manipulation, separator highlighting, syntax inspection at cursor
- **Interactive UI** — Command-line prompt and menu system
- **Vim/Neovim compatibility** — Cross-platform API layer for Vim and Neovim
- **Regex** — Perl-style regex to Vim regex converter
- **System detection** — OS detection (Linux, Windows, macOS, Cygwin)
- **Unicode** — Spinner animations, messletters (circled letters/numbers, bubble numbers)
- **Misc** — Password generation, time formatting, language aliases, buffer/window management

## Installation

### Using [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
    { 'wsdjeg/utils.nvim' }
})
```

Then run `:PlugInstall utils.nvim`.

### Using [luarocks](https://luarocks.org)

```sh
luarocks install utils.nvim
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'wsdjeg/utils.nvim',
}
```

## Modules

### `utils.color`

Full color space conversion library. All values use the `[0, 1]` range (except HSL/HSV hue in degrees and CMYK in `[0, 1]`).

```lua
local color = require('utils.color')

-- RGB <-> HSL
local h, s, l = color.rgb2hsl(0.2, 0.4, 0.6)
local r, g, b = color.hsl2rgb(210, 0.5, 0.5)

-- RGB <-> HEX
local hex = color.rgb2hex(0.2, 0.4, 0.6)  -- "#336699"
local r, g, b = color.hex2rgb('#336699')

-- RGB <-> HSV
local h, s, v = color.rgb2hsv(0.2, 0.4, 0.6)

-- RGB <-> CMYK
local c, m, y, k = color.rgb2cmyk(0.2, 0.4, 0.6)

-- RGB <-> HWB
local h, w, b = color.rgb2hwb(0.2, 0.4, 0.6)

-- RGB <-> Lab
local L, a, b = color.rgb2lab(0.2, 0.4, 0.6)

-- Lab <-> LCH
local L, C, H = color.lab2lch(50, 20, -10)
```

Supported conversions: RGB, HSL, HSV, CMYK, HWB, HEX, Linear RGB, XYZ, Lab, LCH — all interchangeable.

### `utils.data.string`

String manipulation utilities.

```lua
local str = require('utils.data.string')

str.trim('  hello  ')        -- 'hello'
str.trim_start('  hello')    -- 'hello'
str.trim_end('hello  ')      -- 'hello'
str.fill('hi', 10)           -- 'hi        '
str.fill_left('hi', 10)      -- '        hi'
str.toggle_case('Hello')     -- 'hELLO'
str.string2chars('abc')      -- {'a', 'b', 'c'}
str.strcharpart('hello', 2, 4) -- 'll'
```

### `utils.data.toml`

TOML parser.

```lua
local toml = require('utils.data.toml')

local data = toml.parse([[
title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
]])

-- data.title == "TOML Example"
-- data.owner.name == "Tom Preston-Werner"

-- Or parse from file
local data = toml.parse_file('config.toml')
```

### `utils.data.dict`

Dictionary utilities.

```lua
local dict = require('utils.data.dict')

local d = dict.make({'a', 'b', 'c'}, {1, 2, 3})
-- { a = 1, b = 2, c = 3 }
```

### `utils.data.list`

List utilities.

```lua
local list = require('utils.data.list')

local v = list.pop({1, 2, 3})  -- 3 (removes and returns last element)
```

### `utils.file`

File and path utilities.

```lua
local file = require('utils.file')

-- Get filetype icon
local icon = file.fticon('main.lua')  -- ''

-- Path operations
local path = file.unify_path('./src/../lib')  -- normalized path
local fname = file.path_to_fname('/a/b/c.lua') -- '_a_b_c_lua'

-- File read/write
local lines = file.read('output.log')
file.write('new line', 'output.log')     -- append
file.override('content', 'output.log')   -- overwrite

-- Find files/directories
local f = file.findfile('Makefile', '.')
local d = file.finddir('src', '.')
```

### `utils.highlight`

Highlight group manipulation.

```lua
local hi = require('utils.highlight')

-- Get highlight group as dictionary
local group = hi.group2dict('Error')

-- Set highlight
hi.hi({
    name = 'MyHighlight',
    guifg = '#ff0000',
    guibg = '#000000',
    bold = 1,
})

-- Create separator highlights between two groups
hi.hi_separator('Normal', 'StatusLine')

-- Get syntax at cursor position (supports Treesitter & semantic tokens)
local name, hl = hi.syntax_at()
```

### `utils.prompt`

Interactive command-line prompt with cursor support.

```lua
local prompt = require('utils.prompt')

prompt._prompt.mpt = 'input ==> '
prompt._handle_fly = function(input)
    print('User typed: ' .. input)
end
prompt._onclose = function()
    print('Prompt closed')
end
prompt.open()
```

### `utils.cmdlinemenu`

Interactive command-line menu.

```lua
local menu = require('utils.cmdlinemenu')

menu.menu({
    {'Option 1', function() print('Selected 1') end},
    {'Option 2', 'echo "Selected 2"'},
    {'Option 3', function() print('Selected 3') end},
})
```

### `utils.vim.argv`

Command-line argument parser.

```lua
local argv = require('utils.vim.argv')

local args = argv.parser('git commit -m "hello world"')
-- {'git', 'commit', '-m', 'hello world'}
```

### `utils.vim.buffer`

Buffer operations.

```lua
local buf = require('utils.vim.buffer')

local bufnr = buf.create_buf(false, true)  -- create scratch buffer
buf.set_option(bufnr, 'buflisted', true)
local listed = buf.listed_buffers()
buf.open_pos('edit', 'file.lua', 10, 1)  -- open at line 10, col 1
```

### `utils.vim.keys`

Key code utilities.

```lua
local Key = require('utils.vim.keys')

local esc = Key.t('<Esc>')     -- terminal escape code for <Esc>
local name = Key.nr2name(32)   -- 'SPC'
local name = Key.char2name('<CR>') -- '<CR>'
```

### `utils.vim.regex`

Convert Perl-style regex to Vim regex.

```lua
local regex = require('utils.vim.regex')

local vim_pattern = regex.parser('\\bword\\b', true)
-- Result: '\v<word>'
```

### `utils.vim.compatible`

Compatibility layer between Vim and Neovim.

```lua
local cmp = require('utils.vim.compatible')

cmp.has('nvim-0.10.0')  -- 1 or 0
cmp.echo('Hello')
cmp.islist({1, 2, 3})   -- true
```

### `utils.vim.option`

Set local buffer/window options (requires Neovim 0.8.0+).

```lua
local opt = require('utils.vim.option')

opt.setlocalopt(bufnr, winid, {
    number = true,
    wrap = false,
})
```

### `utils.vim.statusline`

Statusline builder with floating window support.

```lua
local sl = require('utils.vim.statusline')

-- Build a statusline string
local line = sl.build(
    {'mode'}, {'file'}, '|', '|',
    'filename', 'tag',
    'StatusLine', 'StatusLineNC', 'StatusLineC',
    'StatusLineZ', 80
)

-- Or show in a floating window
sl.open_float({{'Mode: NORMAL', 'Normal'}})
```

### `utils.vim.window`

Window utilities.

```lua
local win = require('utils.vim.window')

win.is_float(winid)      -- check if window is floating
win.is_last_win()        -- check if last non-floating window
```

### `utils.system`

Operating system detection.

```lua
local sys = require('utils.system')

sys.isWindows  -- 1 or 0
sys.isLinux    -- 1 or 0
sys.isOSX      -- 1 or 0
sys.name()     -- 'linux', 'windows', 'mac', or 'cygwin'
sys.isDarwin() -- 1 or 0
sys.fileformat() -- OS icon
```

### `utils.password`

Password generator.

```lua
local pwd = require('utils.password')

pwd.generate_simple(16)  -- random 16-character alphanumeric string
```

### `utils.time`

Time utilities.

```lua
local time = require('utils.time')

time.current_time()  -- "02:30 PM"
time.current_date()  -- "Mon Jan 15"
```

### `utils.language`

Filetype name aliases.

```lua
local lang = require('utils.language')

lang.get_alias('typescript')       -- 'TypeScript'
lang.get_alias('python')           -- 'Python'
lang.get_alias('typescriptreact')  -- 'TypeScript React'
```

### `utils.messletters`

Unicode symbol utilities.

```lua
local ml = require('utils.messletters')

ml.circled_letter('A')    -- 'Ⓐ'
ml.circled_num(1, 0)      -- '①'
ml.bubble_num(1, 0)       -- '➊'
ml.index_num(2)           -- '²'
ml.parenthesized_num(1)   -- '⑴'
ml.num_period(1)          -- '⒈'
```

### `utils.unicode.spinners`

Terminal spinner animations.

```lua
local spinners = require('utils.unicode.spinners')

local s = spinners:new(function(icon)
    vim.api.nvim_echo({{icon, 'Normal'}}, false, {})
end)

s:start()  -- start animation
-- ...
s:stop()   -- stop animation
```

## License

[GPLv3](LICENSE)

