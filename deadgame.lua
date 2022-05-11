repeat wait() until game:IsLoaded()
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local rpls = game:GetService("ReplicatedStorage")
local https = game:GetService("HttpService")
local tps = game:GetService("TeleportService")
local toTp = game:GetService("Workspace").ClassStands["Class - Knight"].MainSkin

local cclosure = syn_newcclosure or newcclosure
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", cclosure(function(Self,...)
    local NamecallMethod = getnamecallmethod()
    
    if NamecallMethod:lower() == "kick" and not checkcaller() then
        return wait(9e9)
    end
    
    return oldNamecall(Self,...)
end))
repeat wait(1) until plr.PlayerGui.Intro.MainFrame.Menu.Visible or not plr.PlayerGui.Intro.Enabled
wait(6)
for i,v in pairs(getconnections(plr.PlayerGui.Intro.MainFrame.Menu.PLAY.MouseButton1Click)) do
    v:Fire()
end

repeat wait() until plr.Character:WaitForChild("Humanoid")

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

while wait(1) do
    if #plrs:GetChildren() < 4 then
        local sInfo = https.JSONDecode(https, game.HttpGetAsync(game, "https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?sortOrder=Asc&limit=100"))
        local servers = sInfo.data
        
        if #servers ~= 0 and #servers ~= 1 then
            servers = filter(servers,function(i,v)
                return v.playing ~= v.maxPlayers and v.id ~= game.JobId
            end)
            server = servers[1]
            local qot = syn.queue_on_teleport or queue_on_teleport
            qot('loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaiddd/cs5farm/main/deadgame.lua", false))()')
            tps.TeleportToPlaceInstance(tps,game.PlaceId,server.id)
        end
    end
    if plr.Character.CurrentClass.Value ~= "none" then
        repeat wait() until plr.Character:WaitForChild("Humanoid")
        plr.Character.Humanoid.RootPart.Anchored = false
        wait()
        plr.Character.Humanoid.RootPart.CFrame = CFrame.new(9e2,9e2,9e2)
        wait()
        plr.Character.Humanoid.RootPart.Anchored = true
        for i,v in pairs(plrs:GetChildren()) do
            if v ~= plr then
                pcall(function()
                    if v.Character:FindFirstChild("Head") then
                        rpls.Remotes.EffectApply:InvokeServer(rKey(),plr.Character,rpls.Classes.PHANTOM.Effects.Blind.Effect,v.Character.Head)
                        wait(.1)
                    end
                end)
            end
        end
    else
        repeat wait() until plr.Character:WaitForChild("Humanoid")
        plr.Character.Humanoid.RootPart.Anchored = false
        plr.Character.Humanoid.RootPart.CFrame = toTp.CFrame
    end
end
