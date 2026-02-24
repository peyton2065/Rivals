--// Solix Hub — Production Loader (Keyless Edition)
--// Targets Xeno executor with graceful fallbacks
--// Self-contained, no external UI dependencies

repeat task.wait() until game:IsLoaded()

---------------------------------------------------------------------------
-- SECTION 1: Shims & Fallbacks
---------------------------------------------------------------------------
if not cloneref then cloneref = function(o) return o end end
if not isfile then isfile = function() return false end end
if not readfile then readfile = function() return "" end end
if not writefile then writefile = function() end end
if not makefolder then makefolder = function() end end
if not isfolder then isfolder = function() return false end end
if not setclipboard then setclipboard = function() end end
if not delfile then delfile = function() end end

if not getcustomasset then
    getcustomasset = function() return "rbxasset://fonts/families/GothamSSm.json" end
end

if not getexecutorname then
    if identifyexecutor then
        getexecutorname = identifyexecutor
    else
        getexecutorname = function() return "Unknown" end
    end
end

---------------------------------------------------------------------------
-- SECTION 2: Services (cloneref'd)
---------------------------------------------------------------------------
local CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService = cloneref(game:GetService("HttpService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TextService = cloneref(game:GetService("TextService"))
local RunService = cloneref(game:GetService("RunService"))

local Player = Players.LocalPlayer

---------------------------------------------------------------------------
-- SECTION 3: GUI Parent
---------------------------------------------------------------------------
local GuiParent
pcall(function()
    if gethui then
        GuiParent = gethui()
    end
end)
if not GuiParent then
    GuiParent = CoreGui
end

---------------------------------------------------------------------------
-- SECTION 4: Cleanup old instances
---------------------------------------------------------------------------
pcall(function()
    local old = GuiParent:FindFirstChild("SolixHub")
    if old then old:Destroy() end
end)
pcall(function()
    local old = GuiParent:FindFirstChild("SolixNotifications")
    if old then old:Destroy() end
end)
pcall(function()
    local old = GuiParent:FindFirstChild("SolixToggle")
    if old then old:Destroy() end
end)
pcall(function()
    local old = Lighting:FindFirstChild("SolixBlur")
    if old then old:Destroy() end
end)

---------------------------------------------------------------------------
-- SECTION 5: Configuration
---------------------------------------------------------------------------
local Config = {
    Name = "Solix Hub",
    Version = "v3.0.0",
    Discord = "https://discord.gg/solixhub",
    Website = "https://solixhub.com/",
    AutoExecute = false,
}

local Theme = {
    Background = Color3.fromRGB(18, 15, 22),
    Surface = Color3.fromRGB(26, 22, 30),
    SurfaceLight = Color3.fromRGB(36, 32, 42),
    Accent = Color3.fromRGB(105, 135, 255),
    Text = Color3.fromRGB(240, 240, 245),
    TextSecondary = Color3.fromRGB(155, 155, 170),
    Border = Color3.fromRGB(50, 45, 58),
    Success = Color3.fromRGB(75, 220, 100),
    Error = Color3.fromRGB(240, 65, 65),
    Warning = Color3.fromRGB(240, 190, 50),
}

---------------------------------------------------------------------------
-- SECTION 6: Game Registry (keyed by GameId, NOT PlaceId)
---------------------------------------------------------------------------
local GameRegistry = {
    ["3808223175"] = {
        Name = "Jujutsu Infinite",
        ScriptURL = nil,
        LuarmorId = "4fe2dfc202115670b1813277df916ab2",
    },
    ["994732206"] = {
        Name = "Blox Fruits",
        ScriptURL = nil,
        LuarmorId = "e2718ddebf562c5c4080dfce26b09398",
    },
    ["1650291138"] = {
        Name = "Demon Fall",
        ScriptURL = nil,
        LuarmorId = "9b64d07193c7c2aef970d57aeb286e70",
    },
    ["1511883870"] = {
        Name = "Shindo Life",
        ScriptURL = nil,
        LuarmorId = "fefdf5088c44beb34ef52ed6b520507c",
    },
    ["6035872082"] = {
        Name = "Rivals",
        ScriptURL = nil,
        LuarmorId = "3bb7969a9ecb9e317b0a24681327c2e2",
    },
    ["245662005"] = {
        Name = "Jailbreak",
        ScriptURL = nil,
        LuarmorId = "21ad7f491e4658e9dc9529a60c887c6e",
    },
    ["7018190066"] = {
        Name = "Dead Rails",
        ScriptURL = nil,
        LuarmorId = "98f5c64a0a9ecca29517078597bbcbdb",
    },
    ["7074860883"] = {
        Name = "Arise Crossover",
        ScriptURL = nil,
        LuarmorId = "0c8fdf9bb25a6a7071731b72a90e3c69",
    },
    ["7436755782"] = {
        Name = "Grow a Garden",
        ScriptURL = nil,
        LuarmorId = "e4ea33e9eaf0ae943d59ea98f2444ebe",
    },
    ["7326934954"] = {
        Name = "99 Nights in the Forest",
        ScriptURL = nil,
        LuarmorId = "00e140acb477c5ecde501c1d448df6f9",
    },
    ["7671049560"] = {
        Name = "The Forge",
        ScriptURL = nil,
        LuarmorId = "c0b41e859f576fb70183206224d4a75f",
    },
    ["6760085372"] = {
        Name = "Jujutsu: Zero",
        ScriptURL = nil,
        LuarmorId = "e380382a05647eabda3a9892f95952c6",
    },
    ["9266873836"] = {
        Name = "Anime Fighting Simulator",
        ScriptURL = nil,
        LuarmorId = "3f9d315017ec895ded5c3350fd6e45a0",
    },
    ["3317771874"] = {
        Name = "Pet Simulator 99",
        ScriptURL = nil,
        LuarmorId = "e95ef6f27596e636a7d706375c040de4",
    },
    ["9363735110"] = {
        Name = "Escape Tsunami For Brainrots!",
        ScriptURL = nil,
        LuarmorId = "4948419832e0bd4aa588e628c45b6f8d",
    },
    ["8144728961"] = {
        Name = "Abyss 67",
        ScriptURL = nil,
        LuarmorId = "50721a1cda76bf61b31ae6e7284a5ea3",
    },
    ["9509842868"] = {
        Name = "Gaarden Horizon",
        ScriptURL = nil,
        LuarmorId = "cda910bd16c73785463fbe982d64994d",
    },
}

-- USE game.GameId (matches original script), converted to string for lookup
local CurrentGameId = tostring(game.GameId)
local CurrentGame = GameRegistry[CurrentGameId]

local ExecutorName = "Unknown"
pcall(function() ExecutorName = getexecutorname():match("^%s*(.-)%s*$") or "Unknown" end)

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ScriptLoaded = false
local HubOpen = false
local Minimized = false

local SupportedGameCount = 0
for _ in pairs(GameRegistry) do SupportedGameCount = SupportedGameCount + 1 end

---------------------------------------------------------------------------
-- SECTION 7: Utilities
---------------------------------------------------------------------------
local function QuickTween(obj, props, duration, style, direction)
    if not obj then return nil end
    local ok = pcall(function() local _ = obj.Parent end)
    if not ok then return nil end
    local info = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function CreateInstance(className, properties, parent)
    local inst = Instance.new(className)
    if properties then
        for k, v in pairs(properties) do
            pcall(function() inst[k] = v end)
        end
    end
    if parent then
        inst.Parent = parent
    end
    return inst
end

local function SetupFolders()
    if not isfolder("solixhub") then pcall(makefolder, "solixhub") end
    if not isfolder("solixhub/Assets") then pcall(makefolder, "solixhub/Assets") end
end

SetupFolders()

---------------------------------------------------------------------------
-- SECTION 8: Font Loading
---------------------------------------------------------------------------
local CustomFont
pcall(function()
    local fontPath = "solixhub/Assets/InterSemiBold.ttf"
    if not isfile(fontPath) then
        local data = game:HttpGet("https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf")
        writefile(fontPath, data)
    end
    local fontData = {
        name = "InterSemiBold",
        faces = {{
            name = "InterSemiBold",
            weight = 400,
            style = "Regular",
            assetId = getcustomasset(fontPath)
        }}
    }
    writefile("solixhub/Assets/InterSemiBold.font", HttpService:JSONEncode(fontData))
    CustomFont = Font.new(getcustomasset("solixhub/Assets/InterSemiBold.font"))
end)

if not CustomFont then
    pcall(function()
        CustomFont = Font.fromEnum(Enum.Font.GothamBold)
    end)
    if not CustomFont then
        CustomFont = Font.fromEnum(Enum.Font.SourceSansBold)
    end
end

local CustomFontMedium
pcall(function()
    CustomFontMedium = Font.fromEnum(Enum.Font.GothamMedium)
end)
if not CustomFontMedium then
    CustomFontMedium = CustomFont
end

---------------------------------------------------------------------------
-- SECTION 9: Main Scope
---------------------------------------------------------------------------
local function Main()
    local BlurEffect
    local SplashGui
    local HubGui
    local NotifGui
    local ToggleGui
    local ToggleButton

    -------------------------------------------------------------------
    -- NOTIFICATION SYSTEM
    -------------------------------------------------------------------
    NotifGui = CreateInstance("ScreenGui", {
        Name = "SolixNotifications",
        DisplayOrder = 1100,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    }, GuiParent)

    local NotifContainer = CreateInstance("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.new(0, 300, 1, -32),
        BackgroundTransparency = 1,
    }, NotifGui)

    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    }, NotifContainer)

    local function Notify(title, desc, duration, color)
        duration = duration or 4
        color = color or Theme.Accent

        local maxW = 280

        local titleSize = TextService:GetTextSize(
            title, 14, Enum.Font.GothamBold, Vector2.new(maxW - 32, 1000)
        )
        local descSize = TextService:GetTextSize(
            desc, 13, Enum.Font.GothamMedium, Vector2.new(maxW - 32, 1000)
        )

        local frameW = math.min(maxW, math.max(titleSize.X, descSize.X) + 36)
        local frameH = titleSize.Y + descSize.Y + 38

        local frame = CreateInstance("Frame", {
            Size = UDim2.new(0, frameW, 0, 0),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0,
            ClipsDescendants = true,
        }, NotifContainer)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 8) }, frame)
        CreateInstance("UIStroke", {
            Color = Theme.Border,
            Thickness = 1,
            Transparency = 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, frame)

        -- Accent bar on left
        local accentBar = CreateInstance("Frame", {
            Size = UDim2.new(0, 3, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
        }, frame)
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 3),
        }, accentBar)

        local titleLabel = CreateInstance("TextLabel", {
            Position = UDim2.new(0, 14, 0, 8),
            Size = UDim2.new(1, -22, 0, titleSize.Y),
            BackgroundTransparency = 1,
            FontFace = CustomFont,
            Text = title,
            TextColor3 = Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
        }, frame)

        local descLabel = CreateInstance("TextLabel", {
            Position = UDim2.new(0, 14, 0, 8 + titleSize.Y + 4),
            Size = UDim2.new(1, -22, 0, descSize.Y),
            BackgroundTransparency = 1,
            FontFace = CustomFontMedium,
            Text = desc,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextTransparency = 1,
        }, frame)

        -- Timer bar
        local timerBg = CreateInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -6),
            Size = UDim2.new(1, -16, 0, 3),
            BackgroundColor3 = Theme.SurfaceLight,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
        }, frame)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 2) }, timerBg)

        local timerFill = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
        }, timerBg)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 2) }, timerFill)

        -- Animate in
        QuickTween(frame, { Size = UDim2.new(0, frameW, 0, frameH) }, 0.4, Enum.EasingStyle.Exponential)
        task.defer(function()
            task.wait(0.05)
            QuickTween(titleLabel, { TextTransparency = 0 }, 0.3)
            QuickTween(descLabel, { TextTransparency = 0 }, 0.3)
            QuickTween(timerBg, { BackgroundTransparency = 0 }, 0.3)
            QuickTween(timerFill, { BackgroundTransparency = 0 }, 0.3)
            QuickTween(timerFill, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        end)

        task.delay(duration, function()
            if not frame or not frame.Parent then return end
            QuickTween(titleLabel, { TextTransparency = 1 }, 0.3)
            QuickTween(descLabel, { TextTransparency = 1 }, 0.3)
            QuickTween(timerBg, { BackgroundTransparency = 1 }, 0.3)
            QuickTween(timerFill, { BackgroundTransparency = 1 }, 0.3)
            QuickTween(frame, { Size = UDim2.new(0, frameW, 0, 0), BackgroundTransparency = 1 }, 0.4, Enum.EasingStyle.Exponential)
            task.wait(0.45)
            if frame and frame.Parent then frame:Destroy() end
        end)
    end

    -------------------------------------------------------------------
    -- SCRIPT LOADING (NO KEY)
    -------------------------------------------------------------------
    local function LoadGameScript()
        if ScriptLoaded then return true end
        if not CurrentGame then return false end

        -- Method 1: Direct URL fetch
        if CurrentGame.ScriptURL and CurrentGame.ScriptURL ~= "" then
            local ok, err = pcall(function()
                local code = game:HttpGet(CurrentGame.ScriptURL)
                local fn = loadstring(code)
                if fn then fn() end
            end)
            if ok then
                ScriptLoaded = true
                return true
            else
                Notify("Warning", "Direct load failed, trying fallback...", 3, Theme.Warning)
            end
        end

        -- Method 2: Luarmor keyless API
        if CurrentGame.LuarmorId and CurrentGame.LuarmorId ~= "" then
            local ok, err = pcall(function()
                local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
                api.script_id = CurrentGame.LuarmorId
                api.load_script()
            end)
            if ok then
                ScriptLoaded = true
                return true
            else
                Notify("Load Error", "Failed: " .. tostring(err), 6, Theme.Error)
                return false
            end
        end

        Notify("Error", "No loading method available for this game.", 5, Theme.Error)
        return false
    end

    -------------------------------------------------------------------
    -- SPLASH SCREEN (Phase 1)
    -------------------------------------------------------------------
    local function CreateSplash(onComplete)
        SplashGui = CreateInstance("ScreenGui", {
            Name = "SolixSplash",
            DisplayOrder = 1050,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
        }, GuiParent)

        pcall(function()
            BlurEffect = CreateInstance("BlurEffect", {
                Name = "SolixBlur",
                Size = 0,
            }, Lighting)
        end)

        local backdrop = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(8, 6, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        }, SplashGui)

        local center = CreateInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 400, 0, 180),
            BackgroundTransparency = 1,
        }, backdrop)

        local glow = CreateInstance("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.3, 0),
            Size = UDim2.new(0, 250, 0, 250),
            BackgroundTransparency = 1,
            Image = "rbxassetid://7669129898",
            ImageColor3 = Theme.Accent,
            ImageTransparency = 1,
        }, center)

        local title = CreateInstance("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 1,
            FontFace = CustomFont,
            Text = Config.Name,
            TextColor3 = Theme.Accent,
            TextSize = 38,
            TextTransparency = 1,
        }, center)

        local subtitle = CreateInstance("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 52),
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundTransparency = 1,
            FontFace = CustomFontMedium,
            Text = Config.Version .. " — Premium Game Hub",
            TextColor3 = Theme.TextSecondary,
            TextSize = 15,
            TextTransparency = 1,
        }, center)

        local barBg = CreateInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 95),
            Size = UDim2.new(0, 260, 0, 5),
            BackgroundColor3 = Theme.SurfaceLight,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
        }, center)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 3) }, barBg)

        local barFill = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
        }, barBg)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 3) }, barFill)

        local status = CreateInstance("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 112),
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            FontFace = CustomFontMedium,
            Text = "Initializing...",
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            TextTransparency = 1,
        }, center)

        task.spawn(function()
            QuickTween(backdrop, { BackgroundTransparency = 0 }, 0.5)
            if BlurEffect then
                pcall(function() QuickTween(BlurEffect, { Size = 20 }, 0.5) end)
            end
            task.wait(0.2)

            QuickTween(glow, { ImageTransparency = 0.7 }, 0.6, Enum.EasingStyle.Exponential)
            QuickTween(title, { TextTransparency = 0 }, 0.6, Enum.EasingStyle.Exponential)
            task.wait(0.15)

            QuickTween(subtitle, { TextTransparency = 0 }, 0.5, Enum.EasingStyle.Exponential)
            task.wait(0.2)

            QuickTween(barBg, { BackgroundTransparency = 0 }, 0.3)
            QuickTween(barFill, { BackgroundTransparency = 0 }, 0.3)
            QuickTween(status, { TextTransparency = 0 }, 0.3)
            task.wait(0.15)

            local stages = {
                { pct = 0.25, text = "Validating executor..." },
                { pct = 0.50, text = "Checking game support..." },
                { pct = 0.75, text = "Loading resources..." },
                { pct = 1.00, text = "Ready!" },
            }

            for _, stage in ipairs(stages) do
                if status and status.Parent then status.Text = stage.text end
                QuickTween(barFill, { Size = UDim2.new(stage.pct, 0, 1, 0) }, 0.5, Enum.EasingStyle.Quad)
                task.wait(0.6)
            end

            task.wait(0.3)

            QuickTween(title, { TextTransparency = 1 }, 0.4)
            QuickTween(subtitle, { TextTransparency = 1 }, 0.4)
            QuickTween(barBg, { BackgroundTransparency = 1 }, 0.4)
            QuickTween(barFill, { BackgroundTransparency = 1 }, 0.4)
            QuickTween(status, { TextTransparency = 1 }, 0.4)
            QuickTween(glow, { ImageTransparency = 1 }, 0.4)
            QuickTween(backdrop, { BackgroundTransparency = 1 }, 0.5)

            if BlurEffect then
                pcall(function() QuickTween(BlurEffect, { Size = 0 }, 0.4) end)
            end

            task.wait(0.55)
            if SplashGui and SplashGui.Parent then SplashGui:Destroy() end
            SplashGui = nil

            if onComplete then onComplete() end
        end)
    end

    -------------------------------------------------------------------
    -- TOGGLE BUTTON CREATION (shared helper)
    -------------------------------------------------------------------
    local function CreateToggleButton()
        if ToggleGui and ToggleGui.Parent then return end

        ToggleGui = CreateInstance("ScreenGui", {
            Name = "SolixToggle",
            DisplayOrder = 1001,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
        }, GuiParent)

        local togglePos = IsMobile
            and UDim2.new(0, 10, 1, -60)
            or UDim2.new(0, 10, 0.5, 0)

        ToggleButton = CreateInstance("TextButton", {
            AnchorPoint = IsMobile and Vector2.new(0, 1) or Vector2.new(0, 0.5),
            Position = togglePos,
            Size = UDim2.new(0, 44, 0, 44),
            BackgroundColor3 = Theme.Accent,
            FontFace = CustomFont,
            Text = "S",
            TextColor3 = Theme.Text,
            TextSize = 20,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            TextTransparency = 1,
        }, ToggleGui)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 10) }, ToggleButton)
        CreateInstance("UIStroke", {
            Color = Theme.Border,
            Thickness = 1,
            Transparency = 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, ToggleButton)

        QuickTween(ToggleButton, { BackgroundTransparency = 0, TextTransparency = 0 }, 0.3)

        -- Toggle draggable
        local tDragging = false
        local tDragStart, tStartPos
        local dragDelta = 0

        ToggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                tDragging = true
                tDragStart = input.Position
                tStartPos = ToggleButton.Position
                dragDelta = 0

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        tDragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if tDragging and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            ) then
                local delta = input.Position - tDragStart
                dragDelta = delta.Magnitude
                ToggleButton.Position = UDim2.new(
                    tStartPos.X.Scale, tStartPos.X.Offset + delta.X,
                    tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y
                )
            end
        end)

        ToggleButton.MouseButton1Click:Connect(function()
            if dragDelta > 5 then return end -- Was a drag, not a click
            if ToggleGui and ToggleGui.Parent then
                QuickTween(ToggleButton, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.2)
                task.wait(0.25)
                if ToggleGui and ToggleGui.Parent then ToggleGui:Destroy(); ToggleGui = nil end
            end
            Minimized = false
            CreateHub()
        end)
    end

    -------------------------------------------------------------------
    -- HUB PANEL (Phase 2) — forward declaration
    -------------------------------------------------------------------
    local CreateHub

    CreateHub = function()
        HubOpen = true
        Minimized = false

        local panelW = IsMobile and 370 or 480
        local panelH = IsMobile and 340 or 320

        HubGui = CreateInstance("ScreenGui", {
            Name = "SolixHub",
            DisplayOrder = 1000,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
        }, GuiParent)

        local overlay = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        }, HubGui)

        pcall(function()
            if not BlurEffect or not BlurEffect.Parent then
                BlurEffect = CreateInstance("BlurEffect", {
                    Name = "SolixBlur",
                    Size = 0,
                }, Lighting)
            end
        end)

        local panel = CreateInstance("Frame", {
            Name = "Panel",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            ClipsDescendants = true,
        }, HubGui)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 10) }, panel)

        local panelStroke = CreateInstance("UIStroke", {
            Color = Theme.Border,
            Thickness = 1,
            Transparency = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, panel)

        -- HEADER
        local header = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 1,
        }, panel)

        local headerTitle = CreateInstance("TextLabel", {
            Position = UDim2.new(0, 16, 0, 0),
            Size = UDim2.new(0.6, 0, 1, 0),
            BackgroundTransparency = 1,
            FontFace = CustomFont,
            Text = Config.Name,
            TextColor3 = Theme.Accent,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
        }, header)

        local closeBtn = CreateInstance("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.new(0, 30, 0, 30),
            BackgroundColor3 = Theme.SurfaceLight,
            BackgroundTransparency = 1,
            FontFace = CustomFont,
            Text = "×",
            TextColor3 = Theme.TextSecondary,
            TextSize = 22,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            TextTransparency = 1,
        }, header)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 6) }, closeBtn)

        local minBtn = CreateInstance("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -48, 0.5, 0),
            Size = UDim2.new(0, 30, 0, 30),
            BackgroundColor3 = Theme.SurfaceLight,
            BackgroundTransparency = 1,
            FontFace = CustomFont,
            Text = "−",
            TextColor3 = Theme.TextSecondary,
            TextSize = 22,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            TextTransparency = 1,
        }, header)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 6) }, minBtn)

        -- SEPARATOR
        local separator = CreateInstance("Frame", {
            Position = UDim2.new(0.05, 0, 0, 50),
            Size = UDim2.new(0.9, 0, 0, 1),
            BackgroundColor3 = Theme.Border,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
        }, panel)

        -- INFO CARD
        local infoCard = CreateInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 60),
            Size = UDim2.new(0, panelW - 32, 0, 90),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
        }, panel)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 8) }, infoCard)
        local infoStroke = CreateInstance("UIStroke", {
            Color = Theme.Border,
            Thickness = 1,
            Transparency = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, infoCard)

        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
        }, infoCard)

        local gameName = CurrentGame and CurrentGame.Name or "Unsupported Game"
        local gameNameLabel = CreateInstance("TextLabel", {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            FontFace = CustomFont,
            Text = gameName,
            TextColor3 = Theme.Text,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
        }, infoCard)

        local detailText = string.format(
            "ID: %s  •  Executor: %s  •  Games: %d",
            CurrentGameId, ExecutorName, SupportedGameCount
        )
        local detailLabel = CreateInstance("TextLabel", {
            Position = UDim2.new(0, 0, 0, 22),
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            FontFace = CustomFontMedium,
            Text = detailText,
            TextColor3 = Theme.TextSecondary,
            TextSize = IsMobile and 10 or 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, infoCard)

        local statusText = CurrentGame and "Ready to execute" or "Game not supported"
        local statusColor = CurrentGame and Theme.Accent or Theme.Error
        local statusLabel = CreateInstance("TextLabel", {
            Position = UDim2.new(0, 0, 0, 46),
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            FontFace = CustomFontMedium,
            Text = "Status: " .. statusText,
            TextColor3 = statusColor,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
        }, infoCard)

        -- EXECUTE BUTTON
        local execBtnColor = CurrentGame and Theme.Accent or Color3.fromRGB(60, 58, 65)
        local execBtnText = CurrentGame and "Execute Script" or "Not Supported"

        local execBtn = CreateInstance("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 162),
            Size = UDim2.new(0, panelW - 32, 0, 46),
            BackgroundColor3 = execBtnColor,
            FontFace = CustomFont,
            Text = execBtnText,
            TextColor3 = Theme.Text,
            TextSize = 16,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            TextTransparency = 1,
        }, panel)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 8) }, execBtn)
        local execStroke = CreateInstance("UIStroke", {
            Color = Theme.Border,
            Thickness = 1,
            Transparency = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, execBtn)

        -- SOCIAL BUTTONS ROW
        local socialRow = CreateInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 220),
            Size = UDim2.new(0, panelW - 32, 0, 38),
            BackgroundTransparency = 1,
        }, panel)

        local halfW = math.floor((panelW - 32 - 8) / 2)

        local discordBtn = CreateInstance("TextButton", {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, halfW, 1, 0),
            BackgroundColor3 = Theme.Surface,
            FontFace = CustomFontMedium,
            Text = "Discord",
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            TextTransparency = 1,
        }, socialRow)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 6) }, discordBtn)
        local discordStroke = CreateInstance("UIStroke", {
            Color = Theme.Border,
            Thickness = 1,
            Transparency = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, discordBtn)

        local websiteBtn = CreateInstance("TextButton", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.new(0, halfW, 1, 0),
            BackgroundColor3 = Theme.Surface,
            FontFace = CustomFontMedium,
            Text = "Website",
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            TextTransparency = 1,
        }, socialRow)
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 6) }, websiteBtn)
        local websiteStroke = CreateInstance("UIStroke", {
            Color = Theme.Border,
            Thickness = 1,
            Transparency = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, websiteBtn)

        -- FOOTER
        local footer = CreateInstance("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -10),
            Size = UDim2.new(1, -32, 0, 20),
            BackgroundTransparency = 1,
            FontFace = CustomFontMedium,
            Text = Config.Version .. "  •  No Key Required  •  " .. SupportedGameCount .. " Games",
            TextColor3 = Theme.TextSecondary,
            TextSize = 11,
            TextTransparency = 1,
        }, panel)

        -- DRAGGING
        local dragging = false
        local dragStart, startPos

        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = panel.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            ) then
                local delta = input.Position - dragStart
                QuickTween(panel, {
                    Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                }, 0.12, Enum.EasingStyle.Quart)
            end
        end)

        -- ANIMATABLE ELEMENTS
        local allElements = {
            { obj = headerTitle,   prop = "TextTransparency", target = 0 },
            { obj = closeBtn,     prop = "TextTransparency", target = 0 },
            { obj = closeBtn,     prop = "BackgroundTransparency", target = 0.5 },
            { obj = minBtn,       prop = "TextTransparency", target = 0 },
            { obj = minBtn,       prop = "BackgroundTransparency", target = 0.5 },
            { obj = separator,    prop = "BackgroundTransparency", target = 0 },
            { obj = infoCard,     prop = "BackgroundTransparency", target = 0 },
            { obj = gameNameLabel, prop = "TextTransparency", target = 0 },
            { obj = detailLabel,  prop = "TextTransparency", target = 0 },
            { obj = statusLabel,  prop = "TextTransparency", target = 0 },
            { obj = execBtn,      prop = "BackgroundTransparency", target = 0 },
            { obj = execBtn,      prop = "TextTransparency", target = 0 },
            { obj = discordBtn,   prop = "BackgroundTransparency", target = 0 },
            { obj = discordBtn,   prop = "TextTransparency", target = 0 },
            { obj = websiteBtn,   prop = "BackgroundTransparency", target = 0 },
            { obj = websiteBtn,   prop = "TextTransparency", target = 0 },
            { obj = footer,       prop = "TextTransparency", target = 0 },
        }

        local allStrokes = { panelStroke, infoStroke, execStroke, discordStroke, websiteStroke }

        -- OPEN ANIMATION
        local function AnimateOpen()
            QuickTween(overlay, { BackgroundTransparency = 0.4 }, 0.4)
            pcall(function()
                if BlurEffect then QuickTween(BlurEffect, { Size = 20 }, 0.4) end
            end)

            QuickTween(panel, {
                Size = UDim2.new(0, panelW, 0, panelH)
            }, 0.5, Enum.EasingStyle.Back)

            task.wait(0.2)

            for _, s in ipairs(allStrokes) do
                QuickTween(s, { Transparency = 0 }, 0.4)
            end

            for i, elem in ipairs(allElements) do
                task.delay(i * 0.02, function()
                    if elem.obj and elem.obj.Parent then
                        QuickTween(elem.obj, { [elem.prop] = elem.target }, 0.4, Enum.EasingStyle.Exponential)
                    end
                end)
            end
        end

        -- CLOSE ANIMATION
        local function AnimateClose()
            for _, elem in ipairs(allElements) do
                if elem.obj and elem.obj.Parent then
                    QuickTween(elem.obj, { [elem.prop] = 1 }, 0.25)
                end
            end
            for _, s in ipairs(allStrokes) do
                QuickTween(s, { Transparency = 1 }, 0.25)
            end

            task.wait(0.15)
            QuickTween(panel, { Size = UDim2.new(0, 0, 0, 0) }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            QuickTween(overlay, { BackgroundTransparency = 1 }, 0.3)
            pcall(function()
                if BlurEffect then QuickTween(BlurEffect, { Size = 0 }, 0.3) end
            end)

            task.wait(0.4)
            pcall(function()
                if BlurEffect and BlurEffect.Parent then BlurEffect:Destroy(); BlurEffect = nil end
            end)
            if HubGui and HubGui.Parent then HubGui:Destroy(); HubGui = nil end
            HubOpen = false
        end

        -- MINIMIZE ANIMATION
        local function AnimateMinimize()
            Minimized = true

            for _, elem in ipairs(allElements) do
                if elem.obj and elem.obj.Parent then
                    QuickTween(elem.obj, { [elem.prop] = 1 }, 0.2)
                end
            end
            for _, s in ipairs(allStrokes) do
                QuickTween(s, { Transparency = 1 }, 0.2)
            end

            task.wait(0.1)
            QuickTween(panel, { Size = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            QuickTween(overlay, { BackgroundTransparency = 1 }, 0.25)
            pcall(function()
                if BlurEffect then QuickTween(BlurEffect, { Size = 0 }, 0.25) end
            end)

            task.wait(0.35)
            if HubGui and HubGui.Parent then HubGui:Destroy(); HubGui = nil end
            HubOpen = false

            CreateToggleButton()
        end

        -- HOVER HELPER
        local function AddHover(btn, normalSize)
            local hoverSize = UDim2.new(
                normalSize.X.Scale, normalSize.X.Offset + 6,
                normalSize.Y.Scale, normalSize.Y.Offset + 3
            )
            btn.MouseEnter:Connect(function()
                if btn and btn.Parent then QuickTween(btn, { Size = hoverSize }, 0.15) end
            end)
            btn.MouseLeave:Connect(function()
                if btn and btn.Parent then QuickTween(btn, { Size = normalSize }, 0.15) end
            end)
        end

        -- BUTTON EVENTS

        -- Close
        closeBtn.MouseButton1Click:Connect(AnimateClose)
        closeBtn.MouseEnter:Connect(function()
            QuickTween(closeBtn, { BackgroundTransparency = 0.2, TextColor3 = Theme.Error }, 0.15)
        end)
        closeBtn.MouseLeave:Connect(function()
            QuickTween(closeBtn, { BackgroundTransparency = 0.5, TextColor3 = Theme.TextSecondary }, 0.15)
        end)

        -- Minimize
        minBtn.MouseButton1Click:Connect(AnimateMinimize)
        minBtn.MouseEnter:Connect(function()
            QuickTween(minBtn, { BackgroundTransparency = 0.2, TextColor3 = Theme.Warning }, 0.15)
        end)
        minBtn.MouseLeave:Connect(function()
            QuickTween(minBtn, { BackgroundTransparency = 0.5, TextColor3 = Theme.TextSecondary }, 0.15)
        end)

        -- Execute
        AddHover(execBtn, UDim2.new(0, panelW - 32, 0, 46))

        execBtn.MouseButton1Click:Connect(function()
            if ScriptLoaded then
                Notify("Info", "Script already loaded!", 3, Theme.Accent)
                return
            end
            if not CurrentGame then
                Notify("Error", "This game is not supported.", 4, Theme.Error)
                return
            end

            execBtn.Text = "Loading..."
            QuickTween(execBtn, { BackgroundColor3 = Theme.SurfaceLight }, 0.2)
            if statusLabel and statusLabel.Parent then
                statusLabel.Text = "Status: Loading script..."
                QuickTween(statusLabel, { TextColor3 = Theme.Warning }, 0.2)
            end

            task.spawn(function()
                local success = LoadGameScript()
                if success then
                    if execBtn and execBtn.Parent then
                        execBtn.Text = "Loaded ✓"
                        QuickTween(execBtn, { BackgroundColor3 = Theme.Success }, 0.3)
                    end
                    if statusLabel and statusLabel.Parent then
                        statusLabel.Text = "Status: Script loaded successfully"
                        QuickTween(statusLabel, { TextColor3 = Theme.Success }, 0.3)
                    end
                    Notify("Success", CurrentGame.Name .. " script loaded!", 4, Theme.Success)
                else
                    if execBtn and execBtn.Parent then
                        execBtn.Text = "Execute Script"
                        QuickTween(execBtn, { BackgroundColor3 = Theme.Accent }, 0.3)
                    end
                    if statusLabel and statusLabel.Parent then
                        statusLabel.Text = "Status: Load failed — retry"
                        QuickTween(statusLabel, { TextColor3 = Theme.Error }, 0.3)
                    end
                end
            end)
        end)

        -- Discord
        AddHover(discordBtn, UDim2.new(0, halfW, 1, 0))
        discordBtn.MouseButton1Click:Connect(function()
            pcall(setclipboard, Config.Discord)
            Notify("Copied", "Discord invite copied to clipboard.", 3, Theme.Accent)
        end)
        discordBtn.MouseEnter:Connect(function()
            QuickTween(discordBtn, { BackgroundColor3 = Theme.SurfaceLight }, 0.15)
        end)
        discordBtn.MouseLeave:Connect(function()
            QuickTween(discordBtn, { BackgroundColor3 = Theme.Surface }, 0.15)
        end)

        -- Website
        AddHover(websiteBtn, UDim2.new(0, halfW, 1, 0))
        websiteBtn.MouseButton1Click:Connect(function()
            pcall(setclipboard, Config.Website)
            Notify("Copied", "Website link copied to clipboard.", 3, Theme.Accent)
        end)
        websiteBtn.MouseEnter:Connect(function()
            QuickTween(websiteBtn, { BackgroundColor3 = Theme.SurfaceLight }, 0.15)
        end)
        websiteBtn.MouseLeave:Connect(function()
            QuickTween(websiteBtn, { BackgroundColor3 = Theme.Surface }, 0.15)
        end)

        -- PLAY OPEN
        AnimateOpen()

        -- AUTO EXECUTE
        if Config.AutoExecute and CurrentGame and not ScriptLoaded then
            task.delay(1.5, function()
                if not ScriptLoaded and execBtn and execBtn.Parent then
                    execBtn.Text = "Loading..."
                    QuickTween(execBtn, { BackgroundColor3 = Theme.SurfaceLight }, 0.2)
                    if statusLabel and statusLabel.Parent then
                        statusLabel.Text = "Status: Auto-executing..."
                        QuickTween(statusLabel, { TextColor3 = Theme.Warning }, 0.2)
                    end

                    task.spawn(function()
                        local success = LoadGameScript()
                        if success then
                            if execBtn and execBtn.Parent then
                                execBtn.Text = "Loaded ✓"
                                QuickTween(execBtn, { BackgroundColor3 = Theme.Success }, 0.3)
                            end
                            if statusLabel and statusLabel.Parent then
                                statusLabel.Text = "Status: Script loaded successfully"
                                QuickTween(statusLabel, { TextColor3 = Theme.Success }, 0.3)
                            end
                            Notify("Auto-Execute", CurrentGame.Name .. " loaded!", 4, Theme.Success)
                        else
                            if execBtn and execBtn.Parent then
                                execBtn.Text = "Execute Script"
                                QuickTween(execBtn, { BackgroundColor3 = Theme.Accent }, 0.3)
                            end
                            if statusLabel and statusLabel.Parent then
                                statusLabel.Text = "Status: Auto-execute failed"
                                QuickTween(statusLabel, { TextColor3 = Theme.Error }, 0.3)
                            end
                        end
                    end)
                end
            end)
        end
    end

    -------------------------------------------------------------------
    -- KEYBOARD SHORTCUTS
    -------------------------------------------------------------------
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.F9 then
            if Minimized then
                if ToggleGui and ToggleGui.Parent then
                    QuickTween(ToggleButton, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.2)
                    task.wait(0.25)
                    if ToggleGui and ToggleGui.Parent then ToggleGui:Destroy(); ToggleGui = nil end
                end
                Minimized = false
                CreateHub()
            elseif HubOpen then
                if HubGui and HubGui.Parent then HubGui:Destroy(); HubGui = nil end
                pcall(function()
                    if BlurEffect and BlurEffect.Parent then BlurEffect.Size = 0 end
                end)
                HubOpen = false
                Minimized = true
                CreateToggleButton()
            else
                CreateHub()
            end
        end
    end)

    -------------------------------------------------------------------
    -- LAUNCH
    -------------------------------------------------------------------
    CreateSplash(function()
        CreateHub()

        if not CurrentGame then
            Notify("Unsupported", "This game is not in the supported list.", 5, Theme.Warning)
        else
            Notify("Welcome", "Playing " .. CurrentGame.Name, 4, Theme.Accent)
        end
    end)
end

Main()
