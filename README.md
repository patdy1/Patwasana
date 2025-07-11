local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- หน้าจอหลัก
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "TeleportUI"
screenGui.ResetOnSpawn = false

-- ใส่พื้นฐานความโค้ง
local function addCorner(obj, radius)
	local corner = Instance.new("UICorner", obj)
	corner.CornerRadius = UDim.new(0, radius or 8)
end

-- ปุ่มเปิด/ปิด
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Size = UDim2.new(0, 60, 0, 30)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "เปิด"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
addCorner(toggleButton)

-- กล่องค้นหา
local searchBox = Instance.new("TextBox", screenGui)
searchBox.Position = UDim2.new(0, 10, 0, 50)
searchBox.Size = UDim2.new(0, 160, 0, 28)
searchBox.PlaceholderText = "ค้นหาผู้เล่น"
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 16
searchBox.Visible = false
addCorner(searchBox)

-- กรอบเลื่อนรายชื่อผู้เล่น
local scrollFrame = Instance.new("ScrollingFrame", screenGui)
scrollFrame.Position = UDim2.new(0, 10, 0, 85)
scrollFrame.Size = UDim2.new(0, 160, 0, 170)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Visible = false
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ClipsDescendants = true
addCorner(scrollFrame)

local uiListLayout = Instance.new("UIListLayout", scrollFrame)
uiListLayout.Padding = UDim.new(0, 6)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- เก็บปุ่ม
local buttons = {}

-- ฟังก์ชันวาร์ป
local function teleportToPlayer(player)
	if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 0))
	end
end

-- สร้างปุ่มผู้เล่น
local function createButton(player)
	local button = Instance.new("TextButton", scrollFrame)
	button.Size = UDim2.new(1, 0, 0, 28)
	button.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = player.Name
	button.Font = Enum.Font.Gotham
	button.TextSize = 16
	button.Name = player.Name
	addCorner(button)

	button.MouseButton1Click:Connect(function()
		teleportToPlayer(player)
	end)

	buttons[player.Name] = button
end

-- ค้นหา
local function filterButtons()
	local text = searchBox.Text:lower()
	for name, button in pairs(buttons) do
		button.Visible = name:lower():find(text) ~= nil
	end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(filterButtons)

-- โหลดผู้เล่นที่มีอยู่
for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		createButton(player)
	end
end

-- เมื่อมีผู้เล่นเข้าใหม่
Players.PlayerAdded:Connect(function(player)
	if player ~= LocalPlayer then
		createButton(player)
		filterButtons()
	end
end)

-- เปิด/ปิด UI
local open = false
toggleButton.MouseButton1Click:Connect(function()
	open = not open
	scrollFrame.Visible = open
	searchBox.Visible = open
	if open then
		toggleButton.Text = "ปิด"
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
	else
		toggleButton.Text = "เปิด"
		toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	end
end)

-- เครดิต
local credit = Instance.new("TextLabel", screenGui)
credit.AnchorPoint = Vector2.new(0, 1)
credit.Position = UDim2.new(0, 10, 1, -10)
credit.Size = UDim2.new(0, 250, 0, 20)
credit.Text = "Created by : PatwasanaBitkub"
credit.Font = Enum.Font.GothamSemibold
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.BackgroundTransparency = 1
credit.TextSize = 12
credit.TextXAlignment = Enum.TextXAlignment.Left
