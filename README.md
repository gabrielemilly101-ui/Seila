local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Theme = {
	Background = Color3.fromRGB(8, 8, 8),
	BackgroundGrad = Color3.fromRGB(40, 80, 20),
	Sidebar = Color3.fromRGB(12, 12, 12),
	Element = Color3.fromRGB(18, 18, 18),
	ElementHover = Color3.fromRGB(25, 25, 25),
	Accent = Color3.fromRGB(80, 200, 80),
	AccentDark = Color3.fromRGB(40, 120, 40),
	Text = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(180, 180, 180),
	Font = Enum.Font.GothamBold,
	FontReg = Enum.Font.Gotham
}

local function Tween(obj, props, time)
	TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function Make(class, props, parent)
	local obj = Instance.new(class)
	if props then
		for k,v in pairs(props) do
			pcall(function() obj[k] = v end)
		end
	end
	if parent then obj.Parent = parent end
	return obj
end

local function Corner(p, r)
	Make("UICorner", {CornerRadius = UDim.new(0, r or 6)}, p)
end

local function Padding(p, l, r, t, b)
	Make("UIPadding", {
		PaddingLeft = UDim.new(0, l or 8),
		PaddingRight = UDim.new(0, r or 8),
		PaddingTop = UDim.new(0, t or 8),
		PaddingBottom = UDim.new(0, b or 8)
	}, p)
end

local function List(p, pad)
	Make("UIListLayout", {
		Padding = UDim.new(0, pad or 6),
		SortOrder = Enum.SortOrder.LayoutOrder
	}, p)
end

-- Notificações
local NotifGui = Make("ScreenGui", {
	Name = "LibNotifs",
	ResetOnSpawn = false,
	DisplayOrder = 999
})
pcall(function() NotifGui.Parent = CoreGui end)

local NotifHolder = Make("Frame", {
	Size = UDim2.new(0, 300, 1, 0),
	Position = UDim2.new(1, -310, 0, 0),
	BackgroundTransparency = 1
}, NotifGui)

Make("UIListLayout", {
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder
}, NotifHolder)

Make("UIPadding", {
	PaddingBottom = UDim.new(0, 20),
	PaddingRight = UDim.new(0, 10)
}, NotifHolder)

function Library:Notify(cfg)
	local title = cfg.Title or "Notification"
	local text = cfg.Text or ""
	local duration = cfg.Duration or 5

	local notif = Make("Frame", {
		Size = UDim2.new(1, 0, 0, 75),
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0,
		ClipsDescendants = true
	}, NotifHolder)
	Corner(notif, 8)

	-- Gradiente verde
	local grad = Make("UIGradient", {
		Rotation = 135,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(8,8,8)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20,50,20))
		})
	}, notif)

	-- Barra lateral verde
	Make("Frame", {
		Size = UDim2.new(0, 3, 1, 0),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0
	}, notif)

	Make("TextLabel", {
		Size = UDim2.new(1, -15, 0, 28),
		Position = UDim2.new(0, 12, 0, 5),
		Text = title,
		Font = Theme.Font,
		TextSize = 14,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	}, notif)

	Make("TextLabel", {
		Size = UDim2.new(1, -15, 0, 35),
		Position = UDim2.new(0, 12, 0, 32),
		Text = text,
		Font = Theme.FontReg,
		TextSize = 12,
		TextColor3 = Theme.TextDark,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		BackgroundTransparency = 1
	}, notif)

	-- Barra de progresso
	local bar = Make("Frame", {
		Size = UDim2.new(1, 0, 0, 2),
		Position = UDim2.new(0, 0, 1, -2),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0
	}, notif)

	Tween(bar, {Size = UDim2.new(0, 0, 0, 2)}, duration)

	task.delay(duration, function()
		Tween(notif, {BackgroundTransparency = 1}, 0.3)
		task.wait(0.35)
		notif:Destroy()
	end)
end

