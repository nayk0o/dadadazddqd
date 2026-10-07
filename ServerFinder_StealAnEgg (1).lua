local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local requestFunc = nil
if syn and syn.request then
    requestFunc = syn.request
elseif http and http.request then
    requestFunc = http.request
elseif http_request then
    requestFunc = http_request
elseif fluxus and fluxus.request then
    requestFunc = fluxus.request
elseif request then
    requestFunc = request
else
    error("No supported HTTP request function found! 😢")
end

local gameName = "Unknown"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    gameName = info.Name or gameName
end)

local function MakeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.AbsolutePosition
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
        end
    end)
end

local LowServerFinder = Instance.new("ScreenGui")
LowServerFinder.Name = "ServerFinderPro"
LowServerFinder.Parent = LocalPlayer:WaitForChild("PlayerGui")
LowServerFinder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LowServerFinder.ResetOnSpawn = false

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function addStroke(parent, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Color = Color3.fromRGB(95, 95, 115)
    s.Parent = parent
    return s
end

local function addPadding(parent, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.Parent = parent
    return p
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = LowServerFinder
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -260)
MainFrame.Size = UDim2.new(0, 780, 0, 520)
addCorner(MainFrame, 18)
addStroke(MainFrame, 1, 0.15)

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 27, 37)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 13, 18))
})
MainGradient.Rotation = 90
MainGradient.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundTransparency = 1
Header.Position = UDim2.new(0, 20, 0, 14)
Header.Size = UDim2.new(1, -40, 0, 58)

local Logo = Instance.new("Frame")
Logo.Parent = Header
Logo.BackgroundColor3 = Color3.fromRGB(86, 72, 255)
Logo.Size = UDim2.new(0, 48, 0, 48)
addCorner(Logo, 14)

local LogoText = Instance.new("TextLabel")
LogoText.Parent = Logo
LogoText.BackgroundTransparency = 1
LogoText.Size = UDim2.fromScale(1, 1)
LogoText.Font = Enum.Font.GothamBold
LogoText.Text = "SF"
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.TextSize = 17

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 60, 0, 0)
Title.Size = UDim2.new(0, 390, 0, 28)
Title.Font = Enum.Font.GothamBold
Title.Text = "Server Finder"
Title.TextColor3 = Color3.fromRGB(248, 248, 255)
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Header
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 61, 0, 29)
Subtitle.Size = UDim2.new(0, 390, 0, 20)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Find a public server quickly"
Subtitle.TextColor3 = Color3.fromRGB(145, 145, 165)
Subtitle.TextSize = 13
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

local StatusDot = Instance.new("Frame")
StatusDot.Parent = Header
StatusDot.BackgroundColor3 = Color3.fromRGB(80, 220, 135)
StatusDot.Position = UDim2.new(1, -210, 0, 17)
StatusDot.Size = UDim2.new(0, 9, 0, 9)
addCorner(StatusDot, 9)

local Status = Instance.new("TextLabel")
Status.Parent = Header
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(1, -195, 0, 9)
Status.Size = UDim2.new(0, 100, 0, 25)
Status.Font = Enum.Font.GothamMedium
Status.Text = "ONLINE"
Status.TextColor3 = Color3.fromRGB(170, 175, 190)
Status.TextSize = 12
Status.TextXAlignment = Enum.TextXAlignment.Left

local RefreshButton = Instance.new("TextButton")
RefreshButton.Name = "Refresh"
RefreshButton.Parent = Header
RefreshButton.BackgroundColor3 = Color3.fromRGB(42, 42, 56)
RefreshButton.Position = UDim2.new(1, -95, 0, 5)
RefreshButton.Size = UDim2.new(0, 95, 0, 38)
RefreshButton.Font = Enum.Font.GothamBold
RefreshButton.Text = "↻  Refresh"
RefreshButton.TextColor3 = Color3.fromRGB(235, 235, 245)
RefreshButton.TextSize = 13
addCorner(RefreshButton, 10)
addStroke(RefreshButton, 1, 0.45)

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Parent = MainFrame
Close.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
Close.Position = UDim2.new(1, -47, 0, 16)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Font = Enum.Font.GothamBold
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(220, 220, 230)
Close.TextSize = 20
addCorner(Close, 9)

-- Summary cards
local Summary = Instance.new("Frame")
Summary.Parent = MainFrame
Summary.BackgroundTransparency = 1
Summary.Position = UDim2.new(0, 20, 0, 84)
Summary.Size = UDim2.new(1, -40, 0, 72)

