# VS Code Snippets
To add the new snippets for the module and components for the loader, open the ```./snippet.json``` file
Then:
 - Ctrl + Shift + P
 - Enter "snippets"
 - Select "Snippets: Configure User Snippets"
 - Enter and open "lua.json"
 - Copy paste from snippet.json to lua.json

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
