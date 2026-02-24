-- Solix Hub v4.1.0 | Production Loader | Keyless | Xeno Compatible
repeat task.wait() until game:IsLoaded()

---------------------------------------------------------------------------
-- S1: Shims
---------------------------------------------------------------------------
if not cloneref       then cloneref       = function(o) return o end                     end
if not isfile         then isfile         = function()  return false end                 end
if not readfile       then readfile       = function()  return ""    end                 end
if not writefile      then writefile      = function()  end                              end
if not makefolder     then makefolder     = function()  end                              end
if not isfolder       then isfolder       = function()  return false end                 end
if not setclipboard   then setclipboard   = function()  end                              end
if not delfile        then delfile        = function()  end                              end
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
-- S2: Services
---------------------------------------------------------------------------
local CoreGui          = cloneref(game:GetService("CoreGui"))
local HttpService      = cloneref(game:GetService("HttpService"))
local Lighting         = cloneref(game:GetService("Lighting"))
local Players          = cloneref(game:GetService("Players"))
local TweenService     = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TextService      = cloneref(game:GetService("TextService"))
local RunService       = cloneref(game:GetService("RunService"))
local Player           = Players.LocalPlayer

---------------------------------------------------------------------------
-- S3: GUI Parent
---------------------------------------------------------------------------
local GuiParent
pcall(function() if gethui then GuiParent = gethui() end end)
if not GuiParent then GuiParent = CoreGui end

---------------------------------------------------------------------------
-- S4: Cleanup
---------------------------------------------------------------------------
for _, name in ipairs({"SolixHub","SolixNotifications","SolixToggle","SolixSplash"}) do
    pcall(function() local o = GuiParent:FindFirstChild(name) if o then o:Destroy() end end)
end
pcall(function() local o = Lighting:FindFirstChild("SolixBlur") if o then o:Destroy() end end)

---------------------------------------------------------------------------
-- S5: Config & Theme
---------------------------------------------------------------------------
local Config = {
    Name         = "Solix Hub",
    Version      = "v4.1.0",
    Discord      = "https://discord.gg/solixhub",
    Website      = "https://solixhub.com/",
    AutoExecute  = false,
    SettingsFile = "solixhub/settings.json",
}

local Theme = {
    Background    = Color3.fromRGB(16, 14, 20),
    Surface       = Color3.fromRGB(24, 21, 30),
    SurfaceLight  = Color3.fromRGB(38, 34, 46),
    SurfaceHover  = Color3.fromRGB(48, 44, 56),
    Accent        = Color3.fromRGB(105, 135, 255),
    AccentLight   = Color3.fromRGB(140, 165, 255),
    AccentDark    = Color3.fromRGB(80, 100, 220),
    Text          = Color3.fromRGB(240, 240, 248),
    TextSecondary = Color3.fromRGB(148, 148, 168),
    TextTertiary  = Color3.fromRGB(100, 100, 120),
    Border        = Color3.fromRGB(52, 48, 62),
    BorderLight   = Color3.fromRGB(65, 60, 78),
    Success       = Color3.fromRGB(65, 210, 95),
    Error         = Color3.fromRGB(235, 60, 60),
    Warning       = Color3.fromRGB(240, 185, 45),
    Info          = Color3.fromRGB(80, 170, 255),
    Shadow        = Color3.fromRGB(0, 0, 0),
    Ripple        = Color3.fromRGB(255, 255, 255),
}

---------------------------------------------------------------------------
-- S6: Game Registry
---------------------------------------------------------------------------
local GameRegistry = {
    ["3808223175"] = { Name = "Jujutsu Infinite",              LuarmorId = "4fe2dfc202115670b1813277df916ab2" },
    ["994732206"]  = { Name = "Blox Fruits",                   LuarmorId = "e2718ddebf562c5c4080dfce26b09398" },
    ["1650291138"] = { Name = "Demon Fall",                    LuarmorId = "9b64d07193c7c2aef970d57aeb286e70" },
    ["1511883870"] = { Name = "Shindo Life",                   LuarmorId = "fefdf5088c44beb34ef52ed6b520507c" },
    ["6035872082"] = { Name = "Rivals",                        LuarmorId = "3bb7969a9ecb9e317b0a24681327c2e2" },
    ["245662005"]  = { Name = "Jailbreak",                     LuarmorId = "21ad7f491e4658e9dc9529a60c887c6e" },
    ["7018190066"] = { Name = "Dead Rails",                    LuarmorId = "98f5c64a0a9ecca29517078597bbcbdb" },
    ["7074860883"] = { Name = "Arise Crossover",               LuarmorId = "0c8fdf9bb25a6a7071731b72a90e3c69" },
    ["7436755782"] = { Name = "Grow a Garden",                 LuarmorId = "e4ea33e9eaf0ae943d59ea98f2444ebe" },
    ["7326934954"] = { Name = "99 Nights in the Forest",       LuarmorId = "00e140acb477c5ecde501c1d448df6f9" },
    ["7671049560"] = { Name = "The Forge",                     LuarmorId = "c0b41e859f576fb70183206224d4a75f" },
    ["6760085372"] = { Name = "Jujutsu: Zero",                 LuarmorId = "e380382a05647eabda3a9892f95952c6" },
    ["9266873836"] = { Name = "Anime Fighting Simulator",      LuarmorId = "3f9d315017ec895ded5c3350fd6e45a0" },
    ["3317771874"] = { Name = "Pet Simulator 99",              LuarmorId = "e95ef6f27596e636a7d706375c040de4" },
    ["9363735110"] = { Name = "Escape Tsunami For Brainrots!", LuarmorId = "4948419832e0bd4aa588e628c45b6f8d" },
    ["8144728961"] = { Name = "Abyss 67",                      LuarmorId = "50721a1cda76bf61b31ae6e7284a5ea3" },
    ["9509842868"] = { Name = "Gaarden Horizon",               LuarmorId = "cda910bd16c73785463fbe982d64994d" },
}

local CurrentGameId = tostring(game.GameId)
local CurrentGame   = GameRegistry[CurrentGameId]

local ExecutorName = "Unknown"
pcall(function()
    ExecutorName = (getexecutorname() or "Unknown"):match("^%s*(.-)%s*$") or "Unknown"
end)

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local SupportedGameCount = 0
for _ in pairs(GameRegistry) do SupportedGameCount = SupportedGameCount + 1 end

