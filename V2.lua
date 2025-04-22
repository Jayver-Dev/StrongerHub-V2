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
local SettingsTab = Window:CreateTab("Misc", "cog")

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

local EspTab = Window:CreateTab("ESP", "eye")
local EspSection = EspTab:CreateSection("ESP Settings")

local showNames = true
local showBoxes = false
local useDistance = false
local maxDistance = 300
local espColor = Color3.fromRGB(255, 255, 255)
local showTracers = false
local teamCheck = false
local show3DBoxes = false

local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "StrongerHubAdvancedESP"

local function clearESP()
    espFolder:ClearAllChildren()
end

local function isSameTeam(player)
    return teamCheck and player.Team == LocalPlayer.Team
end

local function createESP(player)
    if player == LocalPlayer or isSameTeam(player) then return end
    if not player.Character or not player.Character:FindFirstChild("Head") then return end
    local head = player.Character.Head
    local root = player.Character:FindFirstChild("HumanoidRootPart")

    if showNames then
        local nameTag = Instance.new("BillboardGui")
        nameTag.Name = player.Name .. "_ESP_Name"
        nameTag.Adornee = head
        nameTag.Size = UDim2.new(0, 100, 0, 30)
        nameTag.StudsOffset = Vector3.new(0, 2, 0)
        nameTag.AlwaysOnTop = true
        nameTag.Parent = espFolder

        local nameLabel = Instance.new("TextLabel", nameTag)
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = espColor
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSansBold
    end

    if showBoxes and root then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = player.Name .. "_ESP_Box"
        box.Adornee = root
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Size = player.Character:GetExtentsSize()
        box.Color3 = espColor
        box.Transparency = 0.5
        box.Parent = espFolder
    end

    if showTracers and root then
        local line = Drawing.new("Line")
        line.Visible = true
        line.Color = espColor
        line.Thickness = 1
        line.Transparency = 1
        line.ZIndex = 2

        task.spawn(function()
            while line and line.Visible and player and player.Character and root and root:IsDescendantOf(workspace) do
                local rootPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y)

                if onScreen then
                    line.From = screenCenter
                    line.To = Vector2.new(rootPos.X, rootPos.Y)
                    line.Color = espColor
                    line.Visible = true
                else
                    line.Visible = false
                end
                task.wait()
            end
            if line then
                line:Remove()
            end
        end)
    end

    if show3DBoxes and root then
        local box3D = Instance.new("SelectionBox")
        box3D.Adornee = player.Character
        box3D.LineThickness = 0.05
        box3D.Color3 = espColor
        box3D.SurfaceTransparency = 1
        box3D.Parent = espFolder
    end
end

local function updateESP()
    clearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not useDistance or (player.Character and LocalPlayer:DistanceFromCharacter(player.Character:GetPivot().Position) <= maxDistance) then
                createESP(player)
            end
        end
    end
end

-- UI Controls
EspTab:CreateToggle({
    Name = "Show Name Tags",
    CurrentValue = showNames,
    Callback = function(state)
        showNames = state
        updateESP()
    end
})

EspTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = showBoxes,
    Callback = function(state)
        showBoxes = state
        updateESP()
    end
})

EspTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = showTracers,
    Callback = function(state)
        showTracers = state
        updateESP()
    end
})

EspTab:CreateToggle({
    Name = "3D Selection Box",
    CurrentValue = show3DBoxes,
    Callback = function(state)
        show3DBoxes = state
        updateESP()
    end
})

EspTab:CreateToggle({
    Name = "Use Distance Limit",
    CurrentValue = useDistance,
    Callback = function(state)
        useDistance = state
        updateESP()
    end
})

EspTab:CreateSlider({
    Name = "Max ESP Distance",
    Range = {50, 1000},
    Increment = 10,
    CurrentValue = maxDistance,
    Suffix = "Studs",
    Callback = function(value)
        maxDistance = value
        if useDistance then updateESP() end
    end
})

EspTab:CreateToggle({
    Name = "Team Check (ignore teammates)",
    CurrentValue = teamCheck,
    Callback = function(state)
        teamCheck = state
        updateESP()
    end
})

EspTab:CreateColorPicker({
    Name = "ESP Color",
    Color = espColor,
    Callback = function(color)
        espColor = color
        updateESP()
    end
})

-- Auto update for new players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        updateESP()
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    for _, gui in pairs(espFolder:GetChildren()) do
        if gui.Name:match(player.Name) then
            gui:Destroy()
        end
    end
end)

-- First update
updateESP()


