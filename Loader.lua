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
