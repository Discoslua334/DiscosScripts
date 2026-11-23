-- UNIVERSAL (DONT TRY IN GAMES WITH ANTICHEAT, IT DOES NOT HOOK SHIT TO BE UNDETECTED)
-- ===========================================================================================================
-- CHECK THE LAST LINE BRO
--  ____  ___ ____   ____ ___  ____  
-- |  _ \|_ _/ ___| / ___/ _ \/ ___| 
-- | | | || |\___ \| |  | | | \___ \ 
-- | |_| || | ___) | |__| |_| |___) |
-- |____/|___|____/ \____\___/|____/ 
--
--  _____ ____ ____  _____ ____ _____ ____  
-- / ____/ ___|  _ \|_   _/ ___|_   _/ ___|
-- \___ \ |   | |_) | | | \___ \ | | \___ \
--  ___) | |___|  _ <  | |  ___) || |  ___) |
-- |____/ \____|_| \_\ |_| |____/ |_| |____/

--  _____ ____  _____ _____
-- |  ___|  _ \| ____| ____|
-- | |_  | |_) |  _| |  _|
-- |  _| |  _ <| |___| |___
-- |_|   |_| \_\_____|_____|
--
--  ____  _____ ____   ___
-- |  _ \| ____|  _ \ / _ \
-- | |_) |  _| | |_) | | | |
-- |  _ <| |___|  __/| |_| |
-- |_| \_\_____|_|    \___/
-- Feel Free to skid this
-- Api version 1.124
-- API Status = 🟢
-- This script was made with passion 
-- FREE FOREVER YAYAYAYAYA
-- Build Version 1.15
-- OPEN SOURCED FOREVER (No single line's obfuscated)
-- Disco's Simple Aimbot.lua
-- your own experience
-- ==========================================================================================================
-- LOAD WINDUI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")



-- SETTINGS
local AimEnabled = false
local ESPEnabled = false
local TeamCheck = true

local FOVRadius = 200
local AimSmoothness = 0.20
local HoldingAim = false

local ESPObjects = {}

-- WINDOW

local Window = WindUI:CreateWindow({
    Title = "A Simple Aimbot Script",
    Icon = "crosshair",
    Author = "Aimbot.lua | Disco's script | Open source at GITHUB",
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightShift,

    OpenButton = {
        Title = "Open Menu",
        Icon = "menu",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 2,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,

        Color = ColorSequence.new(
            Color3.fromRGB(255, 35, 45),
            Color3.fromRGB(255, 35, 45)
        ),
    },
})

-- TABS
local AimTab = Window:Tab({
    Title = "Legit/Aim",
    Icon = "crosshair",
})

local ESPTab = Window:Tab({
    Title = "Visuals",
    Icon = "eye",
})

-- FOV CIRCLE
local CircleGui = Instance.new("ScreenGui")
CircleGui.Name = "DevFOV"
CircleGui.IgnoreGuiInset = true
CircleGui.ResetOnSpawn = false
CircleGui.Parent = PlayerGui

local Circle = Instance.new("Frame")
Circle.Name = "FOVCircle"
Circle.AnchorPoint = Vector2.new(0.5, 0.5)
Circle.Size = UDim2.fromOffset(FOVRadius * 2, FOVRadius * 2)
Circle.BackgroundTransparency = 1
Circle.Visible = false
Circle.Parent = CircleGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = Circle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(100, 160, 255)
CircleStroke.Thickness = 1.5
CircleStroke.Transparency = 0.15
CircleStroke.Parent = Circle

-- ESP
local function RemoveESP(player)
    local objects = ESPObjects[player]

    if not objects then
        return
    end

    if objects.Highlight then
        objects.Highlight:Destroy()
    end

    if objects.Billboard then
        objects.Billboard:Destroy()
    end

    ESPObjects[player] = nil
end

local function CreateESP(player)
    if player == LocalPlayer then
        return
    end

    local character = player.Character
    if not character then
        return
    end

    local head = character:FindFirstChild("Head")
    if not head then
        return
    end

    RemoveESP(player)

    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(65, 145, 255)
    highlight.OutlineColor = Color3.fromRGB(135, 190, 255)
    highlight.FillTransparency = 0.8
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = Workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.fromOffset(150, 28)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = PlayerGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = player.DisplayName
    label.TextColor3 = Color3.fromRGB(220, 235, 255)
    label.TextStrokeTransparency = 0.3
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    ESPObjects[player] = {
        Highlight = highlight,
        Billboard = billboard
    }
end

local function SetESP(state)
    ESPEnabled = state

    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            CreateESP(player)
        end
    else
        for player in pairs(ESPObjects) do
            RemoveESP(player)
        end
    end
end

local function TrackPlayer(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.3)

        if ESPEnabled then
            CreateESP(player)
        end
    end)

    player.CharacterRemoving:Connect(function()
        RemoveESP(player)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    TrackPlayer(player)
end

Players.PlayerAdded:Connect(TrackPlayer)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- AIM SETTINGS
AimTab:Toggle({
    Title = "Enable Aim Assist",
    Desc = "Hold right mouse button to aim at a target.",
    Icon = "crosshair",
    Value = false,

    Callback = function(value)
        AimEnabled = value
        Circle.Visible = value
    end
})

AimTab:Slider({
    Title = "FOV Radius",
    Desc = "Adjust the target selection radius.",
    Step = 5,

    Value = {
        Min = 50,
        Max = 400,
        Default = 140,
    },

    Callback = function(value)
        FOVRadius = value
        Circle.Size = UDim2.fromOffset(
            value * 2,
            value * 2
        )
    end
})

AimTab:Slider({
    Title = "Aim Smoothness",
    Desc = "Higher values move the camera faster.",
    Step = 0.05,

    Value = {
        Min = 0.05,
        Max = 1,
        Default = 0.20,
    },

    Callback = function(value)
        AimSmoothness = value
    end
})

-- VISUAL SETTINGS
ESPTab:Toggle({
    Title = "Player ESP",
    Desc = "Highlight player characters and display names.",
    Icon = "eye",
    Value = false,

    Callback = function(value)
        SetESP(value)
    end
})

ESPTab:Toggle({
    Title = "Team Check",
    Desc = "Ignore teammates when selecting aim targets.",
    Icon = "users",
    Value = true,

    Callback = function(value)
        TeamCheck = value
    end
})

-- INPUT
UIS.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        HoldingAim = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        HoldingAim = false
    end
end)