ScriptsTab:CreateButton({
    Name = "Enable Fly",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Entitynt/Roblox-Fly-Script/refs/heads/main/FlyCommand.lua", true))()
        Rayfield:Notify({
            Title = "Fly Enabled",
            Content = "Press 'F' to toggle fly mode.",
            Duration = 3,
            Image = "feather",
        })
    end
})


local HttpService = game:GetService("HttpService")
local ScriptSearchTab = Window:CreateTab("Script Search", "search")

local searchQuery = ""
local resultsSection = nil

-- Input Field for Search Query
ScriptSearchTab:CreateInput({
    Name = "Search Scripts",
    PlaceholderText = "Enter script name",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        searchQuery = text
    end
})

-- Search Button
ScriptSearchTab:CreateButton({
    Name = "Search",
    Callback = function()
        if searchQuery == "" then
            Rayfield:Notify({
                Title = "Error",
                Content = "Please enter a search query.",
                Duration = 3,
                Image = "alert-circle"
            })
            return
        end

        -- Clear previous results
        if resultsSection then
            resultsSection:Destroy()
        end

        -- Fetch scripts from ScriptBlox API
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://scriptblox.com/api/script/search?q=" .. searchQuery))
        end)

        if success and response and response.result and #response.result.scripts > 0 then
            resultsSection = ScriptSearchTab:CreateSection("Results for: " .. searchQuery)

            for i, scriptData in ipairs(response.result.scripts) do
                if i > 10 then break end -- Limit to 10 results
                local title = scriptData.title or "Untitled Script"
                local scriptCode = scriptData.script or ""
                local gameName = scriptData.game and scriptData.game.name or "Unknown Game"

                -- Button to Copy Script
                ScriptSearchTab:CreateButton({
                    Name = "[" .. gameName .. "] " .. title .. " (Copy)",
                    Callback = function()
                        setclipboard(scriptCode)
                        Rayfield:Notify({
                            Title = "Script Copied",
                            Content = "The script has been copied to clipboard.",
                            Duration = 4,
                            Image = "clipboard"
                        })
                    end
                })

                -- Button to Execute Script
                ScriptSearchTab:CreateButton({
                    Name = "[" .. gameName .. "] " .. title .. " (Run)",
                    Callback = function()
                        local func, err = loadstring(scriptCode)
                        if func then
                            pcall(func)
                            Rayfield:Notify({
                                Title = "Script Executed",
                                Content = "The script has been executed.",
                                Duration = 4,
                                Image = "terminal"
                            })
                        else
                            Rayfield:Notify({
                                Title = "Execution Error",
                                Content = "Failed to execute the script.",
                                Duration = 4,
                                Image = "alert-triangle"
                            })
                        end
                    end
                })
            end

            -- Attribution
            ScriptSearchTab:CreateLabel("Powered by ScriptBlox.com")
        else
            Rayfield:Notify({
                Title = "No Results",
                Content = "No matching scripts found. Try a different keyword.",
                Duration = 3,
                Image = "search"
            })
        end
    end
})

-- Infinite Jump
ScriptsTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(state)
        if state then
            Rayfield:Notify({
                Title = "Infinite Jump Enabled",
                Content = "Hold spacebar to keep jumping.",
                Duration = 3,
                Image = "chevrons-up"
            })

            getgenv().InfJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if getgenv().InfJumpConnection then
                getgenv().InfJumpConnection:Disconnect()
                getgenv().InfJumpConnection = nil
            end

            Rayfield:Notify({
                Title = "Infinite Jump Disabled",
                Content = "You can no longer infinitely jump.",
                Duration = 3,
                Image = "chevrons-down"
            })
        end
    end
})

-- Anti-AFK
ScriptsTab:CreateButton({
    Name = "Enable Anti-AFK",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)

        Rayfield:Notify({
            Title = "Anti-AFK Enabled",
            Content = "You will no longer be kicked for inactivity.",
            Duration = 4,
            Image = "alarm-clock"
        })
    end
})

-- Anti-Kick
ScriptsTab:CreateButton({
    Name = "Enable Anti-Kick",
    Callback = function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if tostring(self) == "Kick" or method == "Kick" then
                return
            end
            return oldNamecall(self, ...)
        end)

        setreadonly(mt, true)

        Rayfield:Notify({
            Title = "Anti-Kick Enabled",
            Content = "Kick attempts will be blocked.",
            Duration = 4,
            Image = "shield"
        })
    end
})

-- Hitbox Expander
ScriptsTab:CreateButton({
    Name = "Enable Hitbox Expander",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                player.Character.HumanoidRootPart.Transparency = 0.5
                player.Character.HumanoidRootPart.Material = Enum.Material.ForceField
            end
        end

        Rayfield:Notify({
            Title = "Hitbox Expanded",
            Content = "All players' hitboxes are enlarged.",
            Duration = 4,
            Image = "expand"
        })
    end
})