local SummaryLayout = Instance.new("UIListLayout")
SummaryLayout.Parent = Summary
SummaryLayout.FillDirection = Enum.FillDirection.Horizontal
SummaryLayout.Padding = UDim.new(0, 10)
SummaryLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createCard(title, value, icon)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(31, 31, 42)
    card.Size = UDim2.new(0.333, -7, 1, 0)
    addCorner(card, 12)
    addStroke(card, 1, 0.6)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = card
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 13, 0, 12)
    iconLabel.Size = UDim2.new(0, 32, 0, 32)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon
    iconLabel.TextSize = 18

    local t = Instance.new("TextLabel")
    t.Parent = card
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 52, 0, 9)
    t.Size = UDim2.new(1, -62, 0, 18)
    t.Font = Enum.Font.Gotham
    t.Text = title
    t.TextColor3 = Color3.fromRGB(145, 145, 165)
    t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left

    local v = Instance.new("TextLabel")
    v.Parent = card
    v.BackgroundTransparency = 1
    v.Position = UDim2.new(0, 52, 0, 29)
    v.Size = UDim2.new(1, -62, 0, 25)
    v.Font = Enum.Font.GothamBold
    v.Text = value
    v.TextColor3 = Color3.fromRGB(245, 245, 250)
    v.TextSize = 18
    v.TextXAlignment = Enum.TextXAlignment.Left

    return v
end

local ServerCountValue = createCard("SERVERS FOUND", "0", "▦")
local PlayerTotalValue = createCard("VISIBLE PLAYERS", "0", "●")
local BestServerValue = createCard("BEST SERVER", "—", "★")

-- Toolbar
local Toolbar = Instance.new("Frame")
Toolbar.Parent = MainFrame
Toolbar.BackgroundColor3 = Color3.fromRGB(24, 24, 33)
Toolbar.Position = UDim2.new(0, 20, 0, 170)
Toolbar.Size = UDim2.new(1, -40, 0, 48)
addCorner(Toolbar, 11)
addStroke(Toolbar, 1, 0.65)

local SortTitle = Instance.new("TextLabel")
SortTitle.Parent = Toolbar
SortTitle.BackgroundTransparency = 1
SortTitle.Position = UDim2.new(0, 14, 0, 0)
SortTitle.Size = UDim2.new(0, 95, 1, 0)
SortTitle.Font = Enum.Font.GothamMedium
SortTitle.Text = "SORT BY"
SortTitle.TextColor3 = Color3.fromRGB(135, 135, 155)
SortTitle.TextSize = 11
SortTitle.TextXAlignment = Enum.TextXAlignment.Left

local SortButton = Instance.new("TextButton")
SortButton.Name = "SortButton"
SortButton.Parent = Toolbar
SortButton.BackgroundColor3 = Color3.fromRGB(86, 72, 255)
SortButton.Position = UDim2.new(0, 88, 0, 7)
SortButton.Size = UDim2.new(0, 120, 0, 34)
SortButton.Font = Enum.Font.GothamBold
SortButton.Text = "Players ↓"
SortButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SortButton.TextSize = 12
addCorner(SortButton, 9)

local CountLabel = Instance.new("TextLabel")
CountLabel.Parent = Toolbar
CountLabel.BackgroundTransparency = 1
CountLabel.Position = UDim2.new(1, -185, 0, 0)
CountLabel.Size = UDim2.new(0, 170, 1, 0)
CountLabel.Font = Enum.Font.Gotham
CountLabel.Text = "Loading servers..."
CountLabel.TextColor3 = Color3.fromRGB(145, 145, 165)
CountLabel.TextSize = 11
CountLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Server list
local ServerListFrame = Instance.new("ScrollingFrame")
ServerListFrame.Name = "ServerListFrame"
ServerListFrame.Parent = MainFrame
ServerListFrame.Active = true
ServerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ServerListFrame.BorderSizePixel = 0
ServerListFrame.Position = UDim2.new(0, 20, 0, 228)
ServerListFrame.Size = UDim2.new(1, -40, 0, 235)
ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerListFrame.ScrollBarThickness = 3
ServerListFrame.ScrollBarImageColor3 = Color3.fromRGB(86, 72, 255)
addCorner(ServerListFrame, 12)
addStroke(ServerListFrame, 1, 0.72)
addPadding(ServerListFrame, 8, 8, 8, 8)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ServerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)

local ServerFrameTemplate = Instance.new("Frame")
ServerFrameTemplate.Name = "ServerFrame"
ServerFrameTemplate.Parent = ServerListFrame
ServerFrameTemplate.BackgroundColor3 = Color3.fromRGB(31, 31, 42)
ServerFrameTemplate.BorderSizePixel = 0
ServerFrameTemplate.Size = UDim2.new(1, -16, 0, 66)
ServerFrameTemplate.Visible = false
addCorner(ServerFrameTemplate, 11)
addStroke(ServerFrameTemplate, 1, 0.72)

