
--// AYZEE on top

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("AYVEE CLIENT (ARSENAL)", "Midnight")

local speed = Window:NewTab("Player")
local rs = speed:NewSection("CFrame Speed")

rs:NewButton("CFrame Speed (Z)", "When clicked, you press Z to toggle the speed slider under.", function()
    repeat wait() until game:IsLoaded()
    local players = game:GetService('Players')
    local localPlayer = players.LocalPlayer
    repeat wait() until localPlayer.Character
    local userInputService = game:GetService('UserInputService')
    local runService = game:GetService('RunService')
    getgenv().Multiplier = 0.5
    local isActive = true
    userInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftBracket then
            getgenv().Multiplier = getgenv().Multiplier + 0.01
            print(getgenv().Multiplier)
            wait(0.2)
            while userInputService:IsKeyDown(Enum.KeyCode.LeftBracket) do
                wait()
                getgenv().Multiplier = getgenv().Multiplier + 0.01
                print(getgenv().Multiplier)
            end
        end
        if input.KeyCode == Enum.KeyCode.RightBracket then
            getgenv().Multiplier = getgenv().Multiplier - 0.01
            print(getgenv().Multiplier)
            wait(0.2)
            while userInputService:IsKeyDown(Enum.KeyCode.RightBracket) do
                wait()
                getgenv().Multiplier = getgenv().Multiplier - 0.01
                print(getgenv().Multiplier)
            end
        end
        if input.KeyCode == Enum.KeyCode.Z then
            isActive = not isActive
            if isActive then
                repeat
                    localPlayer.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame + localPlayer.Character.Humanoid.MoveDirection * getgenv().Multiplier
                    runService.Stepped:wait()
                until not isActive
            end
        end
    end)
end)

rs:NewSlider("CFrame Speed", "Slide to change the speed!", 5, 0, function(s)
    getgenv().Multiplier = s
end)

local rs1 = speed:NewSection("Infinite Jump")
rs1:NewToggle("Infinite jump!", "It is pretty self-explanatory.", function(state)
    if state then
        _G.infinjump = true
        if _G.infinJumpStarted == nil then
            _G.infinJumpStarted = false
            local player = game:GetService('Players').LocalPlayer
            local mouse = player:GetMouse()
            mouse.KeyDown:Connect(function(key)
                if _G.infinjump then
                    if key:byte() == 32 then 
                        local humanoid = player.Character:FindFirstChildOfClass('Humanoid')
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end
            end)
        end
    else
        _G.infinjump = false
    end
end)