-- TARGET FINDER
local function GetClosestTarget()
    local camera = Workspace.CurrentCamera
    if not camera then
        return nil
    end

    local mousePosition = UIS:GetMouseLocation()
    local closestTarget = nil
    local closestDistance = FOVRadius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character
                and character:FindFirstChildOfClass("Humanoid")
            local head = character
                and character:FindFirstChild("Head")

            local validTeam =
                not TeamCheck
                or LocalPlayer.Team == nil
                or player.Team ~= LocalPlayer.Team

            if humanoid and humanoid.Health > 0
                and head and validTeam then

                local position, onScreen =
                    camera:WorldToViewportPoint(head.Position)

                if onScreen and position.Z > 0 then
                    local distance = (
                        Vector2.new(position.X, position.Y)
                        - mousePosition
                    ).Magnitude

                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = head
                    end
                end
            end
        end
    end

    return closestTarget
end

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    local camera = Workspace.CurrentCamera

    if not camera then
        return
    end

    local mousePosition = UIS:GetMouseLocation()

    Circle.Position = UDim2.fromOffset(
        mousePosition.X,
        mousePosition.Y
    )

    if not AimEnabled or not HoldingAim then
        return
    end

    local target = GetClosestTarget()

    if target then
        local origin = camera.CFrame.Position
        local direction = target.Position - origin

        -- Visibility check
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {
            LocalPlayer.Character
        }

        local result = Workspace:Raycast(
            origin,
            direction,
            params
        )

        if result and not result.Instance:IsDescendantOf(
            target.Parent
        ) then
            return
        end

        local desired = CFrame.lookAt(
            origin,
            target.Position
        )

        camera.CFrame = camera.CFrame:Lerp(
            desired,
            AimSmoothness
        )
    end
end)

print("Im gay you're gay we're all gay")
print("ea02443gt.json has been found")
