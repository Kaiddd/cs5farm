local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local rpls = game:GetService("ReplicatedStorage")
local https = game:GetService("HttpService")
local tps = game:GetService("TeleportService")
local toTp = game:GetService("Workspace").ClassStands["Class - Knight"].MainSkin

--AntiAfk not made by me
local vu = game:GetService("VirtualUser")
plr.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local function filter(tbl, ret)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            if (ret(i, v)) then
                new[#new + 1] = v
            end
        end
        return new
    end
end

local function rKey()
    return getsenv(plr.PlayerGui:WaitForChild("LocalProjectile")).pass()
end

while wait(4) do
    if #plrs:GetChildren() < 2 then
        local sInfo = JSONDecode(https, game.HttpGetAsync(game, format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)))
        local servers = sInfo.data
        
        if #servers ~= 0 and #servers ~= 1 then
            servers = filter(servers,function(i,v)
                return v.playing ~= v.maxPlayers and v.id ~= game.JobId
            end)
            local qot = syn.queue_on_teleport or queue_on_teleport
            qot('loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaiddd/cs5farm/main/deadgame.lua", false))()')
            tps.TeleportToPlaceInstance(tps,game.PlaceId,server.id)
        end
    end
    if plr.Character.CurrentClass.Value ~= "none" then
        plr.Character.Humanoid.RootPart.CFrame = CFrame.new(9e2,9e4,9e2)
        for i,v in pairs(plrs:GetChildren()) do
            if v ~= plr then
                pcall(function()
                    rpls.Remotes.EffectApply:InvokeServer(rKey(),plr.Character,rpls.Classes.PHANTOM.Effects.Blind.Effect,v.Character.Head)
                    wait(.5)
                end)
            end
        end
    else
        plr.Character.Humanoid.RootPart.CFrame = toTp.CFrame
    end
end
