local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Theme = {
	Background = Color3.fromRGB(20, 30, 20),
	BackgroundDark = Color3.fromRGB(15, 22, 15),
	Option = Color3.fromRGB(30, 45, 30),
	Stroke = Color3.fromRGB(100, 200, 140),
	Text = Color3.fromRGB(240, 255, 245),
	TextDark = Color3.fromRGB(140, 200, 170),
	Font = Enum.Font.Code
}

local function Tween(obj, props, time)
	TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Linear), props):Play()
end

local function Make(class, props, parent)
	local obj = Instance.new(class)
	if props then
		for k,v in pairs(props) do
			obj[k] = v
		end
	end
	if parent then obj.Parent = parent end
	return obj
end

local function AddCorner(parent, radius)
	Make("UICorner", {CornerRadius = UDim.new(0, radius or 6)}, parent)
end

local function AddStroke(parent, color, thickness)
	Make("UIStroke", {
		Color = color or Theme.Stroke,
		Thickness = thickness or 1.5,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	}, parent)
end

local function AddGradient(parent, c0, c1, rotation)
	Make("UIGradient", {
		Rotation = rotation or 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, c0 or Color3.fromRGB(15,30,20)),
			ColorSequenceKeypoint.new(1, c1 or Color3.fromRGB(40,80,50))
		})
	}, parent)
end

local function AddPadding(parent, left, right, top, bottom)
	Make("UIPadding", {
		PaddingLeft = UDim.new(0, left or 8),
		PaddingRight = UDim.new(0, right or 8),
		PaddingTop = UDim.new(0, top or 8),
		PaddingBottom = UDim.new(0, bottom or 8)
	}, parent)
end

local function AddList(parent, padding)
	Make("UIListLayout", {
		Padding = UDim.new(0, padding or 5),
		SortOrder = Enum.SortOrder.LayoutOrder
	}, parent)
end

-- Notificações
local NotifGui = Make("ScreenGui", {Name = "LibNotifs", ResetOnSpawn = false})
pcall(function() NotifGui.Parent = CoreGui end)

local NotifHolder = Make("Frame", {
	Size = UDim2.new(0, 280, 1, 0),
	Position = UDim2.new(1, -290, 0, 0),
	BackgroundTransparency = 1
}, NotifGui)

AddList(NotifHolder, 8)
Make("UIPadding", {
	PaddingTop = UDim.new(0, 20),
	PaddingBottom = UDim.new(0, 20)
}, NotifHolder)

Make("UIListLayout", {
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder
}, NotifHolder)

function Library:Notify(config)
	local title = config.Title or "Notification"
	local text = config.Text or ""
	local duration = config.Duration or 5

	local notif = Make("Frame", {
		Size = UDim2.new(1, 0, 0, 70),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 0,
		ClipsDescendants = true
	}, NotifHolder)
	AddCorner(notif, 6)
	AddStroke(notif)
	AddGradient(notif)

	Make("TextLabel", {
		Size = UDim2.new(1, -10, 0, 25),
		Position = UDim2.new(0, 10, 0, 5),
		Text = title,
		Font = Theme.Font,
		TextSize = 16,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	}, notif)

	Make("TextLabel", {
		Size = UDim2.new(1, -10, 0, 30),
		Position = UDim2.new(0, 10, 0, 28),
		Text = text,
		Font = Theme.Font,
		TextSize = 13,
		TextColor3 = Theme.TextDark,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		BackgroundTransparency = 1
	}, notif)

	local bar = Make("Frame", {
		Size = UDim2.new(1, 0, 0, 2),
		Position = UDim2.new(0, 0, 1, -2),
		BackgroundColor3 = Theme.Stroke,
		BorderSizePixel = 0
	}, notif)
	AddCorner(bar, 2)

	Tween(bar, {Size = UDim2.new(0, 0, 0, 2)}, duration)

	task.delay(duration, function()
		Tween(notif, {BackgroundTransparency = 1}, 0.3)
		task.wait(0.3)
		notif:Destroy()
	end)
end

