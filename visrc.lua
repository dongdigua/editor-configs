-- load standard vis module, providing parts of the Lua API
require('vis')
require('plugins/filetype')

local filetypes = vis.ftdetect.filetypes
filetypes.rust.cmd = { 'set et', 'set tw 4' }
filetypes.python.cmd = { 'set et', 'set tw 4' }
filetypes.elixir.cmd = { 'set et', 'set tw 2' }
filetypes.lua.cmd = { 'set tw 4' }

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
	-- vis:command('set theme minimal-dark-clear')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
	-- Your per window configuration options e.g.
	-- vis:command('set number')
end)