local lsa = Window:NewTab("ESP/VISUALS")
local ESPs = lsa:NewSection("DIFFERENT ESPS")
ESPs:NewToggle("Name ESP", "Shows a nametag over everyone in-game!", function(state)
    if state then
        _G.FriendColor = Color3.fromRGB(0, 0, 255)
        _G.EnemyColor = Color3.fromRGB(255, 0, 0)
        _G.UseTeamColor = true

        local Holder = Instance.new("Folder", game.CoreGui)
        Holder.Name = "ESP"

        local Box = Instance.new("BoxHandleAdornment")
        Box.Name = "nilBox"
        Box.Size = Vector3.new(1, 2, 1)
        Box.Color3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
        Box.Transparency = 0.7
        Box.ZIndex = 0
        Box.AlwaysOnTop = false
        Box.Visible = false

        local NameTag = Instance.new("BillboardGui")
        NameTag.Name = "nilNameTag"
        NameTag.Enabled = false
        NameTag.Size = UDim2.new(0, 200, 0, 50)
        NameTag.AlwaysOnTop = true
        NameTag.StudsOffset = Vector3.new(0, 1.8, 0)
        local Tag = Instance.new("TextLabel", NameTag)
        Tag.Name = "Tag"
        Tag.BackgroundTransparency = 1
        Tag.Position = UDim2.new(0, -50, 0, 0)
        Tag.Size = UDim2.new(0, 300, 0, 20)
        Tag.TextSize = 15
        Tag.TextColor3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
        Tag.TextStrokeColor3 = Color3.new(0 / 255, 0 / 255, 0 / 255)
        Tag.TextStrokeTransparency = 0.4
        Tag.Text = "nil"
        Tag.Font = Enum.Font.SourceSansBold
        Tag.TextScaled = false

        local function LoadCharacter(v)
            repeat wait() until v.Character ~= nil
            v.Character:WaitForChild("Humanoid")
            local vHolder = Holder:FindFirstChild(v.Name)
            vHolder:ClearAllChildren()
            local b = Box:Clone()
            b.Name = v.Name .. "Box"
            b.Adornee = v.Character
            b.Parent = vHolder
            local t = NameTag:Clone()
            t.Name = v.Name .. "NameTag"
            t.Enabled = true
            t.Parent = vHolder
            t.Adornee = v.Character:WaitForChild("Head", 5)
            if not t.Adornee then
                return UnloadCharacter(v)
            end
            t.Tag.Text = v.Name
            b.Color3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
            t.Tag.TextColor3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
            local Update
            local function UpdateNameTag()
                if not pcall(function()
                    v.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                end) then
                    Update:Disconnect()
                end
            end
            UpdateNameTag()
            Update = v.Character.Humanoid.Changed:Connect(UpdateNameTag)
        end

        local function UnloadCharacter(v)
            local vHolder = Holder:FindFirstChild(v.Name)
            if vHolder then
                vHolder:ClearAllChildren()
            end
        end

        local function LoadPlayer(v)
            local vHolder = Instance.new("Folder", Holder)
            vHolder.Name = v.Name
            v.CharacterAdded:Connect(function()
                pcall(LoadCharacter, v)
            end)
            v.CharacterRemoving:Connect(function()
                pcall(UnloadCharacter, v)
            end)
            v.Changed:Connect(function(prop)
                if prop == "TeamColor" then
                    UnloadCharacter(v)
                    wait()
                    LoadCharacter(v)
                end
            end)
            LoadCharacter(v)
        end

        local function UnloadPlayer(v)
            UnloadCharacter(v)
            local vHolder = Holder:FindFirstChild(v.Name)
            if vHolder then
                vHolder:Destroy()
            end
        end

        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            spawn(function() pcall(LoadPlayer, v) end)
        end

        game:GetService("Players").PlayerAdded:Connect(function(v)
            pcall(LoadPlayer, v)
        end)

        game:GetService("Players").PlayerRemoving:Connect(function(v)
            pcall(UnloadPlayer, v)
        end)

        game:GetService("Players").LocalPlayer.NameDisplayDistance = 0

        if _G.Reantheajfdfjdgs then
            return
        end

        _G.Reantheajfdfjdgs = ":suifayhgvsdghfsfkajewfrhk321rk213kjrgkhj432rj34f67df"

        local players = game:GetService("Players")
        local plr = players.LocalPlayer

        local function esp(target, color)
            if target.Character then
                if not target.Character:FindFirstChild("GetReal") then
                    local highlight = Instance.new("Highlight")
                    highlight.RobloxLocked = true
                    highlight.Name = "GetReal"
                    highlight.Adornee = target.Character
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.FillColor = color
                    highlight.Parent = target.Character
                else
                    target.Character.GetReal.FillColor = color
                end
            end
        end

        while task.wait() do
            for i, v in pairs(players:GetPlayers()) do
                if v ~= plr then
                    esp(v, _G.UseTeamColor and v.TeamColor.Color or ((plr.TeamColor == v.TeamColor) and _G.FriendColor or _G.EnemyColor))
                end
            end
        end
    else
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            pcall(function()
                UnloadPlayer(v)
            end)
        end

        local holder = game.CoreGui:FindFirstChild("ESP")
        if holder then
            holder:Destroy()
        end

        if _G.Reantheajfdfjdgs then
            _G.Reantheajfdfjdgs = nil
        end
    end
end)