-- Function to get team color
local function GetTeamColor()
    local player = game.Players.LocalPlayer
    if player and player.Team then
        return player.TeamColor.Color
    else
        return Color3.fromRGB(255, 255, 255)  -- Default to white if no team is found
    end
end

-- Variables to store settings
local espFont = "Arial"
local espFontSize = 14
local teamColorSync = false
local espColor = Color3.fromRGB(255, 255, 255)  -- Default to white
local displayHealth = true
local healthBarStyle = "Bar"
local healthColorGradient = true
local npcEspEnabled = true
local npcTypeFilter = "All"
local npcHealthDisplay = true
local displayDistance = true
local espTransparency = 0.5

-- Function to display health bar with gradient
local function DisplayHealthBar(player, health)
    -- Use healthBarStyle to determine display format
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(health, 0, 1, 0)
    healthBar.BackgroundColor3 = healthColorGradient and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    healthBar.BackgroundTransparency = 0.5
    healthBar.Position = UDim2.new(0, 0, 0, 0)
    -- Add further customization based on `healthBarStyle`
    return healthBar
end

-- Function to update ESP settings
local function UpdateESPSettings()
    -- Loop through all players or NPCs and apply the settings
    for _, target in pairs(game.Players:GetPlayers()) do
        -- Skip local player if NPCESP is off
        if target == game.Players.LocalPlayer and not npcEspEnabled then
            continue
        end

        -- Check for NPC type filter
        if npcTypeFilter ~= "All" then
            -- Apply NPC filtering logic here if necessary
            -- e.g., skip NPCs based on their type if they don't match filter
        end

        -- Handle Team Color Sync
        if teamColorSync then
            espColor = GetTeamColor()
        end

        -- Display ESP for each player or NPC
        local espElement = Instance.new("TextLabel")
        espElement.Text = target.Name
        espElement.Font = Enum.Font[espFont]
        espElement.TextSize = espFontSize
        espElement.TextColor3 = espColor
        espElement.TextTransparency = espTransparency
        espElement.BackgroundTransparency = 1
        espElement.Position = UDim2.new(0, 0, 0, 0)  -- Positioning logic based on player or NPC
        espElement.Size = UDim2.new(0, 100, 0, 50)  -- Size logic, adjust as needed

        -- Add logic to render health if enabled
        if displayHealth then
            -- Get health percentage (e.g., from player or NPC health)
            local healthPercentage = target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health / target.Character.Humanoid.MaxHealth or 0
            local healthBar = DisplayHealthBar(target, healthPercentage)
            healthBar.Parent = espElement
        end

        -- Add the ESP element to the workspace/UI
        espElement.Parent = workspace -- Or your GUI container
    end
end

-- Team color sync toggle
local espToggle = EspTab:CreateToggle({
    Name = "Enable Team Color Sync",
    CurrentValue = false,
    Flag = "ColorSync",
    Callback = function(enabled)
        teamColorSync = enabled
        if enabled then
            espColor = GetTeamColor()  -- Fetch team color when enabled
        else
            espColor = Color3.fromRGB(255, 255, 255)  -- Default to white if disabled
        end
        UpdateESPSettings() -- Update ESP after toggle
    end
})

-- Display health toggle
local espToggle2 = EspTab:CreateToggle({
    Name = "Display Health",
    CurrentValue = true,
    Flag = "HealthDisplay",
    Callback = function(enabled)
        displayHealth = enabled
        UpdateESPSettings() -- Update ESP after toggle
    end
})

-- Health color gradient toggle
local espToggle3 = EspTab:CreateToggle({
    Name = "Health Color Gradient",
    CurrentValue = true,
    Flag = "HealthColor",
    Callback = function(enabled)
        healthColorGradient = enabled
        UpdateESPSettings() -- Update ESP after toggle
    end
})

-- Display distance toggle
local espToggle6 = EspTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = true,
    Flag = "Distance",
    Callback = function(enabled)
        displayDistance = enabled
        UpdateESPSettings() -- Update ESP after toggle
    end
})

-- Health bar style dropdown (Bar, Percentage, Numeric)
local espDropdown2 = EspTab:CreateDropdown({
    Name = "Health Bar Style",
    Options = {"Bar", "Percentage", "Numeric"},
    Default = "Bar",
    Callback = function(style)
        healthBarStyle = style
        UpdateESPSettings() -- Update ESP after dropdown change
    end
})

-- Call UpdateESPSettings() whenever settings are updated (on init or after changes)
UpdateESPSettings()

Rayfield:LoadConfiguration()