-- Window
function Library:CreateWindow(config)
	local title = config.Title or "Library"
	local size = config.Size or {500, 320}

	local ScreenGui = Make("ScreenGui", {
		Name = "LibGUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})
	pcall(function() ScreenGui.Parent = CoreGui end)

	-- Animação de abertura
	local AnimFrame = Make("Frame", {
		Size = UDim2.new(0, 0, 0, 40),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Theme.Background
	}, ScreenGui)
	AddCorner(AnimFrame, 6)
	AddStroke(AnimFrame)
	AddGradient(AnimFrame)

	local AnimLabel = Make("TextLabel", {
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		Text = title,
		Font = Theme.Font,
		TextSize = 16,
		TextColor3 = Theme.Text,
		TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	}, AnimFrame)

	-- Animação
	Tween(AnimFrame, {Size = UDim2.new(0, 200, 0, 40)}, 0.4)
	task.wait(0.4)
	Tween(AnimLabel, {TextTransparency = 0}, 0.3)
	task.wait(1)
	Tween(AnimLabel, {TextTransparency = 1}, 0.3)
	task.wait(0.3)
	AnimFrame:Destroy()

	-- Frame principal
	local Main = Make("Frame", {
		Size = UDim2.new(0, size[1], 0, size[2]),
		Position = UDim2.new(0.5, -size[1]/2, 0.5, -size[2]/2),
		BackgroundColor3 = Theme.Background,
		Active = true,
		Draggable = true,
		ClipsDescendants = true
	}, ScreenGui)
	AddCorner(Main, 6)
	AddStroke(Main)
	AddGradient(Main, Color3.fromRGB(15,30,20), Color3.fromRGB(40,80,50))

	-- TopBar
	local TopBar = Make("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Theme.BackgroundDark,
		BorderSizePixel = 0
	}, Main)
	AddCorner(TopBar, 6)

	-- Fix cantos inferiores da topbar
	Make("Frame", {
		Size = UDim2.new(1, 0, 0, 6),
		Position = UDim2.new(0, 0, 1, -6),
		BackgroundColor3 = Theme.BackgroundDark,
		BorderSizePixel = 0
	}, TopBar)

	Make("TextLabel", {
		Size = UDim2.new(1, -70, 1, 0),
		Position = UDim2.new(0, 15, 0, 0),
		Text = title,
		Font = Theme.Font,
		TextSize = 16,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	}, TopBar)

	-- Linha separadora
	Make("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 30),
		BackgroundColor3 = Theme.Stroke,
		BorderSizePixel = 0
	}, Main)

	-- Botão minimizar
	local minimized = false
	local MinBtn = Make("TextButton", {
		Size = UDim2.new(0, 28, 0, 22),
		Position = UDim2.new(1, -60, 0, 4),
		Text = "-",
		Font = Theme.Font,
		TextSize = 22,
		TextColor3 = Theme.Text,
		BackgroundTransparency = 1
	}, TopBar)

	-- Botão fechar
	local CloseBtn = Make("TextButton", {
		Size = UDim2.new(0, 28, 0, 22),
		Position = UDim2.new(1, -30, 0, 4),
		Text = "×",
		Font = Theme.Font,
		TextSize = 22,
		TextColor3 = Theme.Text,
		BackgroundTransparency = 1
	}, TopBar)

	CloseBtn.MouseButton1Click:Connect(function()
		Tween(Main, {Size = UDim2.new(0, size[1], 0, 0)}, 0.3)
		task.wait(0.3)
		ScreenGui:Destroy()
	end)

	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		MinBtn.Text = minimized and "+" or "-"
		if minimized then
			Tween(Main, {Size = UDim2.new(0, size[1], 0, 30)}, 0.2)
		else
			Tween(Main, {Size = UDim2.new(0, size[1], 0, size[2])}, 0.2)
		end
	end)

	-- Sidebar (tabs)
	local Sidebar = Make("ScrollingFrame", {
		Size = UDim2.new(0, 130, 1, -31),
		Position = UDim2.new(0, 0, 0, 31),
		BackgroundTransparency = 1,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Stroke,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0
	}, Main)
	AddPadding(Sidebar, 8, 8, 8, 8)
	AddList(Sidebar, 5)

	-- Linha vertical separadora
	Make("Frame", {
		Size = UDim2.new(0, 1, 1, -31),
		Position = UDim2.new(0, 130, 0, 31),
		BackgroundColor3 = Theme.Stroke,
		BorderSizePixel = 0
	}, Main)

	-- Container de conteúdo das tabs
	local Content = Make("Frame", {
		Size = UDim2.new(1, -131, 1, -31),
		Position = UDim2.new(0, 131, 0, 31),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}, Main)

	local Window = {}
	local tabs = {}
	local activeTab = nil

	function Window:CreateTab(tabConfig)
		local tabName = type(tabConfig) == "string" and tabConfig or tabConfig.Name or "Tab"

		local TabBtn = Make("TextButton", {
			Size = UDim2.new(1, 0, 0, 28),
			BackgroundColor3 = Theme.Option,
			Text = tabName,
			Font = Theme.Font,
			TextSize = 13,
			TextColor3 = Theme.TextDark,
			AutoButtonColor = false
		}, Sidebar)
		AddCorner(TabBtn, 5)
		AddStroke(TabBtn, Theme.Option)

		-- Container da tab
		local TabContent = Make("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Theme.Stroke,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			Visible = false
		}, Content)
		AddPadding(TabContent, 10, 10, 8, 8)
		AddList(TabContent, 6)

		local function Activate()
			for _, t in pairs(tabs) do
				t.content.Visible = false
				Tween(t.btn, {TextColor3 = Theme.TextDark}, 0.2)
				AddStroke(t.btn, Theme.Option)
			end
			TabContent.Visible = true
			Tween(TabBtn, {TextColor3 = Theme.Text}, 0.2)
		end

		local tabData = {btn = TabBtn, content = TabContent}
		table.insert(tabs, tabData)

		TabBtn.MouseButton1Click:Connect(Activate)

		if #tabs == 1 then
			Activate()
		end

		local Tab = {}

		-- Button
		function Tab:Button(cfg)
			local name = cfg.Name or "Button"
			local callback = cfg.Callback or function() end

			local btn = Make("TextButton", {
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = Theme.Option,
				Text = "",
				AutoButtonColor = false
			}, TabContent)
			AddCorner(btn, 5)
			AddStroke(btn)

			Make("TextLabel", {
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				Text = name,
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, btn)

			btn.MouseButton1Click:Connect(function()
				Tween(btn, {BackgroundColor3 = Theme.Stroke}, 0.1)
				task.wait(0.1)
				Tween(btn, {BackgroundColor3 = Theme.Option}, 0.1)
				callback()
			end)
		end

		-- Toggle
		function Tab:Toggle(cfg)
			local name = cfg.Name or "Toggle"
			local default = cfg.Default or false
			local callback = cfg.Callback or function() end

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = Theme.Option
			}, TabContent)
			AddCorner(frame, 5)
			AddStroke(frame)

			Make("TextLabel", {
				Size = UDim2.new(1, -50, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				Text = name,
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			local track = Make("Frame", {
				Size = UDim2.new(0, 34, 0, 18),
				Position = UDim2.new(1, -44, 0.5, -9),
				BackgroundColor3 = Theme.BackgroundDark
			}, frame)
			AddCorner(track, 9)
			AddStroke(track)

			local knob = Make("Frame", {
				Size = UDim2.new(0, 12, 0, 12),
				Position = UDim2.new(0, 3, 0.5, -6),
				BackgroundColor3 = Theme.TextDark
			}, track)
			AddCorner(knob, 6)

			local state = default

			local function Update(val)
				state = val
				if state then
					Tween(knob, {
						Position = UDim2.new(0, 19, 0.5, -6),
						BackgroundColor3 = Theme.Stroke
					}, 0.2)
					Tween(track, {BackgroundColor3 = Theme.Option}, 0.2)
				else
					Tween(knob, {
						Position = UDim2.new(0, 3, 0.5, -6),
						BackgroundColor3 = Theme.TextDark
					}, 0.2)
					Tween(track, {BackgroundColor3 = Theme.BackgroundDark}, 0.2)
				end
				callback(state)
			end

			Update(default)

			local btn = Make("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = ""
			}, frame)

			btn.MouseButton1Click:Connect(function()
				Update(not state)
			end)

			return {
				Set = function(_, val) Update(val) end,
				Get = function() return state end
			}
		end

		-- Slider
		function Tab:Slider(cfg)
			local name = cfg.Name or "Slider"
			local min = cfg.Min or 0
			local max = cfg.Max or 100
			local default = cfg.Default or min
			local callback = cfg.Callback or function() end

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 44),
				BackgroundColor3 = Theme.Option
			}, TabContent)
			AddCorner(frame, 5)
			AddStroke(frame)

			local label = Make("TextLabel", {
				Size = UDim2.new(1, -10, 0, 22),
				Position = UDim2.new(0, 10, 0, 0),
				Text = name,
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			local valLabel = Make("TextLabel", {
				Size = UDim2.new(0, 50, 0, 22),
				Position = UDim2.new(1, -58, 0, 0),
				Text = tostring(default),
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Stroke,
				TextXAlignment = Enum.TextXAlignment.Right,
				BackgroundTransparency = 1
			}, frame)

			local track = Make("Frame", {
				Size = UDim2.new(1, -20, 0, 6),
				Position = UDim2.new(0, 10, 0, 30),
				BackgroundColor3 = Theme.BackgroundDark
			}, frame)
			AddCorner(track, 3)

			local fill = Make("Frame", {
				Size = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = Theme.Stroke
			}, track)
			AddCorner(fill, 3)

			local knob = Make("Frame", {
				Size = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new(0, 0, 0.5, -7),
				BackgroundColor3 = Theme.Text
			}, track)
			AddCorner(knob, 7)

			local value = default
			local dragging = false

			local function SetValue(v)
				v = math.clamp(v, min, max)
				v = math.floor(v)
				value = v
				local pct = (v - min) / (max - min)
				Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
				Tween(knob, {Position = UDim2.new(pct, -7, 0.5, -7)}, 0.1)
				valLabel.Text = tostring(v)
				callback(v)
			end

			SetValue(default)

			local trackBtn = Make("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = ""
			}, track)

			trackBtn.MouseButton1Down:Connect(function()
				dragging = true
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
					SetValue(min + (max - min) * math.clamp(rel, 0, 1))
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			return {
				Set = function(_, v) SetValue(v) end,
				Get = function() return value end
			}
		end

		-- Dropdown
		function Tab:Dropdown(cfg)
			local name = cfg.Name or "Dropdown"
			local options = cfg.Options or {}
			local default = cfg.Default or options[1] or ""
			local callback = cfg.Callback or function() end

			local selected = default
			local open = false

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = Theme.Option,
				ClipsDescendants = true
			}, TabContent)
			AddCorner(frame, 5)
			AddStroke(frame)

			Make("TextLabel", {
				Size = UDim2.new(1, -100, 0, 32),
				Position = UDim2.new(0, 10, 0, 0),
				Text = name,
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			local selLabel = Make("TextLabel", {
				Size = UDim2.new(0, 90, 0, 32),
				Position = UDim2.new(1, -98, 0, 0),
				Text = selected,
				Font = Theme.Font,
				TextSize = 12,
				TextColor3 = Theme.Stroke,
				TextXAlignment = Enum.TextXAlignment.Right,
				BackgroundTransparency = 1
			}, frame)

			local arrow = Make("TextLabel", {
				Size = UDim2.new(0, 20, 0, 32),
				Position = UDim2.new(1, -22, 0, 0),
				Text = "▾",
				Font = Theme.Font,
				TextSize = 16,
				TextColor3 = Theme.Stroke,
				BackgroundTransparency = 1
			}, frame)

			local optHolder = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 32),
				BackgroundTransparency = 1
			}, frame)
			AddList(optHolder, 3)
			AddPadding(optHolder, 6, 6, 4, 4)

			for _, opt in ipairs(options) do
				local optBtn = Make("TextButton", {
					Size = UDim2.new(1, 0, 0, 24),
					BackgroundColor3 = Theme.BackgroundDark,
					Text = opt,
					Font = Theme.Font,
					TextSize = 12,
					TextColor3 = opt == selected and Theme.Text or Theme.TextDark,
					AutoButtonColor = false
				}, optHolder)
				AddCorner(optBtn, 4)

				optBtn.MouseButton1Click:Connect(function()
					selected = opt
					selLabel.Text = opt
					callback(opt)
					for _, c in ipairs(optHolder:GetChildren()) do
						if c:IsA("TextButton") then
							Tween(c, {TextColor3 = Theme.TextDark}, 0.15)
						end
					end
					Tween(optBtn, {TextColor3 = Theme.Text}, 0.15)
					open = false
					arrow.Text = "▾"
					Tween(frame, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
				end)
			end

			local totalH = 32 + (#options * 27) + 8
			local headerBtn = Make("TextButton", {
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundTransparency = 1,
				Text = ""
			}, frame)

			headerBtn.MouseButton1Click:Connect(function()
				open = not open
				if open then
					arrow.Text = "▴"
					Tween(frame, {Size = UDim2.new(1, 0, 0, totalH)}, 0.2)
				else
					arrow.Text = "▾"
					Tween(frame, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
				end
			end)

			return {
				Set = function(_, v)
					selected = v
					selLabel.Text = v
					callback(v)
				end,
				Get = function() return selected end
			}
		end

		-- TextBox
		function Tab:TextBox(cfg)
			local name = cfg.Name or "TextBox"
			local placeholder = cfg.Placeholder or "Enter text..."
			local default = cfg.Default or ""
			local callback = cfg.Callback or function() end

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = Theme.Option
			}, TabContent)
			AddCorner(frame, 5)
			AddStroke(frame)

			Make("TextLabel", {
				Size = UDim2.new(0.4, 0, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				Text = name,
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			local box = Make("TextBox", {
				Size = UDim2.new(0.55, 0, 0, 22),
				Position = UDim2.new(0.43, 0, 0.5, -11),
				BackgroundColor3 = Theme.BackgroundDark,
				Text = default,
				PlaceholderText = placeholder,
				Font = Theme.Font,
				TextSize = 12,
				TextColor3 = Theme.Text,
				PlaceholderColor3 = Theme.TextDark,
				ClearTextOnFocus = false
			}, frame)
			AddCorner(box, 4)
			AddStroke(box)

			box.FocusLost:Connect(function()
				callback(box.Text)
			end)

			return {
				Set = function(_, v) box.Text = v end,
				Get = function() return box.Text end
			}
		end

		-- Label
		function Tab:Label(cfg)
			local text = type(cfg) == "string" and cfg or cfg.Text or "Label"

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundColor3 = Theme.BackgroundDark
			}, TabContent)
			AddCorner(frame, 5)
			AddStroke(frame, Theme.Option)

			Make("TextLabel", {
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				Text = text,
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.TextDark,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)
		end

		-- Keybind
		function Tab:Keybind(cfg)
			local name = cfg.Name or "Keybind"
			local default = cfg.Default or Enum.KeyCode.F
			local callback = cfg.Callback or function() end

			local key = default
			local listening = false

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = Theme.Option
			}, TabContent)
			AddCorner(frame, 5)
			AddStroke(frame)

			Make("TextLabel", {
				Size = UDim2.new(1, -90, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				Text = name,
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			local keyBtn = Make("TextButton", {
				Size = UDim2.new(0, 70, 0, 22),
				Position = UDim2.new(1, -78, 0.5, -11),
				BackgroundColor3 = Theme.BackgroundDark,
				Text = tostring(key.Name),
				Font = Theme.Font,
				TextSize = 12,
				TextColor3 = Theme.Stroke,
				AutoButtonColor = false
			}, frame)
			AddCorner(keyBtn, 4)
			AddStroke(keyBtn)

			keyBtn.MouseButton1Click:Connect(function()
				listening = true
				keyBtn.Text = "..."
				keyBtn.TextColor3 = Theme.TextDark
			end)

			UserInputService.InputBegan:Connect(function(input, processed)
				if listening and input.UserInputType == Enum.UserInputType.Keyboard then
					key = input.KeyCode
					keyBtn.Text = tostring(key.Name)
					keyBtn.TextColor3 = Theme.Stroke
					listening = false
				elseif not processed and input.KeyCode == key then
					callback(key)
				end
			end)

			return {
				Get = function() return key end
			}
		end

		-- Separator
		function Tab:Separator(text)
			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 18),
				BackgroundTransparency = 1
			}, TabContent)

			Make("Frame", {
				Size = UDim2.new(0.35, 0, 0, 1),
				Position = UDim2.new(0, 0, 0.5, 0),
				BackgroundColor3 = Theme.Stroke,
				BorderSizePixel = 0
			}, frame)

			Make("TextLabel", {
				Size = UDim2.new(0.3, 0, 1, 0),
				Position = UDim2.new(0.35, 0, 0, 0),
				Text = text or "",
				Font = Theme.Font,
				TextSize = 11,
				TextColor3 = Theme.TextDark,
				BackgroundTransparency = 1
			}, frame)

			Make("Frame", {
				Size = UDim2.new(0.35, 0, 0, 1),
				Position = UDim2.new(0.65, 0, 0.5, 0),
				BackgroundColor3 = Theme.Stroke,
				BorderSizePixel = 0
			}, frame)
		end

		return Tab
	end

	return Window
end

return Library