ESPs:NewToggle("Box ESP", "ToggleBoxESP", function(state)
    local camera = game.Workspace.CurrentCamera
    local Holder = Instance.new("Folder", game.CoreGui)
    Holder.Name = "ESP"

    local function CreateESP(v)
        local Top = Drawing.new("Line")
        Top.Visible = false
        Top.Color = Color3.fromRGB(255, 0, 0)
        Top.Thickness = 2

        local Bottom = Drawing.new("Line")
        Bottom.Visible = false
        Bottom.Color = Color3.fromRGB(255, 0, 0)
        Bottom.Thickness = 2

        local Left = Drawing.new("Line")
        Left.Visible = false
        Left.Color = Color3.fromRGB(255, 0, 0)
        Left.Thickness = 2

        local Right = Drawing.new("Line")
        Right.Visible = false
        Right.Color = Color3.fromRGB(255, 0, 0)
        Right.Thickness = 2

        local function UpdateESP()
            local connection
            connection = game:GetService("RunService").RenderStepped:Connect(function()
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Name ~= game.Players.LocalPlayer.Name then
                    local ScreenPos, OnScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if OnScreen then
                        local Scale = v.Character.Head.Size.Y / 2
                        local Size = Vector3.new(2, 3, 0) * (Scale * 2)
                        local TL = camera:WorldToViewportPoint((v.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, Size.Y, 0)).p)
                        local TR = camera:WorldToViewportPoint((v.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, Size.Y, 0)).p)
                        local BL = camera:WorldToViewportPoint((v.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, -Size.Y, 0)).p)
                        local BR = camera:WorldToViewportPoint((v.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).p)

                        Top.From = Vector2.new(TL.X, TL.Y)
                        Top.To = Vector2.new(TR.X, TR.Y)
                        Left.From = Vector2.new(TL.X, TL.Y)
                        Left.To = Vector2.new(BL.X, BL.Y)
                        Right.From = Vector2.new(TR.X, TR.Y)
                        Right.To = Vector2.new(BR.X, BR.Y)
                        Bottom.From = Vector2.new(BL.X, BL.Y)
                        Bottom.To = Vector2.new(BR.X, BR.Y)

                        local color = (v.TeamColor == game.Players.LocalPlayer.TeamColor) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                        Top.Color = color
                        Left.Color = color
                        Bottom.Color = color
                        Right.Color = color

                        Top.Visible = true
                        Left.Visible = true
                        Bottom.Visible = true
                        Right.Visible = true
                    else
                        Top.Visible = false
                        Left.Visible = false
                        Bottom.Visible = false
                        Right.Visible = false
                    end
                else
                    Top.Visible = false
                    Left.Visible = false
                    Bottom.Visible = false
                    Right.Visible = false
                end
            end)
            return connection
        end

        local connection = UpdateESP()

        local function RemoveESP()
            Top.Visible = false
            Bottom.Visible = false
            Left.Visible = false
            Right.Visible = false
            connection:Disconnect()
        end

        v.CharacterRemoving:Connect(RemoveESP)
        return RemoveESP
    end

    local function RemoveAllESPs()
        local playerESP = game.CoreGui:FindFirstChild("ESP")
        if playerESP then
            for _, esp in pairs(playerESP:GetChildren()) do
                if esp:IsA("Drawing") then
                    esp:Remove()
                end
            end
            playerESP:Destroy()
        end
    end

    if state then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then
                CreateESP(v)
            end
        end

        game.Players.PlayerAdded:Connect(function(v)
            if v ~= game.Players.LocalPlayer then
                CreateESP(v)
            end
        end)

        game.Players.PlayerRemoving:Connect(function(v)
            local esp = game.CoreGui:FindFirstChild("ESP") and game.CoreGui.ESP:FindFirstChild(v.Name)
            if esp then
                esp:Destroy()
            end
        end)
    else
        RemoveAllESPs()
    end
end)

local trace = lsa:NewSection("Tracers")

trace:NewToggle("Tracers", "Creates lines from you to every one in game!", function(state)
    if state then
           local function API_Check()
    if Drawing == nil then
        return "No"
    else
        return "Yes"
    end
end




local aimbotTab = Window:NewTab("Aimbot")
local softaim = aimbotTab:NewSection("SoftAim")


softaim:NewButton("Soft aim (FOV)", "Hold right click to function", function()
    local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false

_G.AimbotEnabled = true
_G.TeamCheck = false -- If set to true then the script would only lock your aim at enemy team members.
_G.AimPart = "Head" -- Where the aimbot script would lock at.
_G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.

_G.CircleSides = 64 -- How many sides the FOV circle would have.
_G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
_G.CircleTransparency = 0.7 -- Transparency of the circle.
_G.CircleRadius = 80 -- The radius of the circle / FOV.
_G.CircleFilled = false -- Determines whether or not the circle is filled.
_G.CircleVisible = true -- Determines whether or not the circle is visible.
_G.CircleThickness = 0 -- The thickness of the circle.

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function GetClosestPlayer()
	local MaximumDistance = _G.CircleRadius
	local Target = nil

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if _G.TeamCheck == true then
				if v.Team ~= LocalPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								
								if VectorDistance < MaximumDistance then
									Target = v
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
						if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							
							if VectorDistance < MaximumDistance then
								Target = v
							end
						end
					end
				end
			end
		end
	end

	return Target
end

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness

    if Holding == true and _G.AimbotEnabled == true then
        TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
    end
end)
end)


