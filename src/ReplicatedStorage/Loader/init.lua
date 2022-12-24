-- Loader
-- qweekertom
-- 4/20/22

--[[

	Attribute Tags:
		_group : Groups modules using the group system
		_loaderIgnore : ignored by the loader, when loading deep
		
		
	Updates:
		6/20 - Spring Module
			 - Spring.New() method
	
		Loader.ClearAllWhichIsA(instance : Instance, className : string)
		 -> ClearAllChildren() but with a class to whitelist. Useful for scrollingframes with UISort instances

		12/4
			 - Changed the start method to spawn __as it should be__
			 - tweaks to variable names
]]

local SETTINGS = {
	GroupAttributeName = "_group",
	ExecuteTests = false,
}

local loader = {
	log = {},
	test = {},
	Shared = nil,
}

loader.__index = loader

local backend = {
	modules = {},
	groups = {},
	tests = {},
}

---- Utils ----
local Utils = script.Utils
local Maid = require(Utils.Maid)
local Signal = require(Utils.Signal)

---- EVENTS ----
loader.OnComplete = Signal.new()

---- Backend Methods ----
function backend.Init(m)
	if m:GetAttribute("_loaderIgnore") then
		return
	end
	local existingModule = backend.modules[m.Name]

	if existingModule then
		loader.log.Warn(script, "Duplicate Module Name! : " .. m.Name)
		return
	end

	local success, err = pcall(function()
		backend.modules[m.Name] = require(m)
	end)

	if not success then
		warn(m.Name .. " errored while loading! " .. err)
	end

	local group = m:GetAttribute(SETTINGS.GroupAttributeName)
	if group then
		backend.CreateGroup(group)
		loader.GetGroup(group)[m.Name] = loader.Get(m.Name)
	end
end

function backend.CreateGroup(name)
	if loader.GetGroup(name) then
		return
	end
	backend.groups[name] = {}
end

---- Loader Methods ----
function loader.Get(name)
	local module = backend.modules[name]
	if not module then
		loader.log.Warn(script, "module: " .. tostring(name) .. " not found")
	end
	return module
end

function loader.GetAllModules()
	return backend.modules
end

function loader.WaitFor(name) -- YIELDS!
	local module = backend.modules[name]

	while module == nil do
		module = backend.modules[name]
		wait(0.01)
	end

	return module
end

function loader.GetGroup(name)
	local group = backend.groups[name]

	if not group then
		warn("[loader] group not found, maybe you want to create one?")
	end

	return group
end

function loader.InitModules(root)
	if type(root) ~= "table" then
		root = root:GetChildren()
	end

	for _, i in pairs(root) do
		if i:IsA("ModuleScript") == false then
			continue
		end
		if i:GetAttribute("_loaderIgnore") then
			continue
		end

		backend.Init(i)

		--loader.log.Print(script, "Loaded module for first time : " .. i.Name)
	end
end

function loader.Start()
	for _, module in pairs(backend.modules) do
		if module.Start and type(module.Start) == "function" then
			task.spawn(module.Start)
		end
	end
end

-- Credits: @foshes
function loader.GetUtil(name)
	local util = Utils:FindFirstChild(name)
	assert(util ~= nil, string.format("[loader] Util '%s' does not exist.", name))

	return require(util)
end

function loader.ClearAllWhichIsA(instance: Instance, className: string)
	for _, c in instance:GetChildren() do
		if c:IsA(className) then
			c:Destroy()
		end
	end
end

-- Credit: @Quenty
function loader.Maid()
	return Maid.new()
end

-- Credit: @Quenty
function loader.Signal()
	return Signal.new()
end

-- Credit: @loleris
function loader.NewInstance(class, properties)
	local instance = Instance.new(class)
	for k, v in pairs(properties) do
		if k ~= "Parent" then
			instance[k] = v
		end
	end
	instance.Parent = properties.Parent or workspace
	return instance
end

function loader.TraversePath(path, origin)
	local t = origin

	for _, child in ipairs(string.split(path, ".")) do
		t = t[child]
	end

	return t:Clone()
end

function loader.SafeTableRemove(tbl, element)
	local index = table.find(tbl, element)
	if index ~= nil then
		table.remove(tbl, index)
		return true
	end
	return false
end

function loader.DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = loader.DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

---- LOGGING ----
function loader.log.Warn(source: Instance, ...)
	warn("[" .. source.Name .. "] ", ...)
end

function loader.log.Todo(source: Instance, ...)
	warn("[" .. source.Name .. " - TODO] ", ...)
end

function loader.log.Print(source: Instance, ...)
	print("[" .. source.Name .. "] ", ...)
end

function loader.log.Error(source: Instance, ...)
	error("[" .. source.Name .. "] " .. tostring(...))
end

---- TESTS ----
function loader.test.AddTest(name, func)
	backend.tests[name] = func
end

function loader.test.RunTests()
	if SETTINGS.ExecuteTests == false then
		loader.log.Warn(script, "tests disabled")
		return
	end

	local pass = 0
	local fail = 0
	local invalid = 0
	local total = 0

	print("---- Test Begin ----")

	for name, test in pairs(backend.tests) do
		local test_result = test()
		if test_result == false then
			print("❌ Test Failed - " .. name)
			fail += 1
		elseif test_result == true then
			print("✔️ Test Passed - " .. name)
			pass += 1
		else
			print("⚠️ Non-Boolean Test Result - " .. name)
			invalid += 1
		end

		total += 1
	end

	print()
	print(total .. " total tests")
	print(pass .. " tests passed")
	print(fail .. " tests failed")
	print(invalid .. " invalid tests")

	print("--- Test End ----")
end

return loader