local ServerInfo = Instance.new("TextLabel")
ServerInfo.Name = "ServerInfo"
ServerInfo.Parent = ServerFrameTemplate
ServerInfo.BackgroundTransparency = 1
ServerInfo.Position = UDim2.new(0, 15, 0, 8)
ServerInfo.Size = UDim2.new(0.52, 0, 0, 48)
ServerInfo.Font = Enum.Font.GothamMedium
ServerInfo.Text = "Server"
ServerInfo.TextColor3 = Color3.fromRGB(238, 238, 245)
ServerInfo.TextSize = 12
ServerInfo.TextWrapped = true
ServerInfo.TextXAlignment = Enum.TextXAlignment.Left
ServerInfo.TextYAlignment = Enum.TextYAlignment.Center

local ServerStats = Instance.new("TextLabel")
ServerStats.Name = "ServerStats"
ServerStats.Parent = ServerFrameTemplate
ServerStats.BackgroundTransparency = 1
ServerStats.Position = UDim2.new(0.55, 0, 0, 8)
ServerStats.Size = UDim2.new(0.22, 0, 0, 48)
ServerStats.Font = Enum.Font.GothamBold
ServerStats.Text = "● 0 / 0"
ServerStats.TextColor3 = Color3.fromRGB(105, 215, 255)
ServerStats.TextSize = 13
ServerStats.TextXAlignment = Enum.TextXAlignment.Left
ServerStats.TextYAlignment = Enum.TextYAlignment.Center

local Join = Instance.new("TextButton")
Join.Name = "Join"
Join.Parent = ServerFrameTemplate
Join.BackgroundColor3 = Color3.fromRGB(86, 72, 255)
Join.BorderSizePixel = 0
Join.Position = UDim2.new(1, -112, 0, 13)
Join.Size = UDim2.new(0, 98, 0, 40)
Join.Font = Enum.Font.GothamBold
Join.Text = "JOIN  →"
Join.TextColor3 = Color3.fromRGB(255, 255, 255)
Join.TextSize = 12
addCorner(Join, 9)

-- Empty/loading label
local EmptyLabel = Instance.new("TextLabel")
EmptyLabel.Parent = ServerListFrame
EmptyLabel.BackgroundTransparency = 1
EmptyLabel.Size = UDim2.new(1, -16, 0, 60)
EmptyLabel.Font = Enum.Font.Gotham
EmptyLabel.Text = "Searching public servers..."
EmptyLabel.TextColor3 = Color3.fromRGB(125, 125, 145)
EmptyLabel.TextSize = 13
EmptyLabel.LayoutOrder = -100

-- Hide/show button
local HideShow = Instance.new("TextButton")
HideShow.Name = "HideShow"
HideShow.Parent = LowServerFinder
HideShow.BackgroundColor3 = Color3.fromRGB(86, 72, 255)
HideShow.BorderSizePixel = 0
HideShow.Position = UDim2.new(0, 12, 0.5, -20)
HideShow.Size = UDim2.new(0, 42, 0, 42)
HideShow.Font = Enum.Font.GothamBold
HideShow.Text = "≡"
HideShow.TextColor3 = Color3.fromRGB(255, 255, 255)
HideShow.TextSize = 20
addCorner(HideShow, 12)
addStroke(HideShow, 1, 0.35)

local isHidden = false

HideShow.MouseButton1Click:Connect(function()
    if not isHidden then
        MainFrame.Visible = false
        HideShow.Text = "☰"
        isHidden = true
    else
        MainFrame.Visible = true
        HideShow.Text = "≡"
        isHidden = false
    end
end)

Close.MouseButton1Click:Connect(function()
    LowServerFinder:Destroy()
end)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 16)
end)

local SortDirection = true
local SortMode = "Players"
local ServerEntries = {}

local function updateSortButton()
    SortButton.Text = "Players " .. (SortDirection and "↓" or "↑")
end

