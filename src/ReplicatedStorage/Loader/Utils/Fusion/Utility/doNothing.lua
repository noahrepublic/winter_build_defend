--!strict
--# selene: allow(unused_variable)
--[[
	An empty function. Often used as a destructor to indicate no destruction.
]]

local function doNothing(...: any) end

return doNothing
