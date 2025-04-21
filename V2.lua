local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local walkSpeedValue = 16
local jumpPowerValue = 50


local Window = Rayfield:CreateWindow({
    Name = "Stronger Hub V2",
    Icon = "shield-half",
    LoadingTitle = "Stronger Hub V2",
    LoadingSubtitle = "By @j4y11",
    Theme = "Default",

    DisableRayfieldPrompts = true,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "StrongerHubV2",
        FileName = "StrongerConfig",
    },
    Discord = {
        Enabled = true,
        Invite = "CuFc6cMqQ",
        RememberJoins = false
    },

    KeySystem = true,
    KeySettings = {
        Title = "StrongerHub V2",
        Subtitle = "Key System",
        Note = "Join discord for key .gg/CuFc6cMqQ",
        FileName = "StrongerHubV2Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"key3008"}
    }
})

local MainTab = Window:CreateTab("Main", "book-marked")
local ScriptsTab = Window:CreateTab("Scripts", "scroll-text")
local SettingsTab = Window:CreateTab("Settings", "cog")

local MainSection = MainTab:CreateSection("Info")
MainSection:Set("Info")

Rayfield:Notify({
    Title = "Welcome",
    Content = "To StrongerHub V2",
    Duration = 5,
    Image = "mail-warning",
})

-- 👤 User Info Section
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 🧾 Add User Labels directly to the MainTab
MainTab:CreateLabel("Username: " .. LocalPlayer.Name, "user")
MainTab:CreateLabel("Account Age: " .. tostring(LocalPlayer.AccountAge) .. " days", "calendar")

-- 🕹️ Server Info Section
local ServerInfoSection = MainTab:CreateSection("Server Info")

ServerInfoSection:Set("Server Info For: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

local pingLabel = MainTab:CreateLabel("Ping: ~0 ms","wifi")

-- Continuously update the Ping label
task.spawn(function()
    while true do
        local pingMs = math.floor((RunService.Heartbeat:Wait()) * 1000)
        pingLabel:Set("Ping: ~" .. tostring(pingMs) .. " ms","wifi")
        task.wait(5) -- Update every 5 seconds
    end
end)

-- Display current number of players in the server
MainTab:CreateLabel("Players in Server: " .. tostring(#Players:GetPlayers()), "users")

local ScriptsSection = ScriptsTab:CreateSection("Scripts")

ScriptsTab:CreateButton({
    Name = "Enable Camera Lock",
    Callback = function()
        -- Load and execute the Camera Lock script
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Jayver-Dev/camlock/refs/heads/main/lock.lua", true))()
        Rayfield:Notify({
            Title = "Camera Lock Enabled",
            Content = "The camera lock script has been executed.",
            Duration = 3,
            Image = "aperture",
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Fling Player GUI",
    Callback = function()
        -- Load and execute the Fling Player GUI script
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Jayver-Dev/kill-all/refs/heads/main/fling.lua", true))()
        Rayfield:Notify({
            Title = "Fling Player GUI Enabled",
            Content = "The fling player GUI script has been executed.",
            Duration = 3,
            Image = "biohazard",
        })
    end
})

-- Teleport to Player Section
ScriptsTab:CreateLabel("Enter username to teleport to player:")

local enteredUsername = "" -- keep this up top or near your Input block

ScriptsTab:CreateInput({
    Name = "Username",
    CurrentValue = "",
    PlaceholderText = "Enter player's username",
    Flag = "UsernameTP",
    RemoveTextAfterFocusLost = false,
    Callback = function(newText)
        enteredUsername = newText
    end
})

ScriptsTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        local targetPlayer = Players:FindFirstChild(enteredUsername)

        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame

            -- Ensure your own character is loaded
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "You have been teleported to " .. enteredUsername,
                    Duration = 3,
                    Image = "map",
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Your character isn't fully loaded yet.",
                    Duration = 3,
                    Image = "triangle-alert",
                })
            end
        else
            Rayfield:Notify({
                Title = "Player Not Found",
                Content = "The player " .. enteredUsername .. " could not be found or doesn't have a loaded character.",
                Duration = 3,
                Image = "ban",
            })
        end
    end
})



SettingsTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

SettingsTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")

        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)

        if success and response and response.data then
            local currentJobId = game.JobId
            local joined = false

            for _, server in pairs(response.data) do
                if server.playing < server.maxPlayers and server.id ~= currentJobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Players.LocalPlayer)
                    joined = true
                    break
                end
            end

            if not joined then
                Rayfield:Notify({
                    Title = "No Servers Found",
                    Content = "No suitable server to hop into was found.",
                    Duration = 4,
                    Image = "alert-octagon"
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to retrieve servers.",
                Duration = 4,
                Image = "bug"
            })
        end
    end
})

