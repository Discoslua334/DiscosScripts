-- =================================================================================
-- I shall keep updating and adding more Features that i'd think you'd like!!
-- Open Source
-- This script isnt obfuscated so you're free t ochange keybind
-- i might add more shit soon
-- WELCOME TO DISCO'S SCRIPTS.
-- =================================================================================
local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

-- SSPY(Simplespy) knowledge and definitions
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
-- RemoteEvent name used for every feature
local EventRelay = ReplicatedStorage:WaitForChild("Network"):WaitForChild("Bridge"):WaitForChild("EventRelay")
-- Widgets/Components of the script
local Window = WindUI:CreateWindow({
    Title = "Frisbee Hub (AUTO)",
    Icon = "disc",
    Author = "Free Version, Paid is obfuscated with luraph",
    Size = UDim2.fromOffset(480, 420),
    Theme = "Dark",
    Transparent = true,
})

pcall(function()
    Window:EditOpenButton({
        Title = "Open Menu",
        Icon = "disc",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(
            Color3.fromHex("FF0F7B"),
            Color3.fromHex("F89B29")
        ),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true,
    })
end)

local MainTab = Window:Tab({
    Title = "Automation",
    Icon = "zap",
})

local autoThrow = false
local holdDuration = 1.0
local throwCooldown = 1.5

local autoTrain = false
local trainDelay = 0.05

local autoTrainBoost = false
local boostCheckDelay = 1.0

--  AUTO-THROW 
MainTab:Section({ Title = "Auto Throw (Mouse Hold)" })

local ThrowToggle = MainTab:Toggle({
    Title = "Enable Auto-Throw [F]",
    Desc = "Simulates holding Left-Click to charge to 100% and release",
    Value = false,
    Callback = function(state)
        autoThrow = state
        if autoThrow then
            task.spawn(function()
                while autoThrow do
                    VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                    
                    local elapsed = 0
                    while elapsed < holdDuration and autoThrow do
                        elapsed += task.wait()
                    end
                    
                    VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                    
                    if not autoThrow then break end
                    task.wait(throwCooldown)
                end
            end)
        else
            VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 1)
        end
    end
})

MainTab:Slider({
    Title = "Hold Duration (Seconds)",
    Desc = "Adjust how long it holds to reach 100%",
    Step = 0.05,
    Value = {
        Min = 0.2,
        Max = 3.0,
        Default = 1.0,
    },
    Callback = function(value)
        holdDuration = value
    end
})

MainTab:Slider({
    Title = "Throw Cooldown (Seconds)",
    Desc = "Wait time between throws",
    Step = 0.1,
    Value = {
        Min = 0.5,
        Max = 5.0,
        Default = 1.5,
    },
    Callback = function(value)
        throwCooldown = value
    end
})

--  AUTO-TRAIN 
MainTab:Section({ Title = "Auto Train & Boosts" })

local TrainToggle = MainTab:Toggle({
    Title = "Enable Auto-Train [G]",
    Desc = "Rapidly fires the TrainClick remote event",
    Value = false,
    Callback = function(state)
        autoTrain = state
        if autoTrain then
            task.spawn(function()
                local trainArgs = { "TrainClick" }
                while autoTrain do
                    EventRelay:FireServer(unpack(trainArgs))
                    task.wait(trainDelay)
                end
            end)
        end
    end
})

MainTab:Slider({
    Title = "Train Click Delay (Seconds)",
    Desc = "Lower = faster clicks",
    Step = 0.01,
    Value = {
        Min = 0.01,
        Max = 0.5,
        Default = 0.05,
    },
    Callback = function(value)
        trainDelay = value
    end
})

--  AUTO-CLAIM TRAIN BOOST 
MainTab:Toggle({
    Title = "Auto-Claim Train Boost",
    Desc = "Automatically finds and claims TrainBoost whenever it spawns",
    Value = false,
    Callback = function(state)
        autoTrainBoost = state
        if autoTrainBoost then
            task.spawn(function()
                local boostArgs = { "TrainBoost" }
                while autoTrainBoost do
                    EventRelay:FireServer(unpack(boostArgs))
                    
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        for _, obj in ipairs(playerGui:GetDescendants()) do
                            if obj:IsA("GuiButton") and obj.Visible and string.find(string.lower(obj.Name), "boost") then
                                if firesignal then
                                    pcall(function() firesignal(obj.MouseButton1Click) end)
                                    pcall(function() firesignal(obj.Activated) end)
                                end
                            end
                        end
                    end
                    
                    task.wait(boostCheckDelay)
                end
            end)
        end
    end
})

-- Keybind Support (F = Auto-Throw, G = Auto-Train)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        ThrowToggle:Set(not autoThrow)
    elseif input.KeyCode == Enum.KeyCode.G then
        TrainToggle:Set(not autoTrain)
    end
end)

WindUI:Notify({
    Title = "Hub Loaded",
    Content = "Press F for Auto-Throw or G for Auto-Train",
    Icon = "check",
    Duration = 4,
})