softaim:NewButton("Soft aim (NO FOV)", "Hold right click to function!", function()
   local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false

_G.AimbotEnabled = true
_G.TeamCheck = false -- If set to true then the script would only lock your aim at enemy team members.
_G.AimPart = "Head" -- Where the aimbot script would lock at.
_G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.

local function GetClosestPlayer()
	local MaximumDistance = math.huge
	local Target = nil
  
  	coroutine.wrap(function()
    		wait(20); MaximumDistance = math.huge -- Reset the MaximumDistance so that the Aimbot doesn't remember it as a very small variable and stop capturing players...
  	end)()

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if _G.TeamCheck == true then
				if v.Team ~= LocalPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								
								if VectorDistance < MaximumDistance then
									Target = v
                  							MaximumDistance = VectorDistance
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
						if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							
							if VectorDistance < MaximumDistance then
								Target = v
               							MaximumDistance = VectorDistance
							end
						end
					end
				end
			end
		end
	end

	return Target
end

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

RunService.RenderStepped:Connect(function()
    if Holding == true and _G.AimbotEnabled == true then
        TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
    end
end)
end)

local AimotTab1 = aimbotTab:NewSection("Aimbot (BANABLE)")

AimotTab1:NewButton("Aimbot (X)", "Hold X to lock onto the nearest enemy!", function()
    local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local userInputService = game:GetService("UserInputService")
local targetPart = nil
local isLockingOn = false

local function getNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local character = otherPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                
                if otherPlayer.Team ~= player.Team then
                    local distance = (camera.CFrame.Position - character.HumanoidRootPart.Position).magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function onInput(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.X then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            isLockingOn = true
        end
    end
end

local function onInputEnded(input)
    if input.KeyCode == Enum.KeyCode.X then
        isLockingOn = false
    end
end

userInputService.InputBegan:Connect(onInput)
userInputService.InputEnded:Connect(onInputEnded)

while true do
    if isLockingOn then
        local targetPlayer = getNearestPlayer()
        if targetPlayer then
            local character = targetPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, character.HumanoidRootPart.Position)
            end
        end
    end
    wait(0.00001) 
end

end)


local sr = speed:NewSection("No Clip")

sr:NewSlider("Distance", "How far do you want to no clip?", 25, 0, function(Value2) 
    print(Value2)
end)
sr:NewButton("No clip (C)", "Lets you go through walls when you press C!", function()
    local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

function onKeyPress(key)
    if key == "c" then
        local direction = humanoidRootPart.CFrame.LookVector
        local newPosition = humanoidRootPart.Position + direction * Value2
        humanoidRootPart.CFrame = CFrame.new(newPosition, newPosition + direction)
    end
end

mouse.KeyDown:Connect(onKeyPress)

end)


local Gun = Window:NewTab("Gun Mods")
local GunmodsSection = Gun:NewSection("> Overpower Gun <")


local SettingsInfinite = false
GunmodsSection:NewToggle("Infinite Ammo v2", "?", function(K)
    SettingsInfinite = K
    if SettingsInfinite then
        game:GetService("RunService").Stepped:connect(function()
            pcall(function()
                if SettingsInfinite then
                    local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
                    playerGui.GUI.Client.Variables.ammocount.Value = 99
                    playerGui.GUI.Client.Variables.ammocount2.Value = 99
                end
            end)
        end)
    end
end)