SettingsTab:CreateButton({
    Name = "Server Hop (Least Players)",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")

        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)

        if success and response and response.data then
            local currentJobId = game.JobId
            local lowestServer = nil
            local lowestCount = math.huge

            for _, server in pairs(response.data) do
                if server.playing < server.maxPlayers and server.id ~= currentJobId then
                    if server.playing < lowestCount then
                        lowestServer = server
                        lowestCount = server.playing
                    end
                end
            end

            if lowestServer then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, lowestServer.id, Players.LocalPlayer)
            else
                Rayfield:Notify({
                    Title = "No Servers Found",
                    Content = "Couldn't find a less populated server.",
                    Duration = 4,
                    Image = "alert-octagon"
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to fetch servers.",
                Duration = 4,
                Image = "bug"
            })
        end
    end
})

ScriptsTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        walkSpeedValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end,
})

ScriptsTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 5,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        jumpPowerValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end,
})

ScriptsTab:CreateButton({
    Name = "Reset Movement to Default",
    Callback = function()
        walkSpeedValue = 16
        jumpPowerValue = 50

        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeedValue
            LocalPlayer.Character.Humanoid.JumpPower = jumpPowerValue
        end

        -- Update sliders visually (Rayfield auto-updates values this way)
        Rayfield.Flags["WalkSpeed"].CurrentValue = 16
        Rayfield.Flags["JumpPower"].CurrentValue = 50

        Rayfield:Notify({
            Title = "Movement Reset",
            Content = "WalkSpeed and JumpPower reset to defaults.",
            Duration = 3,
            Image = "rotate-ccw",
        })
    end
})

local noclipEnabled = false

ScriptsTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(state)
        noclipEnabled = state

        Rayfield:Notify({
            Title = "Noclip",
            Content = state and "Noclip enabled." or "Noclip disabled.",
            Duration = 3,
            Image = "wand",
        })
    end,
})

-- RunService loop for noclip behavior
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

local espEnabled = false
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "StrongerHubESP"

ScriptsTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(state)
        espEnabled = state

        -- Clear ESP if disabling
        if not state then
            espFolder:ClearAllChildren()
            return
        end

        -- Generate ESP tags
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local tag = Instance.new("BillboardGui")
                tag.Name = player.Name .. "_ESP"
                tag.Adornee = player.Character.Head
                tag.Size = UDim2.new(0, 100, 0, 40)
                tag.StudsOffset = Vector3.new(0, 2, 0)
                tag.AlwaysOnTop = true
                tag.Parent = espFolder

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Color3.new(1, 1, 1)
                nameLabel.TextStrokeTransparency = 0
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.TextScaled = true
                nameLabel.Parent = tag
            end
        end

        Rayfield:Notify({
            Title = "ESP",
            Content = "ESP is now " .. (state and "enabled" or "disabled"),
            Duration = 3,
            Image = "eye",
        })
    end
})

-- Optional: Clean up ESP when a player leaves
Players.PlayerRemoving:Connect(function(plr)
    local tag = espFolder:FindFirstChild(plr.Name .. "_ESP")
    if tag then
        tag:Destroy()
    end
end)



Rayfield:LoadConfiguration()