local function sortEntries()
    table.sort(ServerEntries, function(a, b)
        if a.playing == b.playing then
            return tostring(a.id) < tostring(b.id)
        end
        if SortDirection then
            return a.playing > b.playing
        end
        return a.playing < b.playing
    end)

    for index, entry in ipairs(ServerEntries) do
        entry.frame.LayoutOrder = index
    end

    local totalPlayers = 0
    for _, entry in ipairs(ServerEntries) do
        totalPlayers = totalPlayers + entry.playing
    end

    ServerCountValue.Text = tostring(#ServerEntries)
    PlayerTotalValue.Text = tostring(totalPlayers)

    if ServerEntries[1] then
        BestServerValue.Text = tostring(ServerEntries[1].playing) .. "/" .. tostring(ServerEntries[1].maxPlayers)
    else
        BestServerValue.Text = "—"
    end

    CountLabel.Text = tostring(#ServerEntries) .. " public servers"
end

SortButton.MouseButton1Click:Connect(function()
    SortDirection = not SortDirection
    updateSortButton()
    sortEntries()
end)

local function createServerEntry(serverData)
    local clone = ServerFrameTemplate:Clone()
    clone.Name = "ServerFrameClone"
    clone.Visible = true
    clone.Parent = ServerListFrame

    local serverInfoLabel = clone:FindFirstChild("ServerInfo")
    serverInfoLabel.Text = string.format(
        "PUBLIC SERVER\n%s",
        tostring(serverData.id)
    )

    local serverStatsLabel = clone:FindFirstChild("ServerStats")
    if serverStatsLabel then
        local playing = tonumber(serverData.playing) or 0
        local maxPlayers = tonumber(serverData.maxPlayers) or 0
        serverStatsLabel.Text = string.format("●  %d / %d\nPLAYERS", playing, maxPlayers)
    end

    local joinButton = clone:FindFirstChild("Join")
    joinButton.MouseButton1Click:Connect(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.id, LocalPlayer)
    end)

    table.insert(ServerEntries, {
        frame = clone,
        id = tostring(serverData.id),
        playing = tonumber(serverData.playing) or 0,
        maxPlayers = tonumber(serverData.maxPlayers) or 0
    })
end

local function fetchServers(cursor)
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
    if cursor then
        url = url .. "&cursor=" .. cursor
    end
    local response = requestFunc({
        Url = url,
        Method = "GET"
    })
    if response and response.Body then
        return HttpService:JSONDecode(response.Body)
    end
end


local refreshing = false

local function setStatus(text, online)
    Status.Text = text
    StatusDot.BackgroundColor3 = online
        and Color3.fromRGB(80, 220, 135)
        or Color3.fromRGB(245, 190, 70)
end

local function clearServers()
    for _, entry in ipairs(ServerEntries) do
        if entry.frame and entry.frame.Parent then
            entry.frame:Destroy()
        end
    end

    table.clear(ServerEntries)
    EmptyLabel.Visible = true
    EmptyLabel.Text = "Searching public servers..."
    setStatus("SEARCHING", false)
    ServerCountValue.Text = "0"
    PlayerTotalValue.Text = "0"
    BestServerValue.Text = "—"
    CountLabel.Text = "Searching..."
end

local function loadServers()
    if refreshing then
        return
    end

    refreshing = true
    clearServers()

    task.spawn(function()
        local servers = {}
        local cursor = nil
        local failed = false
        local failReason = nil

        repeat
            local ok, data = pcall(function()
                return fetchServers(cursor)
            end)

            if not ok then
                failed = true
                failReason = tostring(data)
                break
            end

            if data and type(data) == "table" and data.data then
                for _, server in ipairs(data.data) do
                    if server.id and server.playing ~= nil and server.maxPlayers ~= nil then
                        table.insert(servers, server)
                    end
                end
                cursor = data.nextPageCursor
            else
                failed = true
                failReason = "No server data returned"
                break
            end
        until not cursor

        if failed then
            EmptyLabel.Visible = true
            EmptyLabel.Text = "Unable to load servers"
            CountLabel.Text = "Request failed"
            setStatus("ERROR", false)
            refreshing = false
            warn("[Server Finder] " .. tostring(failReason))
            return
        end

        table.sort(servers, function(a, b)
            local ap = tonumber(a.playing) or 0
            local bp = tonumber(b.playing) or 0
            if ap == bp then
                return tostring(a.id) < tostring(b.id)
            end
            return ap > bp
        end)

        local available = 0

        for _, server in ipairs(servers) do
            local playing = tonumber(server.playing) or 0
            local maxPlayers = tonumber(server.maxPlayers) or 0

            if playing < maxPlayers then
                createServerEntry(server)
                available = available + 1
            end
        end

        if available == 0 then
            EmptyLabel.Visible = true
            EmptyLabel.Text = "No available public server found."
        else
            EmptyLabel.Visible = false
        end

        sortEntries()
        setStatus("ONLINE", true)
        refreshing = false
    end)
end

RefreshButton.MouseButton1Click:Connect(function()
    loadServers()
end)

MakeDraggable(MainFrame)
MakeDraggable(HideShow)

loadServers()
