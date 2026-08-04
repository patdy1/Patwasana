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

GitHub Copilot Chat Assistant

--// Responsive Roblox UI Template
--// Mobile + PC Support

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ลบ UI เก่าถ้ามี
if PlayerGui:FindFirstChild("MainUI") then
	PlayerGui.MainUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MainUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- ปุ่มเปิด UI
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui

OpenButton.Size = UDim2.fromScale(0.12, 0.06)
OpenButton.Position = UDim2.fromScale(0.03, 0.45)

OpenButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Text = "OPEN"
OpenButton.TextScaled = true

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0.3, 0)
OpenCorner.Parent = OpenButton

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui

Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.08, 0)
Corner.Parent = Main

-- กัน UI เพี้ยน
local Aspect = Instance.new("UIAspectRatioConstraint")
Aspect.AspectRatio = 1.4
Aspect.Parent = Main

-- ขอบ
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(100, 100, 100)
Stroke.Parent = Main

-- Padding
local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0.05, 0)
Padding.PaddingBottom = UDim.new(0.05, 0)
Padding.PaddingLeft = UDim.new(0.05, 0)
Padding.PaddingRight = UDim.new(0.05, 0)
Padding.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Main

Title.Size = UDim2.fromScale(1, 0.15)
Title.Position = UDim2.fromScale(0, 0)

Title.BackgroundTransparency = 1
Title.Text = "Pat UI"
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ปุ่มตัวอย่าง
local Button = Instance.new("TextButton")
Button.Parent = Main

Button.Size = UDim2.fromScale(0.8, 0.15)
Button.Position = UDim2.fromScale(0.1, 0.3)

Button.Text = "CLICK"
Button.TextScaled = true

Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0.25, 0)
ButtonCorner.Parent = Button

-- เปิด/ปิด UI
local Open = true
local isTweening = false
local currentTargetSize = UDim2.fromScale(0.55, 0.55)
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ตรวจขนาดหน้าจอ
local Camera = workspace.CurrentCamera

local function computeTargetSize()
	local View = Camera.ViewportSize
	if View.X < 700 then
		-- มือถือ
		return UDim2.fromScale(0.85, 0.55)
	else
		-- PC
		return UDim2.fromScale(0.55, 0.55)
	end
end

local function ResizeUI()
	currentTargetSize = computeTargetSize()

	-- ถ้าเปิดอยู่ ให้ tween ไปขนาดใหม่เพื่อให้ลื่น
	if Main.Visible and not isTweening then
		isTweening = true
		local tween = TweenService:Create(Main, tweenInfo, { Size = currentTargetSize })
		tween:Play()
		tween.Completed:Connect(function()
			isTweening = false
		end)
	else
		-- ถ้าไม่ visible ให้ตั้งค่า size เงียบๆ เพื่อรอเปิด
		Main.Size = currentTargetSize
	end
end

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(ResizeUI)

-- เริ่มต้นขนาดและสถานะ
Main.Visible = Open
ResizeUI()

OpenButton.MouseButton1Click:Connect(function()
	if isTweening then return end
	isTweening = true

	Open = not Open

	if Open then
		Main.Visible = true
		local tween = TweenService:Create(Main, tweenInfo, { Size = currentTargetSize })
		tween:Play()
		tween.Completed:Connect(function()
			isTweening = false
		end)
	else
		local tween = TweenService:Create(Main, tweenInfo, { Size = UDim2.fromScale(0, 0) })
		tween:Play()
		tween.Completed:Connect(function()
			Main.Visible = false
			isTweening = false
		end)
	end
end)

-- หมายเหตุ: วางสคริปต์นี้เป็น LocalScript (เช่น StarterPlayerScripts หรือ StarterGui) เพื่อให้ Players.LocalPlayer ใช้งานได้ตามปกติ.