-- Window principal
function Library:CreateWindow(cfg)
	local title = cfg.Title or "Script"
	local subtitle = cfg.Subtitle or ""
	local W = cfg.Width or 580
	local H = cfg.Height or 400

	local SGui = Make("ScreenGui", {
		Name = "LibUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 100
	})
	pcall(function() SGui.Parent = CoreGui end)

	-- Animação de abertura
	local Anim = Make("Frame", {
		Size = UDim2.new(0, 0, 0, 38),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(8,8,8),
		ClipsDescendants = true
	}, SGui)
	Corner(Anim, 8)

	Make("UIGradient", {
		Rotation = 135,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(8,8,8)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(30,70,20))
		})
	}, Anim)

	local AnimTxt = Make("TextLabel", {
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 12, 0, 0),
		Text = title,
		Font = Theme.Font,
		TextSize = 16,
		TextColor3 = Theme.Text,
		TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	}, Anim)

	Tween(Anim, {Size = UDim2.new(0, 220, 0, 38)}, 0.5)
	task.wait(0.5)
	Tween(AnimTxt, {TextTransparency = 0}, 0.3)
	task.wait(1.2)
	Tween(AnimTxt, {TextTransparency = 1}, 0.25)
	task.wait(0.25)
	Tween(Anim, {Size = UDim2.new(0, 0, 0, 38)}, 0.4)
	task.wait(0.4)
	Anim:Destroy()

	-- Frame principal
	local Main = Make("Frame", {
		Size = UDim2.new(0, W, 0, H),
		Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
		BackgroundColor3 = Theme.Background,
		Active = true,
		Draggable = true,
		ClipsDescendants = true
	}, SGui)
	Corner(Main, 8)

	-- Gradiente fundo verde escuro
	Make("UIGradient", {
		Rotation = 135,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(8,8,8)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15,35,10)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(30,70,20))
		})
	}, Main)

	-- TopBar
	local TopBar = Make("Frame", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = Color3.fromRGB(5,5,5),
		BorderSizePixel = 0,
		ZIndex = 5
	}, Main)

	Make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(5,5,5)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(12,28,8))
		})
	}, TopBar)

	-- Fix cantos inferiores topbar
	Make("Frame", {
		Size = UDim2.new(1, 0, 0, 8),
		Position = UDim2.new(0, 0, 1, -8),
		BackgroundColor3 = Color3.fromRGB(5,5,5),
		BorderSizePixel = 0
	}, TopBar)

	-- Título
	Make("TextLabel", {
		Size = UDim2.new(1, -100, 1, 0),
		Position = UDim2.new(0, 14, 0, 0),
		Text = title .. (subtitle ~= "" and ("  |  " .. subtitle) or ""),
		Font = Theme.Font,
		TextSize = 13,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		ZIndex = 6
	}, TopBar)

	-- Botão minimizar
	local minimized = false
	local MinBtn = Make("TextButton", {
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -68, 0.5, -15),
		BackgroundTransparency = 1,
		Text = "─",
		Font = Theme.Font,
		TextSize = 16,
		TextColor3 = Theme.TextDark,
		ZIndex = 6
	}, TopBar)

	-- Botão fechar
	local CloseBtn = Make("TextButton", {
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -36, 0.5, -15),
		BackgroundTransparency = 1,
		Text = "✕",
		Font = Theme.Font,
		TextSize = 14,
		TextColor3 = Theme.TextDark,
		ZIndex = 6
	}, TopBar)

	CloseBtn.MouseEnter:Connect(function()
		Tween(CloseBtn, {TextColor3 = Color3.fromRGB(255,80,80)}, 0.15)
	end)
	CloseBtn.MouseLeave:Connect(function()
		Tween(CloseBtn, {TextColor3 = Theme.TextDark}, 0.15)
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		Tween(Main, {Size = UDim2.new(0, W, 0, 0)}, 0.3)
		task.wait(0.3)
		SGui:Destroy()
	end)

	MinBtn.MouseEnter:Connect(function()
		Tween(MinBtn, {TextColor3 = Theme.Accent}, 0.15)
	end)
	MinBtn.MouseLeave:Connect(function()
		Tween(MinBtn, {TextColor3 = Theme.TextDark}, 0.15)
	end)
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			Tween(Main, {Size = UDim2.new(0, W, 0, 38)}, 0.25)
		else
			Tween(Main, {Size = UDim2.new(0, W, 0, H)}, 0.25)
		end
	end)

	-- Linha separadora topbar
	Make("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 38),
		BackgroundColor3 = Theme.Accent,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0
	}, Main)

	-- Sidebar
	local Sidebar = Make("Frame", {
		Size = UDim2.new(0, 170, 1, -39),
		Position = UDim2.new(0, 0, 0, 39),
		BackgroundColor3 = Color3.fromRGB(6,6,6),
		BorderSizePixel = 0
	}, Main)

	Make("UIGradient", {
		Rotation = 180,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(6,6,6)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(10,22,8))
		})
	}, Sidebar)

	-- Linha separadora sidebar
	Make("Frame", {
		Size = UDim2.new(0, 1, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Theme.Accent,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0
	}, Sidebar)

	local SideScroll = Make("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0
	}, Sidebar)
	Padding(SideScroll, 10, 10, 10, 10)
	List(SideScroll, 5)

	-- Área de conteúdo
	local ContentArea = Make("Frame", {
		Size = UDim2.new(1, -171, 1, -39),
		Position = UDim2.new(0, 171, 0, 39),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}, Main)

	local Window = {}
	local allTabs = {}
	local activeTab = nil

	function Window:CreateTab(tabCfg)
		local tabName = type(tabCfg) == "string" and tabCfg or tabCfg.Name or "Tab"
		local tabIcon = type(tabCfg) == "table" and tabCfg.Icon or ""

		-- Botão da aba na sidebar
		local TabBtn = Make("TextButton", {
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundColor3 = Color3.fromRGB(14,14,14),
			Text = "",
			AutoButtonColor = false
		}, SideScroll)
		Corner(TabBtn, 6)

		-- Ícone
		if tabIcon ~= "" then
			Make("ImageLabel", {
				Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(0, 10, 0.5, -9),
				Image = tabIcon,
				BackgroundTransparency = 1,
				ImageColor3 = Theme.TextDark
			}, TabBtn)
		end

		Make("TextLabel", {
			Size = UDim2.new(1, tabIcon ~= "" and -36 or -10, 1, 0),
			Position = UDim2.new(0, tabIcon ~= "" and 34 or 12, 0, 0),
			Text = tabName,
			Font = Theme.FontReg,
			TextSize = 13,
			TextColor3 = Theme.TextDark,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1
		}, TabBtn)

		-- Indicador lateral ativo
		local indicator = Make("Frame", {
			Size = UDim2.new(0, 3, 0, 20),
			Position = UDim2.new(0, 0, 0.5, -10),
			BackgroundColor3 = Theme.Accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, TabBtn)
		Corner(indicator, 3)

		-- Container de conteúdo da aba
		local TabScroll = Make("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.Accent,
			ScrollBarImageTransparency = 0.5,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			Visible = false
		}, ContentArea)
		Padding(TabScroll, 12, 12, 10, 10)
		List(TabScroll, 6)

		local function Activate()
			-- Desativa todas as abas
			for _, t in pairs(allTabs) do
				t.scroll.Visible = false
				Tween(t.btn, {BackgroundColor3 = Color3.fromRGB(14,14,14)}, 0.2)
				if t.btn:FindFirstChildWhichIsA("TextLabel") then
					Tween(t.btn:FindFirstChildWhichIsA("TextLabel"), {TextColor3 = Theme.TextDark}, 0.2)
				end
				Tween(t.indicator, {BackgroundTransparency = 1}, 0.2)
			end
			-- Ativa esta aba
			TabScroll.Visible = true
			Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(22,22,22)}, 0.2)
			if TabBtn:FindFirstChildWhichIsA("TextLabel") then
				Tween(TabBtn:FindFirstChildWhichIsA("TextLabel"), {TextColor3 = Theme.Text}, 0.2)
			end
			Tween(indicator, {BackgroundTransparency = 0}, 0.2)
			activeTab = TabScroll
		end

		table.insert(allTabs, {btn = TabBtn, scroll = TabScroll, indicator = indicator})
		TabBtn.MouseButton1Click:Connect(Activate)

		if #allTabs == 1 then
			Activate()
		end

		local Tab = {}

		-- Seção
		function Tab:Section(name)
			Make("TextLabel", {
				Size = UDim2.new(1, 0, 0, 24),
				Text = name or "Section",
				Font = Theme.Font,
				TextSize = 11,
				TextColor3 = Theme.Accent,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, TabScroll)
		end

		-- Button
		function Tab:Button(btnCfg)
			local name = btnCfg.Name or "Button"
			local desc = btnCfg.Description or ""
			local callback = btnCfg.Callback or function() end

			local h = desc ~= "" and 52 or 36

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, h),
				BackgroundColor3 = Theme.Element
			}, TabScroll)
			Corner(frame, 6)

			Make("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,22)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,16))
				})
			}, frame)

			Make("TextLabel", {
				Size = UDim2.new(1, -50, 0, 36),
				Position = UDim2.new(0, 12, 0, 0),
				Text = name,
				Font = Theme.FontReg,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			if desc ~= "" then
				Make("TextLabel", {
					Size = UDim2.new(1, -14, 0, 16),
					Position = UDim2.new(0, 12, 0, 32),
					Text = desc,
					Font = Theme.FontReg,
					TextSize = 11,
					TextColor3 = Theme.TextDark,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1
				}, frame)
			end

			-- Seta direita
			Make("TextLabel", {
				Size = UDim2.new(0, 30, 1, 0),
				Position = UDim2.new(1, -36, 0, 0),
				Text = "›",
				Font = Theme.Font,
				TextSize = 22,
				TextColor3 = Theme.Accent,
				BackgroundTransparency = 1
			}, frame)

			local btn = Make("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = ""
			}, frame)

			btn.MouseEnter:Connect(function()
				Tween(frame, {BackgroundColor3 = Theme.ElementHover}, 0.15)
			end)
			btn.MouseLeave:Connect(function()
				Tween(frame, {BackgroundColor3 = Theme.Element}, 0.15)
			end)
			btn.MouseButton1Click:Connect(function()
				Tween(frame, {BackgroundColor3 = Color3.fromRGB(30,60,20)}, 0.1)
				task.wait(0.1)
				Tween(frame, {BackgroundColor3 = Theme.Element}, 0.15)
				callback()
			end)
		end

		-- Toggle
		function Tab:Toggle(togCfg)
			local name = togCfg.Name or "Toggle"
			local desc = togCfg.Description or ""
			local default = togCfg.Default or false
			local callback = togCfg.Callback or function() end

			local h = desc ~= "" and 52 or 36
			local state = default

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, h),
				BackgroundColor3 = Theme.Element
			}, TabScroll)
			Corner(frame, 6)

			Make("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,22)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,16))
				})
			}, frame)

			Make("TextLabel", {
				Size = UDim2.new(1, -60, 0, 36),
				Position = UDim2.new(0, 12, 0, 0),
				Text = name,
				Font = Theme.FontReg,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			if desc ~= "" then
				Make("TextLabel", {
					Size = UDim2.new(1, -14, 0, 16),
					Position = UDim2.new(0, 12, 0, 32),
					Text = desc,
					Font = Theme.FontReg,
					TextSize = 11,
					TextColor3 = Theme.TextDark,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1
				}, frame)
			end

			-- Toggle visual
			local track = Make("Frame", {
				Size = UDim2.new(0, 44, 0, 24),
				Position = UDim2.new(1, -54, 0.5, -12),
				BackgroundColor3 = Color3.fromRGB(35,35,35)
			}, frame)
			Corner(track, 12)

			local knob = Make("Frame", {
				Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(0, 3, 0.5, -9),
				BackgroundColor3 = Theme.TextDark
			}, track)
			Corner(knob, 9)

			local function Update(val)
				state = val
				if state then
					Tween(track, {BackgroundColor3 = Theme.AccentDark}, 0.2)
					Tween(knob, {
						Position = UDim2.new(0, 23, 0.5, -9),
						BackgroundColor3 = Theme.Accent
					}, 0.2)
				else
					Tween(track, {BackgroundColor3 = Color3.fromRGB(35,35,35)}, 0.2)
					Tween(knob, {
						Position = UDim2.new(0, 3, 0.5, -9),
						BackgroundColor3 = Theme.TextDark
					}, 0.2)
				end
				callback(state)
			end

			Update(default)

			local btn = Make("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = ""
			}, frame)

			btn.MouseEnter:Connect(function()
				Tween(frame, {BackgroundColor3 = Theme.ElementHover}, 0.15)
			end)
			btn.MouseLeave:Connect(function()
				Tween(frame, {BackgroundColor3 = Theme.Element}, 0.15)
			end)
			btn.MouseButton1Click:Connect(function()
				Update(not state)
			end)

			return {
				Set = function(_, v) Update(v) end,
				Get = function() return state end
			}
		end

		-- Slider
		function Tab:Slider(slCfg)
			local name = slCfg.Name or "Slider"
			local desc = slCfg.Description or ""
			local min = slCfg.Min or 0
			local max = slCfg.Max or 100
			local default = slCfg.Default or min
			local suffix = slCfg.Suffix or ""
			local callback = slCfg.Callback or function() end

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 54),
				BackgroundColor3 = Theme.Element
			}, TabScroll)
			Corner(frame, 6)

			Make("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,22)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,16))
				})
			}, frame)

			Make("TextLabel", {
				Size = UDim2.new(1, -80, 0, 28),
				Position = UDim2.new(0, 12, 0, 0),
				Text = name,
				Font = Theme.FontReg,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			local valLabel = Make("TextLabel", {
				Size = UDim2.new(0, 70, 0, 28),
				Position = UDim2.new(1, -80, 0, 0),
				Text = tostring(default) .. suffix,
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Accent,
				TextXAlignment = Enum.TextXAlignment.Right,
				BackgroundTransparency = 1
			}, frame)

			-- Fundo da barra
			local trackBg = Make("Frame", {
				Size = UDim2.new(1, -24, 0, 5),
				Position = UDim2.new(0, 12, 0, 38),
				BackgroundColor3 = Color3.fromRGB(40,40,40),
				BorderSizePixel = 0
			}, frame)
			Corner(trackBg, 3)

			-- Preenchimento
			local fill = Make("Frame", {
				Size = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = Theme.Accent,
				BorderSizePixel = 0
			}, trackBg)
			Corner(fill, 3)

			-- Knob
			local knob = Make("Frame", {
				Size = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new(0, -7, 0.5, -7),
				BackgroundColor3 = Theme.Text
			}, trackBg)
			Corner(knob, 7)

			local value = default
			local dragging = false

			local function SetValue(v)
				v = math.clamp(math.floor(v), min, max)
				value = v
				local pct = (v - min) / (max - min)
				Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.08)
				Tween(knob, {Position = UDim2.new(pct, -7, 0.5, -7)}, 0.08)
				valLabel.Text = tostring(v) .. suffix
				callback(v)
			end

			SetValue(default)

			local trackBtn = Make("TextButton", {
				Size = UDim2.new(1, 0, 3, 0),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Text = ""
			}, trackBg)

			trackBtn.MouseButton1Down:Connect(function()
				dragging = true
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local rel = (input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X
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
		function Tab:Dropdown(ddCfg)
			local name = ddCfg.Name or "Dropdown"
			local options = ddCfg.Options or {}
			local default = ddCfg.Default or (options[1] or "")
			local callback = ddCfg.Callback or function() end

			local selected = default
			local open = false

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = Theme.Element,
				ClipsDescendants = true
			}, TabScroll)
			Corner(frame, 6)

			Make("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,22)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,16))
				})
			}, frame)

			Make("TextLabel", {
				Size = UDim2.new(0.45, 0, 0, 36),
				Position = UDim2.new(0, 12, 0, 0),
				Text = name,
				Font = Theme.FontReg,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			-- Caixa de seleção (estilo da imagem)
			local selBox = Make("Frame", {
				Size = UDim2.new(0.42, 0, 0, 26),
				Position = UDim2.new(0.46, 0, 0.5, -13),
				BackgroundColor3 = Theme.AccentDark
			}, frame)
			Corner(selBox, 5)

			Make("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(50,120,50)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(30,80,30))
				})
			}, selBox)

			local selLabel = Make("TextLabel", {
				Size = UDim2.new(1, -30, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				Text = selected,
				Font = Theme.FontReg,
				TextSize = 12,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, selBox)

			local arrow = Make("TextLabel", {
				Size = UDim2.new(0, 24, 1, 0),
				Position = UDim2.new(1, -26, 0, 0),
				Text = "∧",
				Font = Theme.Font,
				TextSize = 12,
				TextColor3 = Theme.Text,
				BackgroundTransparency = 1
			}, selBox)

			-- Separador
			Make("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 0, 36),
				BackgroundColor3 = Theme.Accent,
				BackgroundTransparency = 0.7,
				BorderSizePixel = 0
			}, frame)

			-- Lista de opções
			local optHolder = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 37),
				BackgroundTransparency = 1
			}, frame)
			Padding(optHolder, 8, 8, 4, 4)
			List(optHolder, 4)

			for _, opt in ipairs(options) do
				local optBtn = Make("TextButton", {
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundColor3 = Color3.fromRGB(20,20,20),
					Text = "",
					AutoButtonColor = false
				}, optHolder)
				Corner(optBtn, 5)

				Make("TextLabel", {
					Size = UDim2.new(1, -16, 1, 0),
					Position = UDim2.new(0, 10, 0, 0),
					Text = opt,
					Font = Theme.FontReg,
					TextSize = 12,
					TextColor3 = opt == selected and Theme.Accent or Theme.TextDark,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1
				}, optBtn)

				optBtn.MouseEnter:Connect(function()
					Tween(optBtn, {BackgroundColor3 = Color3.fromRGB(30,30,30)}, 0.15)
				end)
				optBtn.MouseLeave:Connect(function()
					Tween(optBtn, {BackgroundColor3 = Color3.fromRGB(20,20,20)}, 0.15)
				end)

				optBtn.MouseButton1Click:Connect(function()
					selected = opt
					selLabel.Text = opt
					callback(opt)

					for _, c in ipairs(optHolder:GetChildren()) do
						if c:IsA("Frame") then
							local lbl = c:FindFirstChildWhichIsA("TextLabel")
							if lbl then
								Tween(lbl, {TextColor3 = Theme.TextDark}, 0.15)
							end
						end
					end

					local lbl = optBtn:FindFirstChildWhichIsA("TextLabel")
					if lbl then Tween(lbl, {TextColor3 = Theme.Accent}, 0.15) end

					open = false
					arrow.Text = "∧"
					Tween(frame, {Size = UDim2.new(1, 0, 0, 36)}, 0.25)
				end)
			end

			local totalH = 37 + (#options * 32) + 8
			local headerBtn = Make("TextButton", {
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundTransparency = 1,
				Text = ""
			}, frame)

			headerBtn.MouseButton1Click:Connect(function()
				open = not open
				if open then
					arrow.Text = "∨"
					Tween(frame, {Size = UDim2.new(1, 0, 0, totalH)}, 0.25)
				else
					arrow.Text = "∧"
					Tween(frame, {Size = UDim2.new(1, 0, 0, 36)}, 0.25)
				end
			end)

			return {
				Set = function(_, v)
					selected = v
					selLabel.Text = v
					callback(v)
				end,
				Get = function() return selected end,
				Refresh = function(_, newOpts)
					for _, c in ipairs(optHolder:GetChildren()) do
						if c:IsA("Frame") then c:Destroy() end
					end
					options = newOpts
					for _, opt in ipairs(options) do
						local optBtn = Make("Frame", {
							Size = UDim2.new(1, 0, 0, 28),
							BackgroundColor3 = Color3.fromRGB(20,20,20)
						}, optHolder)
						Corner(optBtn, 5)
						Make("TextLabel", {
							Size = UDim2.new(1, -16, 1, 0),
							Position = UDim2.new(0, 10, 0, 0),
							Text = opt,
							Font = Theme.FontReg,
							TextSize = 12,
							TextColor3 = Theme.TextDark,
							TextXAlignment = Enum.TextXAlignment.Left,
							BackgroundTransparency = 1
						}, optBtn)
					end
				end
			}
		end

		-- TextBox
		function Tab:TextBox(tbCfg)
			local name = tbCfg.Name or "TextBox"
			local placeholder = tbCfg.Placeholder or "Enter text..."
			local default = tbCfg.Default or ""
			local callback = tbCfg.Callback or function() end

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = Theme.Element
			}, TabScroll)
			Corner(frame, 6)

			Make("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,22)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,16))
				})
			}, frame)

			Make("TextLabel", {
				Size = UDim2.new(0.42, 0, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				Text = name,
				Font = Theme.FontReg,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			local box = Make("TextBox", {
				Size = UDim2.new(0.52, 0, 0, 24),
				Position = UDim2.new(0.46, 0, 0.5, -12),
				BackgroundColor3 = Color3.fromRGB(14,14,14),
				Text = default,
				PlaceholderText = placeholder,
				Font = Theme.FontReg,
				TextSize = 12,
				TextColor3 = Theme.Text,
				PlaceholderColor3 = Theme.TextDark,
				ClearTextOnFocus = false
			}, frame)
			Corner(box, 5)

			box.Focused:Connect(function()
				Make("UIStroke", {
					Color = Theme.Accent,
					Thickness = 1.5
				}, box)
			end)
			box.FocusLost:Connect(function()
				local s = box:FindFirstChildWhichIsA("UIStroke")
				if s then s:Destroy() end
				callback(box.Text)
			end)

			return {
				Set = function(_, v) box.Text = v end,
				Get = function() return box.Text end
			}
		end

		-- Keybind
		function Tab:Keybind(kbCfg)
			local name = kbCfg.Name or "Keybind"
			local default = kbCfg.Default or Enum.KeyCode.F
			local callback = kbCfg.Callback or function() end

			local key = default
			local listening = false

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = Theme.Element
			}, TabScroll)
			Corner(frame, 6)

			Make("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,22)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,16))
				})
			}, frame)

			Make("TextLabel", {
				Size = UDim2.new(1, -100, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				Text = name,
				Font = Theme.FontReg,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)

			local keyBox = Make("TextButton", {
				Size = UDim2.new(0, 80, 0, 24),
				Position = UDim2.new(1, -90, 0.5, -12),
				BackgroundColor3 = Color3.fromRGB(14,14,14),
				Text = tostring(key.Name),
				Font = Theme.Font,
				TextSize = 11,
				TextColor3 = Theme.Accent,
				AutoButtonColor = false
			}, frame)
			Corner(keyBox, 5)

			keyBox.MouseButton1Click:Connect(function()
				listening = true
				keyBox.Text = "..."
				keyBox.TextColor3 = Theme.TextDark
			end)

			UserInputService.InputBegan:Connect(function(input, gp)
				if listening and input.UserInputType == Enum.UserInputType.Keyboard then
					key = input.KeyCode
					keyBox.Text = tostring(key.Name)
					keyBox.TextColor3 = Theme.Accent
					listening = false
				elseif not gp and input.KeyCode == key then
					callback(key)
				end
			end)

			return {Get = function() return key end}
		end

		-- Label
		function Tab:Label(txt)
			local text = type(txt) == "string" and txt or txt.Text or "Label"

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = Color3.fromRGB(14,14,14)
			}, TabScroll)
			Corner(frame, 6)

			Make("TextLabel", {
				Size = UDim2.new(1, -16, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				Text = text,
				Font = Theme.FontReg,
				TextSize = 12,
				TextColor3 = Theme.TextDark,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}, frame)
		end

		-- Paragraph
		function Tab:Paragraph(pCfg)
			local title = pCfg.Title or ""
			local text = pCfg.Text or ""

			local frame = Make("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundColor3 = Color3.fromRGB(14,14,14),
				AutomaticSize = Enum.AutomaticSize.Y
			}, TabScroll)
			Corner(frame, 6)
			Padding(frame, 12, 12, 8, 8)
			List(frame, 4)

			if title ~= "" then
				Make("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20),
					Text = title,
					Font = Theme.Font,
					TextSize = 13,
					TextColor3 = Theme.Accent,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1
				}, frame)
			end

			Make("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = text,
				Font = Theme.FontReg,
				TextSize = 12,
				TextColor3 = Theme.TextDark,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				BackgroundTransparency = 1
			}, frame)
		end

		return Tab
	end

	-- Key System
	function Window:KeySystem(ksCfg)
		local keys = ksCfg.Keys or {}
		local title = ksCfg.Title or "Key System"
		local desc = ksCfg.Description or "Enter the key to continue."
		local link = ksCfg.Link or ""

		local verified = false

		local overlay = Make("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0,0,0),
			BackgroundTransparency = 0.4,
			ZIndex = 50
		}, SGui)

		local box = Make("Frame", {
			Size = UDim2.new(0, 360, 0, 180),
			Position = UDim2.new(0.5, -180, 0.5, -90),
			BackgroundColor3 = Color3.fromRGB(8,8,8),
			ZIndex = 51
		}, SGui)
		Corner(box, 8)

		Make("UIGradient", {
			Rotation = 135,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(8,8,8)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(20,50,15))
			})
		}, box)

		Make("Frame", {
			Size = UDim2.new(1, 0, 0, 3),
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel = 0,
			ZIndex = 52
		}, box)
		Corner(box, 8)

		Make("TextLabel", {
			Size = UDim2.new(1, -20, 0, 36),
			Position = UDim2.new(0, 12, 0, 8),
			Text = title,
			Font = Theme.Font,
			TextSize = 16,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			ZIndex = 52
		}, box)

		Make("TextLabel", {
			Size = UDim2.new(1, -20, 0, 28),
			Position = UDim2.new(0, 12, 0, 42),
			Text = desc,
			Font = Theme.FontReg,
			TextSize = 12,
			TextColor3 = Theme.TextDark,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			BackgroundTransparency = 1,
			ZIndex = 52
		}, box)

		local input = Make("TextBox", {
			Size = UDim2.new(1, -24, 0, 32),
			Position = UDim2.new(0, 12, 0, 90),
			BackgroundColor3 = Color3.fromRGB(18,18,18),
			Text = "",
			PlaceholderText = "Enter key here...",
			Font = Theme.FontReg,
			TextSize = 13,
			TextColor3 = Theme.Text,
			PlaceholderColor3 = Theme.TextDark,
			ClearTextOnFocus = false,
			ZIndex = 52
		}, box)
		Corner(input, 5)

		local confirmBtn = Make("TextButton", {
			Size = UDim2.new(0, 150, 0, 30),
			Position = UDim2.new(1, -162, 0, 138),
			BackgroundColor3 = Theme.AccentDark,
			Text = "Confirm",
			Font = Theme.Font,
			TextSize = 13,
			TextColor3 = Theme.Text,
			AutoButtonColor = false,
			ZIndex = 52
		}, box)
		Corner(confirmBtn, 5)

		if link ~= "" then
			local linkBtn = Make("TextButton", {
				Size = UDim2.new(0, 120, 0, 30),
				Position = UDim2.new(0, 12, 0, 138),
				BackgroundColor3 = Color3.fromRGB(20,20,20),
				Text = "Get Key",
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Accent,
				AutoButtonColor = false,
				ZIndex = 52
			}, box)
			Corner(linkBtn, 5)

			linkBtn.MouseButton1Click:Connect(function()
				setclipboard(link)
				linkBtn.Text = "Copied!"
				task.wait(2)
				linkBtn.Text = "Get Key"
			end)
		end

		confirmBtn.MouseButton1Click:Connect(function()
			local ok = false
			for _, k in ipairs(keys) do
				if input.Text == k then ok = true break end
			end
			if ok then
				Tween(box, {Size = UDim2.new(0, 360, 0, 0)}, 0.3)
				task.wait(0.3)
				box:Destroy()
				overlay:Destroy()
				verified = true
				Library:Notify({Title = "Key System", Text = "Key accepted!", Duration = 4})
			else
				Tween(input, {BackgroundColor3 = Color3.fromRGB(60,15,15)}, 0.1)
				task.wait(0.15)
				Tween(input, {BackgroundColor3 = Color3.fromRGB(18,18,18)}, 0.2)
				Library:Notify({Title = "Key System", Text = "Invalid key.", Duration = 3})
			end
		end)

		repeat task.wait() until verified
		return true
	end

	return Window
end

return Library