---------------------------------------------------------------------------
-- S7: State Machine
---------------------------------------------------------------------------
local State = { IDLE="IDLE", SPLASH="SPLASH", OPENING="OPENING", HUB_OPEN="HUB_OPEN", CLOSING="CLOSING", MINIMIZED="MINIMIZED" }
local CurrentState  = State.IDLE
local ScriptLoaded  = false
local ExecutingLock = false

---------------------------------------------------------------------------
-- S8: Utilities
---------------------------------------------------------------------------

-- Connection manager
local function CreateConnectionManager()
    local mgr = { _conns = {} }
    function mgr:Connect(signal, callback)
        local conn = signal:Connect(callback)
        self._conns[#self._conns + 1] = conn
        return conn
    end
    function mgr:Add(conn)
        self._conns[#self._conns + 1] = conn
        return conn
    end
    function mgr:DisconnectAll()
        for i = #self._conns, 1, -1 do
            pcall(function() self._conns[i]:Disconnect() end)
            self._conns[i] = nil
        end
    end
    return mgr
end

local GlobalConns = CreateConnectionManager()

local function IsAlive(obj)
    if not obj then return false end
    local ok, _ = pcall(function() local _ = obj.Parent end)
    return ok
end

local function QuickTween(obj, props, duration, style, direction)
    if not IsAlive(obj) then return nil end
    local tween = TweenService:Create(obj,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        props)
    tween:Play()
    return tween
end

local function Create(class, props, parent)
    local inst = Instance.new(class)
    if props then for k,v in pairs(props) do pcall(function() inst[k] = v end) end end
    if parent then inst.Parent = parent end
    return inst
end

local function Debounce(fn, cd)
    cd = cd or 0.5
    local last = 0
    return function(...)
        local now = tick()
        if now - last < cd then return end
        last = now
        return fn(...)
    end
end

local function Clamp(val, lo, hi)
    if val < lo then return lo end
    if val > hi then return hi end
    return val
end

local function CreateRipple(button, inputPos)
    if not IsAlive(button) then return end
    local aP, aS = button.AbsolutePosition, button.AbsoluteSize
    local rx = inputPos and (inputPos.X - aP.X) or (aS.X / 2)
    local ry = inputPos and (inputPos.Y - aP.Y) or (aS.Y / 2)
    local maxD = math.max(aS.X, aS.Y) * 2.5
    local r = Create("Frame", {
        AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0,rx,0,ry),
        Size = UDim2.new(0,0,0,0), BackgroundColor3 = Theme.Ripple,
        BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 999,
    }, button)
    Create("UICorner", { CornerRadius = UDim.new(1,0) }, r)
    QuickTween(r, { Size = UDim2.new(0,maxD,0,maxD), BackgroundTransparency = 1 }, 0.55, Enum.EasingStyle.Exponential)
    task.delay(0.6, function() if IsAlive(r) then r:Destroy() end end)
end

local function MakeDraggable(handle, target, connMgr, onDrag)
    local dragging, dragStart, startPos = false, Vector2.zero, UDim2.new()
    connMgr:Connect(handle.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = target.Position
        end
    end)
    connMgr:Connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = input.Position - dragStart
        target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        if onDrag then onDrag(d) end
    end)
    connMgr:Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    return function() return dragging end
end

local function AnimateLoadingText(label, baseText)
    local alive = true
    task.spawn(function()
        local dots = 0
        while alive and IsAlive(label) do
            dots = (dots % 3) + 1
            label.Text = baseText .. string.rep(".", dots)
            task.wait(0.35)
        end
    end)
    return function() alive = false end
end

-- Folders
local function SetupFolders()
    if not isfolder("solixhub")        then pcall(makefolder, "solixhub")        end
    if not isfolder("solixhub/Assets") then pcall(makefolder, "solixhub/Assets") end
end
SetupFolders()

-- Settings
local Settings = {}
local function LoadSettings()
    pcall(function()
        if isfile(Config.SettingsFile) then
            local data = HttpService:JSONDecode(readfile(Config.SettingsFile))
            if type(data) ~= "table" then return end
            if type(data.LastPosX) == "number" and type(data.LastPosY) == "number" then
                local cam = workspace.CurrentCamera
                local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
                if data.LastPosX >= 0 and data.LastPosX <= vp.X - 100
                and data.LastPosY >= 0 and data.LastPosY <= vp.Y - 100 then
                    Settings.LastPosX = data.LastPosX
                    Settings.LastPosY = data.LastPosY
                end
            end
        end
    end)
end
local function SaveSettings()
    pcall(function() writefile(Config.SettingsFile, HttpService:JSONEncode(Settings)) end)
end
LoadSettings()

---------------------------------------------------------------------------
-- S9: Fonts
---------------------------------------------------------------------------
local FontBold, FontMedium

pcall(function()
    local fontPath = "solixhub/Assets/InterSemiBold.ttf"
    if not isfile(fontPath) then
        local data = game:HttpGet("https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf")
        if data and #data > 0 then writefile(fontPath, data) end
    end
    if isfile(fontPath) then
        local fontData = {
            name = "InterSemiBold",
            faces = {{ name = "InterSemiBold", weight = 400, style = "Regular", assetId = getcustomasset(fontPath) }},
        }
        writefile("solixhub/Assets/InterSemiBold.font", HttpService:JSONEncode(fontData))
        FontBold = Font.new(getcustomasset("solixhub/Assets/InterSemiBold.font"))
    end
end)

if not FontBold then
    pcall(function() FontBold = Font.fromEnum(Enum.Font.GothamBold) end)
    if not FontBold then FontBold = Font.fromEnum(Enum.Font.SourceSansBold) end
end
pcall(function() FontMedium = Font.fromEnum(Enum.Font.GothamMedium) end)
if not FontMedium then FontMedium = FontBold end

