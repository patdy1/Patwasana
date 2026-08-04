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

local Button = Instance.new("TextButton")
Button.Parent = Gui
Button.Size = UDim2.new(0, 150, 0, 40)
Button.Position = UDim2.new(1, -170, 1, -60) -- มุมขวาล่าง
Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "Discord"
Button.TextScaled = true
Button.BorderSizePixel = 0

Button.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/v7VGZEdfgC")
    elseif toclipboard then
        toclipboard("https://discord.gg/v7VGZEdfgC")
    end
end)