local originalValues = { -- saves/stores the original Values of the gun value :3
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

GunmodsSection:NewToggle("Fast Reload", "?", function(x)
    for _, v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
        if v:FindFirstChild("ReloadTime") then
            if x then
                if not originalValues.ReloadTime[v] then
                    originalValues.ReloadTime[v] = v.ReloadTime.Value
                end
                v.ReloadTime.Value = 0.01
            else
                if originalValues.ReloadTime[v] then
                    v.ReloadTime.Value = originalValues.ReloadTime[v]
                else
                    v.ReloadTime.Value = 0.8 
                end
            end
        end
        if v:FindFirstChild("EReloadTime") then
            if x then
                if not originalValues.EReloadTime[v] then
                    originalValues.EReloadTime[v] = v.EReloadTime.Value
                end
                v.EReloadTime.Value = 0.01
            else
                if originalValues.EReloadTime[v] then
                    v.EReloadTime.Value = originalValues.EReloadTime[v]
                else
                    v.EReloadTime.Value = 0.8 
                end
            end
        end
    end
end)

GunmodsSection:NewToggle("Fast Fire Rate", "?", function(state)
    for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
        if v.Name == "FireRate" or v.Name == "BFireRate" then
            if state then
                if not originalValues.FireRate[v] then
                    originalValues.FireRate[v] = v.Value
                end
                v.Value = 0.02
            else
                if originalValues.FireRate[v] then
                    v.Value = originalValues.FireRate[v]
                else
                    v.Value = 0.8 
                end
            end
        end
    end
end)

GunmodsSection:NewToggle("Always Auto", "?", function(state)
    for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
        if v.Name == "Auto" or v.Name == "AutoFire" or v.Name == "Automatic" or v.Name == "AutoShoot" or v.Name == "AutoGun" then
            if state then
                if not originalValues.Auto[v] then
                    originalValues.Auto[v] = v.Value
                end
                v.Value = true
            else
                if originalValues.Auto[v] then
                    v.Value = originalValues.Auto[v]
                else
                    v.Value = false 
                end
            end
        end
    end
end)

GunmodsSection:NewToggle("No Spread", "?", function(state)
    for _, v in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
        if v.Name == "MaxSpread" or v.Name == "Spread" or v.Name == "SpreadControl" then
            if state then
                if not originalValues.Spread[v] then
                    originalValues.Spread[v] = v.Value
                end
                v.Value = 0
            else
                if originalValues.Spread[v] then
                    v.Value = originalValues.Spread[v]
                else
                    v.Value = 1 
                end
            end
        end
    end
end)

GunmodsSection:NewToggle("No Recoil", "?", function(state)
    for _, v in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
        if v.Name == "RecoilControl" or v.Name == "Recoil" then
            if state then
                if not originalValues.Recoil[v] then
                    originalValues.Recoil[v] = v.Value
                end
                v.Value = 0
            else
                if originalValues.Recoil[v] then
                    v.Value = originalValues.Recoil[v]
                else
                    v.Value = 1 
                end
            end
        end
    end
end)

local autofarm2 = Window:NewTab("Auto Farm")

local autofarm3 = autofarm2:NewSection("Auto Farm (hold Lclick)")
autofarm3:NewToggle("AutoFarm", "?", function(bool) -- its really trash but it works man ok :<
    getgenv().AutoFarm = bool

    local runServiceConnection
    local mouseDown = false
    local player = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera

    game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = bool and "Infinite Ammo" or ""

    function getClosestEnemyPlayer()
        local closestDistance = math.huge
        local closestPlayer = nil

        for _, enemyPlayer in pairs(game.Players:GetPlayers()) do
            if enemyPlayer ~= player and enemyPlayer.TeamColor ~= player.TeamColor and enemyPlayer.Character then
                local character = enemyPlayer.Character
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoidRootPart and humanoid and humanoid.Health > 0 then
                    local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    if distance < closestDistance and humanoidRootPart.Position.Y >= 0 then
                        closestDistance = distance
                        closestPlayer = enemyPlayer
                    end
                end
            end
        end

        return closestPlayer
    end

    local function startAutoFarm()
        game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 12

        runServiceConnection = game:GetService("RunService").Stepped:Connect(function()
            if getgenv().AutoFarm then
                local closestPlayer = getClosestEnemyPlayer()
                if closestPlayer then
                    local targetPosition = closestPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 0, -4)
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                        camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character.Head.Position)

                        if not mouseDown then
                            mouse1press()
                            mouseDown = true
                        end
                    end
                else
                    if mouseDown then
                        mouse1release()
                        mouseDown = false
                    end
                end
            else
                if runServiceConnection then
                    runServiceConnection:Disconnect()
                    runServiceConnection = nil
                end
                if mouseDown then
                    mouse1release()
                    mouseDown = false
                end
            end
        end)
    end

    local function onCharacterAdded(character)
        wait(0.5)
        startAutoFarm()
    end

    player.CharacterAdded:Connect(onCharacterAdded)

    if bool then
        wait(0.5)
        startAutoFarm()
    else
        game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = ""
        getgenv().AutoFarm = false
        game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 1
        if runServiceConnection then
            runServiceConnection:Disconnect()
            runServiceConnection = nil
        end
        if mouseDown then
            mouse1release()
            mouseDown = false
        end
    end
end)