---------------------------------------------------------------------------
-- S10: Main
---------------------------------------------------------------------------
local function Main()
    local BlurEffect, SplashGui, HubGui, NotifGui, ToggleGui, ToggleButton
    local hubConns    = CreateConnectionManager()
    local toggleConns = CreateConnectionManager()
    local splashConns = CreateConnectionManager()

    -- 10a: Notifications
    NotifGui = Create("ScreenGui", {
        Name = "SolixNotifications", DisplayOrder = 1100, ResetOnSpawn = false, IgnoreGuiInset = true,
    }, GuiParent)

    local NotifContainer = Create("Frame", {
        AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-16,0,16),
        Size = UDim2.new(0,310,1,-32), BackgroundTransparency = 1,
    }, NotifGui)
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,8),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    }, NotifContainer)

    local NotifIcons = {}
    NotifIcons[Theme.Success] = "[OK]"
    NotifIcons[Theme.Error]   = "[X]"
    NotifIcons[Theme.Warning] = "[!]"

    local function Notify(title, desc, duration, color)
        if not IsAlive(NotifContainer) then return end
        duration = duration or 4
        color = color or Theme.Accent
        local icon = NotifIcons[color] or "[i]"
        local maxW = 290
        local titleTxt = icon .. " " .. title
        local titleSz = TextService:GetTextSize(titleTxt, 14, Enum.Font.GothamBold, Vector2.new(maxW-36, 1000))
        local descSz  = TextService:GetTextSize(desc, 12, Enum.Font.GothamMedium, Vector2.new(maxW-36, 1000))
        local frameW  = Clamp(math.max(titleSz.X, descSz.X) + 42, 180, maxW)
        local frameH  = titleSz.Y + descSz.Y + 42

        local frame = Create("Frame", {
            Size = UDim2.new(0,frameW,0,0), Position = UDim2.new(0,40,0,0),
            BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, ClipsDescendants = true,
        }, NotifContainer)
        Create("UICorner", { CornerRadius = UDim.new(0,10) }, frame)
        Create("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, frame)

        local accentBar = Create("Frame", { Size = UDim2.new(0,3,1,0), BackgroundColor3 = color, BorderSizePixel = 0 }, frame)
        Create("UICorner", { CornerRadius = UDim.new(0,3) }, accentBar)

        local titleLabel = Create("TextLabel", {
            Position = UDim2.new(0,14,0,10), Size = UDim2.new(1,-22,0,titleSz.Y),
            BackgroundTransparency = 1, FontFace = FontBold, Text = titleTxt,
            TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1,
        }, frame)
        local descLabel = Create("TextLabel", {
            Position = UDim2.new(0,14,0,10+titleSz.Y+4), Size = UDim2.new(1,-22,0,descSz.Y),
            BackgroundTransparency = 1, FontFace = FontMedium, Text = desc,
            TextColor3 = Theme.TextSecondary, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true, TextTransparency = 1,
        }, frame)

        local timerBg = Create("Frame", {
            AnchorPoint = Vector2.new(0.5,1), Position = UDim2.new(0.5,0,1,-7),
            Size = UDim2.new(1,-18,0,3), BackgroundColor3 = Theme.SurfaceLight,
            BorderSizePixel = 0, BackgroundTransparency = 1,
        }, frame)
        Create("UICorner", { CornerRadius = UDim.new(0,2) }, timerBg)
        local timerFill = Create("Frame", {
            Size = UDim2.new(1,0,1,0), BackgroundColor3 = color,
            BorderSizePixel = 0, BackgroundTransparency = 1,
        }, timerBg)
        Create("UICorner", { CornerRadius = UDim.new(0,2) }, timerFill)

        QuickTween(frame, { Size = UDim2.new(0,frameW,0,frameH) }, 0.4, Enum.EasingStyle.Exponential)
        QuickTween(frame, { Position = UDim2.new(0,0,0,0) }, 0.4, Enum.EasingStyle.Exponential)
        task.defer(function()
            task.wait(0.08)
            QuickTween(titleLabel, { TextTransparency = 0 }, 0.3)
            QuickTween(descLabel,  { TextTransparency = 0 }, 0.3)
            task.wait(0.05)
            QuickTween(timerBg,   { BackgroundTransparency = 0 }, 0.25)
            QuickTween(timerFill, { BackgroundTransparency = 0 }, 0.25)
            QuickTween(timerFill, { Size = UDim2.new(0,0,1,0) }, duration, Enum.EasingStyle.Linear)
        end)
        task.delay(duration, function()
            if not IsAlive(frame) then return end
            QuickTween(titleLabel, { TextTransparency = 1 }, 0.25)
            QuickTween(descLabel,  { TextTransparency = 1 }, 0.25)
            QuickTween(timerBg,    { BackgroundTransparency = 1 }, 0.25)
            QuickTween(timerFill,  { BackgroundTransparency = 1 }, 0.25)
            QuickTween(frame, { Size = UDim2.new(0,frameW,0,0), BackgroundTransparency = 1, Position = UDim2.new(0,40,0,0) }, 0.4, Enum.EasingStyle.Exponential)
            task.wait(0.45)
            if IsAlive(frame) then frame:Destroy() end
        end)
    end

    -- 10b: Script Loading
    local function LoadGameScript()
        if ScriptLoaded then return true end
        if not CurrentGame then return false end
        if CurrentGame.ScriptURL and CurrentGame.ScriptURL ~= "" then
            local ok, err = pcall(function()
                local code = game:HttpGet(CurrentGame.ScriptURL)
                assert(code and #code > 0, "Empty response")
                local fn = loadstring(code)
                assert(fn, "Compile failed")
                fn()
            end)
            if ok then ScriptLoaded = true; return true end
            Notify("Warning", "Direct URL failed, trying Luarmor...", 3, Theme.Warning)
        end
        if CurrentGame.LuarmorId and CurrentGame.LuarmorId ~= "" then
            local ok, err = pcall(function()
                local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
                api.script_id = CurrentGame.LuarmorId
                api.load_script()
            end)
            if ok then ScriptLoaded = true; return true end
            Notify("Load Error", "Failed: " .. tostring(err), 6, Theme.Error)
            return false
        end
        Notify("Error", "No loading method configured.", 5, Theme.Error)
        return false
    end

    -- 10c: Blur
    local function ShowBlur(size, dur)
        pcall(function()
            if not BlurEffect or not BlurEffect.Parent then
                BlurEffect = Create("BlurEffect", { Name = "SolixBlur", Size = 0 }, Lighting)
            end
            QuickTween(BlurEffect, { Size = size or 22 }, dur or 0.4)
        end)
    end
    local function HideBlur(dur)
        pcall(function()
            if not BlurEffect or not BlurEffect.Parent then return end
            local t = QuickTween(BlurEffect, { Size = 0 }, dur or 0.3)
            if t then t.Completed:Once(function()
                if BlurEffect and BlurEffect.Parent then BlurEffect:Destroy(); BlurEffect = nil end
            end) end
        end)
    end

    -- 10d: Splash
    local function CreateSplash(onComplete)
        CurrentState = State.SPLASH
        SplashGui = Create("ScreenGui", {
            Name = "SolixSplash", DisplayOrder = 1050, ResetOnSpawn = false, IgnoreGuiInset = true,
        }, GuiParent)
        ShowBlur(24, 0.6)

        local backdrop = Create("Frame", {
            Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(6,5,9),
            BackgroundTransparency = 1, BorderSizePixel = 0,
        }, SplashGui)
        local center = Create("Frame", {
            AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5,0,0.5,0),
            Size = UDim2.new(0,420,0,200), BackgroundTransparency = 1,
        }, backdrop)

        local glow = Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5,0,0.3,0),
            Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1,
            Image = "rbxassetid://7669129898", ImageColor3 = Theme.Accent, ImageTransparency = 1,
        }, center)
        local title = Create("TextLabel", {
            AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,10),
            Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1,
            FontFace = FontBold, Text = Config.Name, TextColor3 = Theme.Text,
            TextSize = 42, TextTransparency = 1,
        }, center)
        local titleGrad = Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.Accent),
                ColorSequenceKeypoint.new(0.5, Theme.AccentLight),
                ColorSequenceKeypoint.new(1, Theme.Accent),
            }),
        }, title)
        local subtitle = Create("TextLabel", {
            AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,62),
            Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1,
            FontFace = FontMedium, Text = Config.Version .. "  |  Premium Game Hub",
            TextColor3 = Theme.TextSecondary, TextSize = 14, TextTransparency = 1,
        }, center)
        local barBg = Create("Frame", {
            AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,102),
            Size = UDim2.new(0,280,0,4), BackgroundColor3 = Theme.SurfaceLight,
            BorderSizePixel = 0, BackgroundTransparency = 1,
        }, center)
        Create("UICorner", { CornerRadius = UDim.new(0,3) }, barBg)
        local barFill = Create("Frame", {
            Size = UDim2.new(0,0,1,0), BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0, BackgroundTransparency = 1,
        }, barBg)
        Create("UICorner", { CornerRadius = UDim.new(0,3) }, barFill)
        Create("UIGradient", {
            Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Theme.AccentDark), ColorSequenceKeypoint.new(0.5, Theme.AccentLight), ColorSequenceKeypoint.new(1, Theme.Accent) }),
        }, barFill)
        local status = Create("TextLabel", {
            AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,118),
            Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1,
            FontFace = FontMedium, Text = "Initializing...", TextColor3 = Theme.TextTertiary,
            TextSize = 12, TextTransparency = 1,
        }, center)

        task.spawn(function()
            QuickTween(backdrop, { BackgroundTransparency = 0 }, 0.6)
            task.wait(0.25)
            QuickTween(glow, { Size = UDim2.new(0,300,0,300), ImageTransparency = 0.65 }, 0.8, Enum.EasingStyle.Exponential)
            local titleScale = Create("UIScale", { Scale = 0.7 }, title)
            QuickTween(title, { TextTransparency = 0 }, 0.6, Enum.EasingStyle.Exponential)
            QuickTween(titleScale, { Scale = 1 }, 0.7, Enum.EasingStyle.Back)
            task.wait(0.2)
            task.spawn(function()
                while IsAlive(titleGrad) and CurrentState == State.SPLASH do
                    QuickTween(titleGrad, { Offset = Vector2.new(0.3, 0) }, 1.5, Enum.EasingStyle.Sine)
                    task.wait(1.5)
                    if not IsAlive(titleGrad) then break end
                    QuickTween(titleGrad, { Offset = Vector2.new(-0.3, 0) }, 1.5, Enum.EasingStyle.Sine)
                    task.wait(1.5)
                end
            end)
            QuickTween(subtitle, { TextTransparency = 0 }, 0.5)
            task.wait(0.25)
            QuickTween(barBg, { BackgroundTransparency = 0 }, 0.3)
            QuickTween(barFill, { BackgroundTransparency = 0 }, 0.3)
            QuickTween(status, { TextTransparency = 0 }, 0.3)
            task.wait(0.2)

            local stages = {
                { pct = 0.20, text = "Detecting executor..." },
                { pct = 0.40, text = "Executor: " .. ExecutorName },
                { pct = 0.60, text = "Scanning game registry..." },
                { pct = 0.80, text = CurrentGame and ("Found: " .. CurrentGame.Name) or "Game not in registry" },
                { pct = 1.00, text = "Ready" },
            }
            for _, s in ipairs(stages) do
                if IsAlive(status) then status.Text = s.text end
                QuickTween(barFill, { Size = UDim2.new(s.pct, 0, 1, 0) }, 0.45, Enum.EasingStyle.Quad)
                task.wait(0.55)
            end
            task.wait(0.4)

            QuickTween(title, { TextTransparency = 1 }, 0.35)
            QuickTween(subtitle, { TextTransparency = 1 }, 0.35)
            QuickTween(barBg, { BackgroundTransparency = 1 }, 0.35)
            QuickTween(barFill, { BackgroundTransparency = 1 }, 0.35)
            QuickTween(status, { TextTransparency = 1 }, 0.35)
            QuickTween(glow, { ImageTransparency = 1, Size = UDim2.new(0,400,0,400) }, 0.5)
            QuickTween(backdrop, { BackgroundTransparency = 1 }, 0.5)
            HideBlur(0.4)
            task.wait(0.55)
            splashConns:DisconnectAll()
            if IsAlive(SplashGui) then SplashGui:Destroy() end
            SplashGui = nil
            if onComplete then onComplete() end
        end)
    end

    -- 10e: Toggle Button
    local CreateHub

    local function CreateToggleButton()
        if IsAlive(ToggleGui) then return end
        toggleConns:DisconnectAll()
        CurrentState = State.MINIMIZED

        ToggleGui = Create("ScreenGui", {
            Name = "SolixToggle", DisplayOrder = 1001, ResetOnSpawn = false, IgnoreGuiInset = true,
        }, GuiParent)

        local togglePos = IsMobile and UDim2.new(0,14,1,-62) or UDim2.new(0,14,0.5,0)
        ToggleButton = Create("TextButton", {
            AnchorPoint = IsMobile and Vector2.new(0,1) or Vector2.new(0,0.5),
            Position = togglePos, Size = UDim2.new(0,46,0,46),
            BackgroundColor3 = Theme.Accent, FontFace = FontBold, Text = "S",
            TextColor3 = Theme.Text, TextSize = 20, BorderSizePixel = 0,
            AutoButtonColor = false, BackgroundTransparency = 1, TextTransparency = 1,
            ClipsDescendants = true,
        }, ToggleGui)
        Create("UICorner", { CornerRadius = UDim.new(0,12) }, ToggleButton)
        Create("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, ToggleButton)
        Create("UIGradient", { Color = ColorSequence.new(Theme.Accent, Theme.AccentDark), Rotation = 135 }, ToggleButton)
        QuickTween(ToggleButton, { BackgroundTransparency = 0, TextTransparency = 0 }, 0.35)

        task.spawn(function()
            while IsAlive(ToggleButton) and CurrentState == State.MINIMIZED do
                QuickTween(ToggleButton, { BackgroundTransparency = 0.15 }, 1.5, Enum.EasingStyle.Sine)
                task.wait(1.5)
                if not IsAlive(ToggleButton) or CurrentState ~= State.MINIMIZED then break end
                QuickTween(ToggleButton, { BackgroundTransparency = 0 }, 1.5, Enum.EasingStyle.Sine)
                task.wait(1.5)
            end
        end)

        MakeDraggable(ToggleButton, ToggleButton, toggleConns)
        local clickStart, clickStartPos = 0, Vector2.zero

        toggleConns:Connect(ToggleButton.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                clickStart = tick(); clickStartPos = input.Position
            end
        end)
        toggleConns:Connect(ToggleButton.InputEnded, function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local elapsed = tick() - clickStart
            local moved = (input.Position - clickStartPos).Magnitude
            if elapsed < 0.3 and moved < 6 then
                CreateRipple(ToggleButton, input.Position)
                QuickTween(ToggleButton, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.2)
                task.wait(0.25)
                toggleConns:DisconnectAll()
                if IsAlive(ToggleGui) then ToggleGui:Destroy(); ToggleGui = nil end
                CreateHub()
            end
        end)
        toggleConns:Connect(ToggleButton.MouseEnter, function()
            if IsAlive(ToggleButton) then QuickTween(ToggleButton, { BackgroundTransparency = 0 }, 0.15) end
        end)
    end

    -- 10f: Hub Panel
    CreateHub = function()
        if CurrentState == State.OPENING or CurrentState == State.CLOSING then return end
        CurrentState = State.OPENING
        hubConns:DisconnectAll()

        local panelW = IsMobile and 375 or 490
        local panelH = IsMobile and 350 or 330

        HubGui = Create("ScreenGui", {
            Name = "SolixHub", DisplayOrder = 1000, ResetOnSpawn = false, IgnoreGuiInset = true,
        }, GuiParent)

        local overlay = Create("TextButton", {
            Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0),
            BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 1,
        }, HubGui)

        ShowBlur(22, 0.4)

        local hasSavedPos = Settings.LastPosX and Settings.LastPosY
        local restoreAnchor = hasSavedPos and Vector2.new(0,0) or Vector2.new(0.5,0.5)
        local restorePos = hasSavedPos
            and UDim2.new(0, Settings.LastPosX, 0, Settings.LastPosY)
            or  UDim2.new(0.5, 0, 0.5, 0)

        local shadowFrame = Create("Frame", {
            Name = "Shadow", AnchorPoint = restoreAnchor,
            Position = UDim2.new(restorePos.X.Scale, restorePos.X.Offset, restorePos.Y.Scale, restorePos.Y.Offset + 5),
            Size = UDim2.new(0,0,0,0), BackgroundColor3 = Theme.Shadow,
            BackgroundTransparency = 0.6, BorderSizePixel = 0, ZIndex = 2,
        }, HubGui)
        Create("UICorner", { CornerRadius = UDim.new(0,16) }, shadowFrame)

        local panel = Create("Frame", {
            Name = "Panel", AnchorPoint = restoreAnchor, Position = restorePos,
            Size = UDim2.new(0,0,0,0), BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 3,
        }, HubGui)
        Create("UICorner", { CornerRadius = UDim.new(0,12) }, panel)

        local panelStroke = Create("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, panel)

        -- Top accent line
        local topAccent = Create("Frame", {
            Size = UDim2.new(1,0,0,2), BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 10,
        }, panel)
        Create("UIGradient", {
            Color = ColorSequence.new({ ColorSequenceKeypoint.new(0,Theme.AccentDark), ColorSequenceKeypoint.new(0.5,Theme.AccentLight), ColorSequenceKeypoint.new(1,Theme.AccentDark) }),
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,0.5), NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(1,0.5) }),
        }, topAccent)

        -- Header
        local header = Create("Frame", { Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, ZIndex = 5 }, panel)

        local headerTitle = Create("TextLabel", {
            Position = UDim2.new(0,18,0,0), Size = UDim2.new(0.6,0,1,0),
            BackgroundTransparency = 1, FontFace = FontBold, Text = Config.Name,
            TextColor3 = Theme.Accent, TextSize = 19, TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1, ZIndex = 5,
        }, header)
        local headerGrad = Create("UIGradient", {
            Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Theme.AccentLight) }),
        }, headerTitle)

        local nameWidth = TextService:GetTextSize(Config.Name, 19, Enum.Font.GothamBold, Vector2.new(300,50)).X
        local versionBadge = Create("TextLabel", {
            AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(0, 18+nameWidth+10, 0.5, 0),
            Size = UDim2.new(0,42,0,18), BackgroundColor3 = Theme.SurfaceLight,
            BackgroundTransparency = 1, FontFace = FontMedium, Text = Config.Version,
            TextColor3 = Theme.TextTertiary, TextSize = 10, BorderSizePixel = 0,
            ZIndex = 5, TextTransparency = 1,
        }, header)
        Create("UICorner", { CornerRadius = UDim.new(0,4) }, versionBadge)

        local closeBtn = Create("TextButton", {
            AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0),
            Size = UDim2.new(0,32,0,32), BackgroundColor3 = Theme.SurfaceLight,
            BackgroundTransparency = 1, FontFace = FontBold, Text = "x",
            TextColor3 = Theme.TextSecondary, TextSize = 18, BorderSizePixel = 0,
            AutoButtonColor = false, TextTransparency = 1, ClipsDescendants = true, ZIndex = 5,
        }, header)
        Create("UICorner", { CornerRadius = UDim.new(0,8) }, closeBtn)

        local minBtn = Create("TextButton", {
            AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-52,0.5,0),
            Size = UDim2.new(0,32,0,32), BackgroundColor3 = Theme.SurfaceLight,
            BackgroundTransparency = 1, FontFace = FontBold, Text = "-",
            TextColor3 = Theme.TextSecondary, TextSize = 22, BorderSizePixel = 0,
            AutoButtonColor = false, TextTransparency = 1, ClipsDescendants = true, ZIndex = 5,
        }, header)
        Create("UICorner", { CornerRadius = UDim.new(0,8) }, minBtn)

        -- Separator
        local separator = Create("Frame", {
            Position = UDim2.new(0.04,0,0,50), Size = UDim2.new(0.92,0,0,1),
            BackgroundColor3 = Theme.Border, BorderSizePixel = 0,
            BackgroundTransparency = 1, ZIndex = 5,
        }, panel)

        -- Info card
        local infoCard = Create("Frame", {
            AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,62),
            Size = UDim2.new(0, panelW-36, 0, 90), BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 5,
        }, panel)
        Create("UICorner", { CornerRadius = UDim.new(0,10) }, infoCard)
        local infoStroke = Create("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, infoCard)
        Create("UIPadding", { PaddingTop = UDim.new(0,12), PaddingLeft = UDim.new(0,16), PaddingRight = UDim.new(0,16) }, infoCard)

        local gameName = CurrentGame and CurrentGame.Name or "Unsupported Game"
        local gameNameLabel = Create("TextLabel", {
            Position = UDim2.new(0,0,0,0), Size = UDim2.new(1,0,0,18),
            BackgroundTransparency = 1, FontFace = FontBold, Text = gameName,
            TextColor3 = Theme.Text, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1, ZIndex = 6,
        }, infoCard)

        local detailText = string.format("Game ID: %s  |  Executor: %s  |  %d Games", CurrentGameId, ExecutorName, SupportedGameCount)
        local detailLabel = Create("TextLabel", {
            Position = UDim2.new(0,0,0,22), Size = UDim2.new(1,0,0,16),
            BackgroundTransparency = 1, FontFace = FontMedium, Text = detailText,
            TextColor3 = Theme.TextSecondary, TextSize = IsMobile and 10 or 12,
            TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
        }, infoCard)

        local statusDot = Create("Frame", {
            AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(0,0,0,54),
            Size = UDim2.new(0,8,0,8), BackgroundColor3 = CurrentGame and Theme.Success or Theme.Error,
            BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 6,
        }, infoCard)
        Create("UICorner", { CornerRadius = UDim.new(1,0) }, statusDot)

        local statusText  = CurrentGame and "Ready to execute" or "Game not supported"
        local statusColor = CurrentGame and Theme.Success or Theme.Error
        local statusLabel = Create("TextLabel", {
            Position = UDim2.new(0,14,0,46), Size = UDim2.new(1,-14,0,16),
            BackgroundTransparency = 1, FontFace = FontMedium, Text = statusText,
            TextColor3 = statusColor, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1, ZIndex = 6,
        }, infoCard)

        -- Execute button
        local execBtnColor = CurrentGame and Theme.Accent or Color3.fromRGB(55,52,62)
        local execBtnText  = CurrentGame and "Execute Script" or "Not Supported"
        local execBtn = Create("TextButton", {
            AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,164),
            Size = UDim2.new(0, panelW-36, 0, 48), BackgroundColor3 = execBtnColor,
            FontFace = FontBold, Text = execBtnText, TextColor3 = Theme.Text, TextSize = 15,
            BorderSizePixel = 0, AutoButtonColor = false, BackgroundTransparency = 1,
            TextTransparency = 1, ClipsDescendants = true, ZIndex = 5,
        }, panel)
        Create("UICorner", { CornerRadius = UDim.new(0,10) }, execBtn)
        local execStroke = Create("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, execBtn)
        if CurrentGame then
            Create("UIGradient", { Color = ColorSequence.new(Theme.Accent, Theme.AccentDark), Rotation = 90 }, execBtn)
        end

        -- Social row
        local socialRow = Create("Frame", {
            AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,224),
            Size = UDim2.new(0, panelW-36, 0, 40), BackgroundTransparency = 1, ZIndex = 5,
        }, panel)
        local halfW = math.floor((panelW - 36 - 10) / 2)

        local function MakeSocialBtn(text, posX, anchorX)
            local btn = Create("TextButton", {
                AnchorPoint = Vector2.new(anchorX,0), Position = UDim2.new(posX,0,0,0),
                Size = UDim2.new(0,halfW,1,0), BackgroundColor3 = Theme.Surface,
                FontFace = FontMedium, Text = text, TextColor3 = Theme.TextSecondary,
                TextSize = 13, BorderSizePixel = 0, AutoButtonColor = false,
                BackgroundTransparency = 1, TextTransparency = 1, ClipsDescendants = true, ZIndex = 5,
            }, socialRow)
            Create("UICorner", { CornerRadius = UDim.new(0,8) }, btn)
            local stroke = Create("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, btn)
            return btn, stroke
        end

        local discordBtn, discordStroke = MakeSocialBtn("Discord", 0, 0)
        local websiteBtn, websiteStroke = MakeSocialBtn("Website", 1, 1)

        -- Footer
        local footer = Create("TextLabel", {
            AnchorPoint = Vector2.new(0.5,1), Position = UDim2.new(0.5,0,1,-12),
            Size = UDim2.new(1,-36,0,18), BackgroundTransparency = 1,
            FontFace = FontMedium, Text = Config.Version .. "  |  Keyless  |  " .. SupportedGameCount .. " Games Supported",
            TextColor3 = Theme.TextTertiary, TextSize = 10, TextTransparency = 1, ZIndex = 5,
        }, panel)

        -- Drag
        MakeDraggable(header, panel, hubConns, function()
            if IsAlive(shadowFrame) and IsAlive(panel) then
                shadowFrame.AnchorPoint = panel.AnchorPoint
                shadowFrame.Position = UDim2.new(
                    panel.Position.X.Scale, panel.Position.X.Offset,
                    panel.Position.Y.Scale, panel.Position.Y.Offset + 5)
            end
        end)

        -- Fade elements table
        local fadeElements = {
            { obj=topAccent,     prop="BackgroundTransparency", to=0 },
            { obj=headerTitle,   prop="TextTransparency",       to=0 },
            { obj=versionBadge,  prop="TextTransparency",       to=0 },
            { obj=versionBadge,  prop="BackgroundTransparency", to=0.4 },
            { obj=closeBtn,      prop="TextTransparency",       to=0 },
            { obj=closeBtn,      prop="BackgroundTransparency", to=0.5 },
            { obj=minBtn,        prop="TextTransparency",       to=0 },
            { obj=minBtn,        prop="BackgroundTransparency", to=0.5 },
            { obj=separator,     prop="BackgroundTransparency", to=0.4 },
            { obj=infoCard,      prop="BackgroundTransparency", to=0 },
            { obj=gameNameLabel, prop="TextTransparency",       to=0 },
            { obj=detailLabel,   prop="TextTransparency",       to=0 },
            { obj=statusLabel,   prop="TextTransparency",       to=0 },
            { obj=statusDot,     prop="BackgroundTransparency", to=0 },
            { obj=execBtn,       prop="BackgroundTransparency", to=0 },
            { obj=execBtn,       prop="TextTransparency",       to=0 },
            { obj=discordBtn,    prop="BackgroundTransparency", to=0 },
            { obj=discordBtn,    prop="TextTransparency",       to=0 },
            { obj=websiteBtn,    prop="BackgroundTransparency", to=0 },
            { obj=websiteBtn,    prop="TextTransparency",       to=0 },
            { obj=footer,        prop="TextTransparency",       to=0 },
        }
        local allStrokes = { panelStroke, infoStroke, execStroke, discordStroke, websiteStroke }

        local function SavePanelPos()
            pcall(function()
                if IsAlive(panel) then
                    Settings.LastPosX = panel.AbsolutePosition.X
                    Settings.LastPosY = panel.AbsolutePosition.Y
                    SaveSettings()
                end
            end)
        end

        -- AnimateOpen
        local function AnimateOpen()
            QuickTween(overlay, { BackgroundTransparency = 0.35 }, 0.45)
            QuickTween(shadowFrame, { Size = UDim2.new(0, panelW+24, 0, panelH+24) }, 0.55, Enum.EasingStyle.Back)
            QuickTween(panel, { Size = UDim2.new(0, panelW, 0, panelH) }, 0.55, Enum.EasingStyle.Back)
            task.wait(0.2)
            for _, s in ipairs(allStrokes) do QuickTween(s, { Transparency = 0 }, 0.35) end
            for i, e in ipairs(fadeElements) do
                task.delay(i * 0.018, function()
                    if IsAlive(e.obj) then QuickTween(e.obj, { [e.prop] = e.to }, 0.35, Enum.EasingStyle.Exponential) end
                end)
            end
            task.wait(0.3)
            -- SET STATE BEFORE SPAWNING LOOPS (critical fix)
            CurrentState = State.HUB_OPEN
            if CurrentGame then
                task.spawn(function()
                    while IsAlive(statusDot) and CurrentState == State.HUB_OPEN do
                        QuickTween(statusDot, { BackgroundTransparency = 0.5 }, 1, Enum.EasingStyle.Sine)
                        task.wait(1)
                        if CurrentState ~= State.HUB_OPEN then break end
                        QuickTween(statusDot, { BackgroundTransparency = 0 }, 1, Enum.EasingStyle.Sine)
                        task.wait(1)
                    end
                end)
            end
            task.spawn(function()
                while IsAlive(headerGrad) and CurrentState == State.HUB_OPEN do
                    QuickTween(headerGrad, { Offset = Vector2.new(0.15, 0) }, 2, Enum.EasingStyle.Sine)
                    task.wait(2)
                    if CurrentState ~= State.HUB_OPEN then break end
                    QuickTween(headerGrad, { Offset = Vector2.new(-0.15, 0) }, 2, Enum.EasingStyle.Sine)
                    task.wait(2)
                end
            end)
        end

        -- AnimateClose
        local function AnimateClose()
            if CurrentState == State.CLOSING then return end
            CurrentState = State.CLOSING
            SavePanelPos()
            for _, e in ipairs(fadeElements) do
                if IsAlive(e.obj) then QuickTween(e.obj, { [e.prop] = 1 }, 0.2) end
            end
            for _, s in ipairs(allStrokes) do QuickTween(s, { Transparency = 1 }, 0.2) end
            task.wait(0.12)
            QuickTween(panel, { Size = UDim2.new(0,0,0,0) }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            QuickTween(shadowFrame, { Size = UDim2.new(0,0,0,0) }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            QuickTween(overlay, { BackgroundTransparency = 1 }, 0.3)
            HideBlur(0.3)
            task.wait(0.4)
            hubConns:DisconnectAll()
            if IsAlive(HubGui) then HubGui:Destroy(); HubGui = nil end
            CurrentState = State.IDLE
        end

        -- AnimateMinimize
        local function AnimateMinimize()
            if CurrentState == State.CLOSING then return end
            CurrentState = State.CLOSING
            SavePanelPos()
            for _, e in ipairs(fadeElements) do
                if IsAlive(e.obj) then QuickTween(e.obj, { [e.prop] = 1 }, 0.18) end
            end
            for _, s in ipairs(allStrokes) do QuickTween(s, { Transparency = 1 }, 0.18) end
            task.wait(0.1)
            QuickTween(panel, { Size = UDim2.new(0,0,0,0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            QuickTween(shadowFrame, { Size = UDim2.new(0,0,0,0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            QuickTween(overlay, { BackgroundTransparency = 1 }, 0.25)
            HideBlur(0.25)
            task.wait(0.35)
            hubConns:DisconnectAll()
            if IsAlive(HubGui) then HubGui:Destroy(); HubGui = nil end
            CreateToggleButton()
        end

        -- Hover helper
        local function AddButtonHover(btn, normal, hover)
            normal = normal or Theme.Surface; hover = hover or Theme.SurfaceHover
            hubConns:Connect(btn.MouseEnter, function()
                if IsAlive(btn) then QuickTween(btn, { BackgroundColor3 = hover }, 0.15) end
            end)
            hubConns:Connect(btn.MouseLeave, function()
                if IsAlive(btn) then QuickTween(btn, { BackgroundColor3 = normal }, 0.15) end
            end)
        end

        -- Button events
        hubConns:Connect(overlay.MouseButton1Click, Debounce(AnimateClose, 1))

        hubConns:Connect(closeBtn.MouseButton1Click, Debounce(function() CreateRipple(closeBtn); AnimateClose() end, 1))
        hubConns:Connect(closeBtn.MouseEnter, function() QuickTween(closeBtn, { BackgroundTransparency = 0.15, TextColor3 = Theme.Error }, 0.15) end)
        hubConns:Connect(closeBtn.MouseLeave, function() QuickTween(closeBtn, { BackgroundTransparency = 0.5, TextColor3 = Theme.TextSecondary }, 0.15) end)

        hubConns:Connect(minBtn.MouseButton1Click, Debounce(function() CreateRipple(minBtn); AnimateMinimize() end, 1))
        hubConns:Connect(minBtn.MouseEnter, function() QuickTween(minBtn, { BackgroundTransparency = 0.15, TextColor3 = Theme.Warning }, 0.15) end)
        hubConns:Connect(minBtn.MouseLeave, function() QuickTween(minBtn, { BackgroundTransparency = 0.5, TextColor3 = Theme.TextSecondary }, 0.15) end)

        local onExecClick = Debounce(function()
            if ScriptLoaded then Notify("Info", "Script already loaded!", 3, Theme.Info); return end
            if not CurrentGame then Notify("Error", "This game is not supported.", 4, Theme.Error); return end
            if ExecutingLock then return end
            ExecutingLock = true
            CreateRipple(execBtn)
            local stopAnim = AnimateLoadingText(execBtn, "Loading")
            QuickTween(execBtn, { BackgroundColor3 = Theme.SurfaceLight }, 0.2)
            if IsAlive(statusLabel) then statusLabel.Text = "Loading script..."; QuickTween(statusLabel, { TextColor3 = Theme.Warning }, 0.2) end
            if IsAlive(statusDot) then QuickTween(statusDot, { BackgroundColor3 = Theme.Warning }, 0.2) end
            task.spawn(function()
                local success = LoadGameScript()
                stopAnim()
                if success then
                    if IsAlive(execBtn) then execBtn.Text = "Loaded Successfully"; QuickTween(execBtn, { BackgroundColor3 = Theme.Success }, 0.3) end
                    if IsAlive(statusLabel) then statusLabel.Text = "Script loaded"; QuickTween(statusLabel, { TextColor3 = Theme.Success }, 0.3) end
                    if IsAlive(statusDot) then QuickTween(statusDot, { BackgroundColor3 = Theme.Success }, 0.3) end
                    Notify("Success", CurrentGame.Name .. " script loaded!", 4, Theme.Success)
                else
                    ExecutingLock = false
                    if IsAlive(execBtn) then execBtn.Text = "Retry Execute"; QuickTween(execBtn, { BackgroundColor3 = Theme.Accent }, 0.3) end
                    if IsAlive(statusLabel) then statusLabel.Text = "Load failed - tap to retry"; QuickTween(statusLabel, { TextColor3 = Theme.Error }, 0.3) end
                    if IsAlive(statusDot) then QuickTween(statusDot, { BackgroundColor3 = Theme.Error }, 0.3) end
                end
            end)
        end, 1.5)

        hubConns:Connect(execBtn.MouseButton1Click, onExecClick)
        if CurrentGame then AddButtonHover(execBtn, Theme.Accent, Theme.AccentLight) end

        hubConns:Connect(discordBtn.MouseButton1Click, Debounce(function()
            CreateRipple(discordBtn); pcall(setclipboard, Config.Discord)
            Notify("Copied", "Discord invite copied to clipboard.", 3, Theme.Info)
        end, 1))
        AddButtonHover(discordBtn)

        hubConns:Connect(websiteBtn.MouseButton1Click, Debounce(function()
            CreateRipple(websiteBtn); pcall(setclipboard, Config.Website)
            Notify("Copied", "Website link copied to clipboard.", 3, Theme.Info)
        end, 1))
        AddButtonHover(websiteBtn)

        AnimateOpen()

        if Config.AutoExecute and CurrentGame and not ScriptLoaded then
            task.delay(1.5, function()
                if not ScriptLoaded and IsAlive(execBtn) then onExecClick() end
            end)
        end
    end

    -- 10g: Keyboard Shortcuts
    GlobalConns:Connect(UserInputService.InputBegan, function(input, processed)
        if processed then return end
        if input.KeyCode ~= Enum.KeyCode.RightControl and input.KeyCode ~= Enum.KeyCode.F9 then return end
        if CurrentState == State.MINIMIZED then
            CurrentState = State.CLOSING
            toggleConns:DisconnectAll()
            if IsAlive(ToggleButton) then QuickTween(ToggleButton, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.2) end
            task.wait(0.25)
            if IsAlive(ToggleGui) then ToggleGui:Destroy(); ToggleGui = nil end
            CurrentState = State.IDLE
            CreateHub()
        elseif CurrentState == State.HUB_OPEN then
            CurrentState = State.CLOSING
            pcall(function()
                if IsAlive(HubGui) then
                    local p = HubGui:FindFirstChild("Panel")
                    if p then Settings.LastPosX = p.AbsolutePosition.X; Settings.LastPosY = p.AbsolutePosition.Y; SaveSettings() end
                end
            end)
            hubConns:DisconnectAll()
            if IsAlive(HubGui) then HubGui:Destroy(); HubGui = nil end
            HideBlur(0.2)
            CreateToggleButton()
        elseif CurrentState == State.IDLE then
            CreateHub()
        end
    end)

    -- 10h: Launch
    CreateSplash(function()
        CreateHub()
        task.wait(0.6)
        if not CurrentGame then
            Notify("Unsupported", "This game is not in the supported list. " .. SupportedGameCount .. " games available.", 5, Theme.Warning)
        else
            Notify("Welcome", "Playing " .. CurrentGame.Name .. " | Executor: " .. ExecutorName, 4, Theme.Accent)
        end
    end)
end

-- Error boundary
local ok, err = pcall(Main)
if not ok then
    warn("[Solix Hub] Fatal error: " .. tostring(err))
end
