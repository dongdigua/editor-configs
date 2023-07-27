#! /usr/bin/lua

local state = {}
local mode = arg[1]
local START_PATTERN = "^;;;ifdef (%w+)$"
local END_PATTERN   = "^;;;endif (%w+)$"

function update_state(l)
	local start_chunk = string.match(l, START_PATTERN)
	local end_chunk   = string.match(l, END_PATTERN)

	if start_chunk then state[start_chunk] = true
	elseif end_chunk then state[end_chunk] = false
	end
end

function cleanup(l)
	if not (string.match(l, START_PATTERN) or string.match(l, END_PATTERN)) then return l end
end

function process_dump()
	for l in io.lines() do
		update_state(l)
		if state["dump"] then print(cleanup(l)) end
	end
end

function process_excl()
	for l in io.lines() do
		update_state(l)
		if not state["excl"] then print(cleanup(l)) end
	end
end

if mode == "dump" then
	process_dump()
elseif mode == "excl" then
	process_excl()
else
	io.stderr:write("what?\n")
end
