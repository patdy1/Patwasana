local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local function IsDescendantOfPlayer(obj)
    local character = LocalPlayer.Character
    if character and obj:IsDescendantOf(character) then
        return true
    end
    if obj:IsDescendantOf(LocalPlayer) then
        return true
    end
    return false
end

local function RemoveTexturesButKeepDecalsAndGuis(obj)
    if IsDescendantOfPlayer(obj) then
        return
    end

    for _, child in pairs(obj:GetChildren()) do
        if child:IsA("Texture") or child:IsA("SurfaceAppearance") then
            child:Destroy()
        end
    end

    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
    end

    for _, child in pairs(obj:GetChildren()) do
        RemoveTexturesButKeepDecalsAndGuis(child)
    end
end

-- ทำครั้งแรกตอนเริ่มเกมลบของเก่า
RemoveTexturesButKeepDecalsAndGuis(Workspace)

-- ฟังเหตุการณ์วัตถุใหม่เพิ่มเข้ามา
Workspace.DescendantAdded:Connect(function(obj)
    RemoveTexturesButKeepDecalsAndGuis(obj)
end)
local Gui = Instance.new("ScreenGui")
Gui.Name = "DiscordCopy"
Gui.ResetOnSpawn = false
pcall(function()
    Gui.Parent = game:GetService("CoreGui")
end)

--// =========================
--// Copy Discord Card (iOS Style)
--// วางต่อท้ายสคริปต์เดิมได้เลย
--// =========================

local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

pcall(function()
	if CoreGui:FindFirstChild("DiscordCopyCard") then
		CoreGui.DiscordCopyCard:Destroy()
	end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "DiscordCopyCard"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = CoreGui

-- Card
local Card = Instance.new("Frame")
Card.Parent = Gui
Card.Size = UDim2.fromOffset(175, 46)
Card.AnchorPoint = Vector2.new(1,1)
Card.Position = UDim2.new(0.985,0,0.965,0)
Card.BackgroundColor3 = Color3.fromRGB(30,30,30)
Card.BackgroundTransparency = 0.08
Card.BorderSizePixel = 0

Instance.new("UICorner", Card).CornerRadius = UDim.new(0,18)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Card
Stroke.Thickness = 1
Stroke.Color = Color3.fromRGB(70,70,70)
Stroke.Transparency = 0.45

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Parent = Card
Shadow.BackgroundTransparency = 1
Shadow.Size = UDim2.new(1,24,1,24)
Shadow.Position = UDim2.new(0,-12,0,-12)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.55
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10,10,118,118)
Shadow.ZIndex = 0

-- Title
local Title = Instance.new("TextButton")
Title.Parent = Card
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,-34,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.Font = Enum.Font.GothamMedium
Title.Text = "Copy Discord Server"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.AutoButtonColor = false

-- Close
local Close = Instance.new("TextButton")
Close.Parent = Card
Close.AnchorPoint = Vector2.new(1,0)
Close.Position = UDim2.new(1,-8,0,8)
Close.Size = UDim2.fromOffset(18,18)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 12
Close.TextColor3 = Color3.new(1,1,1)
Close.BackgroundColor3 = Color3.fromRGB(80,80,80)
Close.BorderSizePixel = 0

Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

-- เปิดตัวแบบสมูท
Card.Size = UDim2.fromOffset(165,42)
Card.BackgroundTransparency = 1

TweenService:Create(Card,TweenInfo.new(
	0.28,
	Enum.EasingStyle.Quint,
	Enum.EasingDirection.Out
),{
	Size = UDim2.fromOffset(175,46),
	BackgroundTransparency = 0.08
}):Play()

-- ลากได้
local dragging = false
local dragInput
local dragStart
local startPos

Card.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Card.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Card.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Card.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Copy
local function CopyDiscord()

	if setclipboard then
		setclipboard("https://discord.gg/v7VGZEdfgC")
	elseif toclipboard then
		toclipboard("https://discord.gg/v7VGZEdfgC")
	end

	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = "Discord",
			Text = "Discord link copied!",
			Duration = 2
		})
	end)

	local down = TweenService:Create(Card,TweenInfo.new(
		0.08,
		Enum.EasingStyle.Quad
	),{
		Size = UDim2.fromOffset(168,44)
	})

	local up = TweenService:Create(Card,TweenInfo.new(
		0.12,
		Enum.EasingStyle.Back
	),{
		Size = UDim2.fromOffset(175,46)
	})

	down:Play()
	down.Completed:Wait()
	up:Play()
end

Title.MouseButton1Click:Connect(CopyDiscord)

Close.MouseButton1Click:Connect(function()
	local tween = TweenService:Create(Card,TweenInfo.new(
		0.2,
		Enum.EasingStyle.Quint
	),{
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(165,42)
	})

	tween:Play()
	tween.Completed:Wait()
	Gui:Destroy()
end)