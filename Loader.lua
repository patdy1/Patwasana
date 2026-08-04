local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer


-- GUI

local gui = Instance.new("ScreenGui")
gui.Name = "PlayerProfileHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")



-- Main UI

local main = Instance.new("Frame")
main.Size = UDim2.new(0,152,0,56)
main.Position = UDim2.new(0,10,0,10)

-- #212121
main.BackgroundColor3 = Color3.fromRGB(33,33,33)

main.BorderSizePixel = 0
main.Parent = gui



local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,8)
mainCorner.Parent = main



-- UI Stroke #2C2C2C

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(44,44,44)
mainStroke.Thickness = 1
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = main



-- Avatar

local profile = Instance.new("ImageLabel")
profile.Size = UDim2.new(0,48,0,48)
profile.Position = UDim2.new(0,4,0,4)
profile.BackgroundTransparency = 1
profile.Parent = main



-- สี่เหลี่ยมมุมมน

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0,6)
profileCorner.Parent = profile



-- Text Area

local info = Instance.new("Frame")
info.Size = UDim2.new(0,95,0,48)
info.Position = UDim2.new(0,56,0,4)
info.BackgroundTransparency = 1
info.Parent = main


local function CreateText(y)

	local label = Instance.new("TextLabel")

	label.Size = UDim2.new(1,0,0,11)
	label.Position = UDim2.new(0,0,0,y)

	label.BackgroundTransparency = 1

	label.TextColor3 = Color3.fromRGB(220,220,220)
	label.Font = Enum.Font.Gotham
	label.TextSize = 9

	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd

	label.Parent = info

	return label
end



local nameText = CreateText(0)
local userText = CreateText(12)
local dateText = CreateText(24)
local timeText = CreateText(36)



-- โหลดรูป Avatar

task.spawn(function()

	local image, ready =
		Players:GetUserThumbnailAsync(
			player.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size100x100
		)

	if ready then
		profile.Image = image
	end

end)



nameText.Text = player.DisplayName
userText.Text = "@" .. player.Name


-- Real-time เวลา

local lastSecond = -1


RunService.RenderStepped:Connect(function()

	local t = os.date("*t")

	if t.sec ~= lastSecond then

		lastSecond = t.sec


		dateText.Text =
			string.format(
				"%02d/%02d/%04d",
				t.day,
				t.month,
				t.year
			)


		timeText.Text =
			string.format(
				"%02d:%02d:%02d",
				t.hour,
				t.min,
				t.sec
			)

	end

end)
