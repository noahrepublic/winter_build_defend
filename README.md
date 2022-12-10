# VS Code Snippets
Then:
 - Ctrl + Shift + P
 - Enter "snippets"
 - Select "Snippets: Configure User Snippets"
 - Enter and open "lua.json"
 - Copy paste the code below to lua.json

```
{
	// Place your snippets for lua here. Each snippet is defined under a snippet name and has a prefix, body and 
	// description. The prefix is what is used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. Placeholders with the 
	// same ids are connected.
	// Example:
	// "Print to console": {
	// 	"prefix": "log",
	// 	"body": [
	// 		"console.log('$1');",
	// 		"$2"
	// 	],
	// 	"description": "Log output to console"
	// }

	"Loader Module": {
		"prefix": "loader-module",
		"body": [
			"",
			"-- @title: $TM_FILENAME",
			"-- @author: $2",
			"-- @date: $CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE",
			"",
			"--> Services",
			"local ReplicatedStorage = game:GetService(\"ReplicatedStorage\")",
			"",
			"--> Loader, Modules, and Util",
			"local loader = require(ReplicatedStorage.Loader)",
			"",
			"--> Module Definition",
			"local module = {}",
			"local SETTINGS = {",
			"",
			"}",
			"",
			"--> Variables",
			"",
			"--> Private Functions",
			"",
			"--> Module Functions",
			"",
			"--> Loader Methods",
			"function module.Start()",
			"",
			"end",
			"",
			"return module",
		],
		"description": "Boilerplate Module Code for Loader"
	},

	"Loader Component": {
		"prefix": "loader-component",
		"body": [
			"",
			"-- @title: $TM_FILENAME",
			"-- @author: $2",
			"-- @date: $CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE",
			"",
			"--> Services",
			"local ReplicatedStorage = game:GetService(\"ReplicatedStorage\")",
			"",
			"--> Settings",
			"local SETTINGS = {",
			"	Tag = \"$TM_FILENAME_BASE\";	",
			"}",
			"",
			"--> Define Component",
			"local Component = {Tag = SETTINGS.Tag}",
			"Component.__index = Component",
			"",
			"--> Private Variables",
			"",
			"--> Constructor",
			"function Component.new(instance : Instance)",
			"	local self = setmetatable({",
			"		[\"_initialized\"] 	= false;",
			"		[\"Instance\"] 		= instance;",
			"",
			"	}, Component)",
			"",
			"	self:_init()",
			"	return self",
			"end",
			"",
			"function Component:_init()",
			"	if self._initialized == true then return end",
			"	self._initialized = true",
			"",
			"end",
			"",
			"return Component"
		],
		"description": "Boilerplate Component Code for Loader"
	}

}

```

# Publishing With Rojo

After pulling new version rebuild the file to update it with the following:

```bash
rojo build -o "game.rbxl"
```

Open game file, start Rojo server and work as usual

```bash
rojo serve
```

Check out [the Rojo documentation](https://rojo.space/docs).

# Did I publish?

Check if the workflows ran, and you can see the games here:

Staging: https://www.roblox.com/games/11780832227/Garden-gg-Staging

Production: https://www.roblox.com/games/11780824592/Garden-gg
