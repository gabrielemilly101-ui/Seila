-- ============================================================
--                  MATRIX HUB LIBRARY v3.1
-- By @EmillyGabriel
-- Correções: GUI responsiva, ClipsDescendants, AddCodeBox,
--            chuva Matrix corrigida, AddParagraph dinâmico
-- ============================================================

local Configs_HUB = {
  Cor_Hub        = Color3.fromRGB(0, 0, 0),
  Cor_Options    = Color3.fromRGB(10, 10, 10),
  Cor_Stroke     = Color3.fromRGB(0, 255, 0),
  Cor_Text       = Color3.fromRGB(0, 255, 0),
  Cor_DarkText   = Color3.fromRGB(0, 200, 0),
  Corner_Radius  = UDim.new(0, 6),
  Text_Font      = Enum.Font.Code
}

local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local LocalPlayer  = Players.LocalPlayer
local PlayerName   = LocalPlayer.Name
local DisplayName  = LocalPlayer.DisplayName
local UserId       = LocalPlayer.UserId

-- Tamanho da tela para responsividade
local Camera   = workspace.CurrentCamera
local Viewport = Camera.ViewportSize

local Library = {}

-- ============================================================
--                     FUNÇÕES BASE
-- ============================================================
local function Create(instance, parent, props)
  local new = Instance.new(instance, parent)
  if props then
    for prop, value in pairs(props) do
      pcall(function() new[prop] = value end)
    end
  end
  return new
end

local function Corner(parent, radius)
  local c = Create("UICorner", parent)
  c.CornerRadius = radius or Configs_HUB.Corner_Radius
  return c
end

local function Stroke(parent, color, thickness)
  local s = Create("UIStroke", parent)
  s.Color            = color     or Configs_HUB.Cor_Stroke
  s.Thickness        = thickness or 1
  s.ApplyStrokeMode  = Enum.ApplyStrokeMode.Border
  return s
end

local function Tween(obj, props, time)
  TweenService:Create(
    obj,
    TweenInfo.new(time or 0.3, Enum.EasingStyle.Linear),
    props
  ):Play()
end

local function TweenWait(obj, props, time)
  local t = TweenService:Create(
    obj,
    TweenInfo.new(time or 0.3, Enum.EasingStyle.Linear),
    props
  )
  t:Play()
  t.Completed:Wait()
end

-- ============================================================
--                     SCREENGUI
-- ============================================================
if CoreGui:FindFirstChild("MatrixHub") then
  CoreGui:FindFirstChild("MatrixHub"):Destroy()
end

local ScreenGui = Create("ScreenGui", CoreGui, {
  Name            = "MatrixHub",
  ResetOnSpawn    = false,
  ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
})

-- ============================================================
--                  SISTEMA DE NOTIFICAÇÃO
-- ============================================================
local NotifHolder = Create("Frame", ScreenGui, {
  Size                = UDim2.new(0, 280, 1, 0),
  Position            = UDim2.new(1, 0, 0, 0),
  AnchorPoint         = Vector2.new(1, 0),
  BackgroundTransparency = 1,
  ZIndex              = 100
})
Create("UIPadding", NotifHolder, {
  PaddingRight  = UDim.new(0, 10),
  PaddingTop    = UDim.new(0, 10),
  PaddingBottom = UDim.new(0, 10)
})
Create("UIListLayout", NotifHolder, {
  Padding            = UDim.new(0, 8),
  VerticalAlignment  = Enum.VerticalAlignment.Bottom,
  SortOrder          = Enum.SortOrder.LayoutOrder
})

function Library:MakeNotifi(title, text, duration)
  duration = duration or 4

  local wrapper = Create("Frame", NotifHolder, {
    Size                   = UDim2.new(1, 0, 0, 70),
    BackgroundTransparency = 1,
    ClipsDescendants       = false
  })

  local box = Create("Frame", wrapper, {
    Size             = UDim2.new(1, 0, 1, 0),
    Position         = UDim2.new(1, 10, 0, 0),
    BackgroundColor3 = Color3.fromRGB(5, 5, 5),
    BorderSizePixel  = 0
  })
  Corner(box, UDim.new(0, 8))
  Stroke(box, Color3.fromRGB(0, 255, 0), 1)

  -- Barra lateral verde
  Create("Frame", box, {
    Size             = UDim2.new(0, 3, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 255, 0),
    BorderSizePixel  = 0,
    ZIndex           = 2
  })

  Create("TextLabel", box, {
    Size                 = UDim2.new(1, -15, 0, 20),
    Position             = UDim2.new(0, 10, 0, 8),
    Text                 = title,
    Font                 = Enum.Font.GothamBold,
    TextSize             = 13,
    TextColor3           = Color3.fromRGB(0, 255, 0),
    TextXAlignment       = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex               = 2
  })

  Create("TextLabel", box, {
    Size                   = UDim2.new(1, -15, 0, 30),
    Position               = UDim2.new(0, 10, 0, 28),
    Text                   = text,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 11,
    TextColor3             = Color3.fromRGB(0, 200, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    TextWrapped            = true,
    ZIndex                 = 2
  })

  local progressBg = Create("Frame", box, {
    Size             = UDim2.new(1, -6, 0, 2),
    Position         = UDim2.new(0, 3, 1, -3),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BorderSizePixel  = 0,
    ZIndex           = 2
  })
  local progressBar = Create("Frame", progressBg, {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 255, 0),
    BorderSizePixel  = 0,
    ZIndex           = 3
  })
  Corner(progressBg,  UDim.new(1, 0))
  Corner(progressBar, UDim.new(1, 0))

  TweenWait(box, {Position = UDim2.new(0, 0, 0, 0)}, 0.4)

  task.spawn(function()
    Tween(progressBar, {Size = UDim2.new(0, 0, 1, 0)}, duration)
    task.wait(duration)
    TweenWait(box, {Position = UDim2.new(1, 10, 0, 0)}, 0.4)
    wrapper:Destroy()
  end)
end

-- ============================================================
--              JANELA PRINCIPAL (RESPONSIVA)
-- ============================================================
local menuWidth  = math.min(520, Viewport.X - 20)
local menuHeight = math.min(300, Viewport.Y - 80)

local Menu = Create("Frame", ScreenGui, {
  Size             = UDim2.fromOffset(menuWidth, menuHeight),
  Position         = UDim2.fromScale(0.5, 0.5),
  AnchorPoint      = Vector2.new(0.5, 0.5),
  BackgroundColor3 = Color3.fromRGB(0, 0, 0),
  Active           = true,
  ClipsDescendants = true,
  ZIndex           = 1
})
Corner(Menu, UDim.new(0, 8))
Stroke(Menu, Color3.fromRGB(0, 255, 0), 1)

-- ============================================================
--                  SISTEMA DE ARRASTO
-- ============================================================
local dragging  = false
local dragInput, mousePos, framePos

Menu.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1
  or input.UserInputType == Enum.UserInputType.Touch then
    dragging  = true
    mousePos  = input.Position
    framePos  = Menu.Position
    input.Changed:Connect(function()
      if input.UserInputState == Enum.UserInputState.End then
        dragging = false
      end
    end)
  end
end)

Menu.InputChanged:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseMovement
  or input.UserInputType == Enum.UserInputType.Touch then
    dragInput = input
  end
end)

UserInputService.InputChanged:Connect(function(input)
  if input == dragInput and dragging then
    local delta = input.Position - mousePos
    Menu.Position = UDim2.new(
      framePos.X.Scale, framePos.X.Offset + delta.X,
      framePos.Y.Scale, framePos.Y.Offset + delta.Y
    )
  end
end)

-- ============================================================
--               FUNDO MATRIX OTIMIZADO
-- ============================================================
local MatrixBg = Create("Frame", Menu, {
  Size             = UDim2.new(1, 0, 1, 0),
  BackgroundColor3 = Color3.fromRGB(0, 0, 0),
  BorderSizePixel  = 0,
  ZIndex           = 1,
  ClipsDescendants = true
})

local binaryText = Create("TextLabel", MatrixBg, {
  Size                   = UDim2.new(1, 0, 1, 0),
  BackgroundTransparency = 1,
  Text = "010101 010201 010010 101011\n"
       .."010102 101010 210101 010101\n"
       .."001010 110101 021010 100101\n"
       .."010101 020102 001010 101101\n"
       .."010210 101010 100110 101001",
  Font             = Configs_HUB.Text_Font,
  TextSize         = 13,
  TextColor3       = Color3.fromRGB(0, 180, 0),
  TextTransparency = 0.88,
  ZIndex           = 1
})

local erroLabel = Create("TextLabel", MatrixBg, {
  Size                   = UDim2.new(1, 0, 0, 30),
  Position               = UDim2.new(0, 0, 0.5, -15),
  BackgroundTransparency = 1,
  Text                   = "[ERRO 010191] :: SYSTEM BREACH DETECTED",
  Font                   = Configs_HUB.Text_Font,
  TextSize               = 14,
  TextColor3             = Color3.fromRGB(0, 255, 0),
  TextTransparency       = 0.7,
  ZIndex                 = 1
})

-- CORREÇÃO: Tabela guarda objeto + velocidade separados
local rainChars  = {"0","1","2","3","A","B","C","D","E","F","#","@","$","%","&","*"}
local activeDrops = {}

RunService.RenderStepped:Connect(function(dt)
  for i = #activeDrops, 1, -1 do
    local data = activeDrops[i]
    local drop = data.Object

    if drop and drop.Parent then
      drop.Position = drop.Position + UDim2.fromOffset(0, data.Speed * dt)

      local bgBottom = MatrixBg.AbsolutePosition.Y + MatrixBg.AbsoluteSize.Y
      if drop.AbsolutePosition.Y > bgBottom then
        drop:Destroy()
        table.remove(activeDrops, i)
      end
    else
      table.remove(activeDrops, i)
    end
  end
end)

local function spawnRainColumn(x)
  task.spawn(function()
    while Menu and Menu.Parent do
      local drop = Create("TextLabel", MatrixBg, {
        Size                   = UDim2.fromOffset(14, 18),
        Position               = UDim2.new(x, 0, 0, -20),
        BackgroundTransparency = 1,
        Text                   = rainChars[math.random(1, #rainChars)],
        Font                   = Configs_HUB.Text_Font,
        TextSize               = 13,
        TextColor3             = Color3.fromRGB(0, 255, 0),
        TextTransparency       = 0.2,
        ZIndex                 = 1
      })
      -- CORREÇÃO: velocidade guardada na tabela, não na Instance
      table.insert(activeDrops, {Object = drop, Speed = math.random(80, 180)})
      task.wait(math.random(1, 3))
    end
  end)
end

for _ = 1, 25 do
  task.delay(math.random(0, 30) / 10, function()
    spawnRainColumn(math.random(0, 100) / 100)
  end)
end

task.spawn(function()
  while erroLabel and erroLabel.Parent do
    Tween(erroLabel, {TextTransparency = 0.4},  0.6); task.wait(0.7)
    Tween(erroLabel, {TextTransparency = 0.85}, 0.6); task.wait(0.7)
  end
end)

-- ============================================================
--                        TOPBAR
-- ============================================================
local TopBar = Create("Frame", Menu, {
  Size             = UDim2.new(1, 0, 0, 30),
  BackgroundColor3 = Color3.fromRGB(0, 10, 0),
  BorderSizePixel  = 0,
  ZIndex           = 5
})
-- Linha inferior da topbar
Create("Frame", TopBar, {
  Size             = UDim2.new(1, 0, 0, 1),
  Position         = UDim2.new(0, 0, 1, -1),
  BackgroundColor3 = Color3.fromRGB(0, 255, 0),
  BorderSizePixel  = 0,
  ZIndex           = 6
})
Create("TextLabel", TopBar, {
  Size                   = UDim2.new(1, -100, 1, 0),
  Position               = UDim2.new(0, 10, 0, 0),
  Text                   = "MatrixHub :: v3.1",
  Font                   = Configs_HUB.Text_Font,
  TextSize               = 14,
  TextColor3             = Color3.fromRGB(0, 255, 0),
  TextXAlignment         = Enum.TextXAlignment.Left,
  BackgroundTransparency = 1,
  ZIndex                 = 6
})

local MinBtn = Create("TextButton", TopBar, {
  Size             = UDim2.new(0, 30, 0, 25),
  Position         = UDim2.new(1, -65, 0, 2),
  Text             = "-",
  Font             = Enum.Font.GothamBold,
  TextSize         = 20,
  TextColor3       = Color3.fromRGB(0, 255, 0),
  BackgroundColor3 = Color3.fromRGB(0, 20, 0),
  ZIndex           = 6
})
Corner(MinBtn, UDim.new(0, 4))

local CloseBtn = Create("TextButton", TopBar, {
  Size             = UDim2.new(0, 30, 0, 25),
  Position         = UDim2.new(1, -32, 0, 2),
  Text             = "×",
  Font             = Enum.Font.GothamBold,
  TextSize         = 20,
  TextColor3       = Color3.fromRGB(255, 0, 0),
  BackgroundColor3 = Color3.fromRGB(20, 0, 0),
  ZIndex           = 6
})
Corner(CloseBtn, UDim.new(0, 4))

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
  if not minimized then
    minimized = true
    MinBtn.Text = "+"
    TweenWait(Menu, {Size = UDim2.fromOffset(menuWidth, 30)}, 0.3)
  else
    minimized = false
    MinBtn.Text = "-"
    TweenWait(Menu, {Size = UDim2.fromOffset(menuWidth, menuHeight)}, 0.3)
  end
end)

CloseBtn.MouseButton1Click:Connect(function()
  TweenWait(Menu, {Size = UDim2.fromOffset(0, 0)}, 0.4)
  ScreenGui:Destroy()
end)

-- ============================================================
--                   SIDEBAR (PLAYER CARD)
-- ============================================================
local sideWidth = math.min(150, menuWidth * 0.29)

local PlayerCard = Create("Frame", Menu, {
  Size             = UDim2.new(0, sideWidth, 1, -31),
  Position         = UDim2.new(0, 0, 0, 31),
  BackgroundColor3 = Color3.fromRGB(0, 8, 0),
  BorderSizePixel  = 0,
  ClipsDescendants = true,
  ZIndex           = 5
})
-- Linha divisória lateral
Create("Frame", PlayerCard, {
  Size             = UDim2.new(0, 1, 1, 0),
  Position         = UDim2.new(1, 0, 0, 0),
  BackgroundColor3 = Color3.fromRGB(0, 255, 0),
  BorderSizePixel  = 0,
  ZIndex           = 6
})

-- Avatar
local PlayerThumb = Players:GetUserThumbnailAsync(
  UserId,
  Enum.ThumbnailType.HeadShot,
  Enum.ThumbnailSize.Size420x420
)

local AvatarFrame = Create("Frame", PlayerCard, {
  Size             = UDim2.fromOffset(70, 70),
  Position         = UDim2.new(0.5, -35, 0, 14),
  BackgroundColor3 = Color3.fromRGB(0, 30, 0),
  ZIndex           = 6
})
Corner(AvatarFrame, UDim.new(1, 0))
Stroke(AvatarFrame, Color3.fromRGB(0, 255, 0), 2)

local AvatarImg = Create("ImageLabel", AvatarFrame, {
  Size                   = UDim2.new(1, -4, 1, -4),
  Position               = UDim2.new(0, 2, 0, 2),
  Image                  = PlayerThumb,
  BackgroundTransparency = 1,
  ZIndex                 = 7
})
Corner(AvatarImg, UDim.new(1, 0))

-- Status piscando
local statusDot = Create("Frame", AvatarFrame, {
  Size             = UDim2.fromOffset(12, 12),
  Position         = UDim2.new(1, -13, 1, -13),
  BackgroundColor3 = Color3.fromRGB(0, 255, 0),
  ZIndex           = 8
})
Corner(statusDot, UDim.new(1, 0))
task.spawn(function()
  while statusDot and statusDot.Parent do
    Tween(statusDot, {BackgroundTransparency = 0.7}, 0.8); task.wait(0.9)
    Tween(statusDot, {BackgroundTransparency = 0},   0.8); task.wait(0.9)
  end
end)

Create("TextLabel", PlayerCard, {
  Size                   = UDim2.new(1, -6, 0, 18),
  Position               = UDim2.new(0, 3, 0, 88),
  Text                   = DisplayName,
  Font                   = Enum.Font.GothamBold,
  TextSize               = 12,
  TextColor3             = Color3.fromRGB(0, 255, 0),
  BackgroundTransparency = 1,
  TextScaled             = false,
  TextWrapped            = true,
  ZIndex                 = 6
})

Create("TextLabel", PlayerCard, {
  Size                   = UDim2.new(1, -6, 0, 14),
  Position               = UDim2.new(0, 3, 0, 107),
  Text                   = "@"..PlayerName,
  Font                   = Configs_HUB.Text_Font,
  TextSize               = 10,
  TextColor3             = Color3.fromRGB(0, 180, 0),
  BackgroundTransparency = 1,
  TextWrapped            = true,
  ZIndex                 = 6
})

-- Separador
Create("Frame", PlayerCard, {
  Size                   = UDim2.new(0.85, 0, 0, 1),
  Position               = UDim2.new(0.075, 0, 0, 126),
  BackgroundColor3       = Color3.fromRGB(0, 255, 0),
  BackgroundTransparency = 0.7,
  BorderSizePixel        = 0,
  ZIndex                 = 6
})

-- Lista de abas
local tabsHolder = Create("ScrollingFrame", PlayerCard, {
  Size                   = UDim2.new(1, -8, 1, -134),
  Position               = UDim2.new(0, 4, 0, 132),
  BackgroundTransparency = 1,
  CanvasSize             = UDim2.new(),
  AutomaticCanvasSize    = Enum.AutomaticSize.Y,
  ScrollBarThickness     = 2,
  ScrollBarImageColor3   = Color3.fromRGB(0, 255, 0),
  ClipsDescendants       = true,
  ZIndex                 = 6
})
Create("UIListLayout", tabsHolder, {
  Padding   = UDim.new(0, 4),
  SortOrder = Enum.SortOrder.LayoutOrder
})

-- ============================================================
--                    ÁREA DE CONTEÚDO
-- ============================================================
local contentX = sideWidth + 2

local ContentArea = Create("Frame", Menu, {
  Size                   = UDim2.new(1, -(contentX + 2), 1, -32),
  Position               = UDim2.new(0, contentX, 0, 31),
  BackgroundTransparency = 1,
  ClipsDescendants       = true,   -- CORREÇÃO: corta qualquer overflow
  ZIndex                 = 5
})

local tabIndex = 0

-- ============================================================
--                      API DA LIBRARY
-- ============================================================

function Library:MakeWindow()
  return Menu
end

function Library:MinimizeButton()
  return MinBtn
end

-- ----------------------------------------------------------------
function Library:MakeTab(name, icon)
  tabIndex = tabIndex + 1
  local idx = tabIndex
  icon = icon or ">>"

  local tabBtn = Create("TextButton", tabsHolder, {
    Size             = UDim2.new(1, 0, 0, 26),
    BackgroundColor3 = Color3.fromRGB(0, 15, 0),
    Text             = "",
    AutoButtonColor  = false,
    ZIndex           = 7,
    LayoutOrder      = idx
  })
  Corner(tabBtn, UDim.new(0, 4))

  Create("TextLabel", tabBtn, {
    Size                   = UDim2.new(0, 20, 1, 0),
    Position               = UDim2.new(0, 3, 0, 0),
    Text                   = icon,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 11,
    TextColor3             = Color3.fromRGB(0, 180, 0),
    BackgroundTransparency = 1,
    ZIndex                 = 8
  })
  Create("TextLabel", tabBtn, {
    Size                   = UDim2.new(1, -25, 1, 0),
    Position               = UDim2.new(0, 24, 0, 0),
    Text                   = name,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 10,
    TextColor3             = Color3.fromRGB(0, 200, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 8
  })

  -- Container de conteúdo da aba
  local container = Create("ScrollingFrame", ContentArea, {
    Size                 = UDim2.new(1, -8, 1, -8),
    Position             = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
    CanvasSize           = UDim2.new(),
    AutomaticCanvasSize  = Enum.AutomaticSize.Y,
    ScrollBarThickness   = 3,
    ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0),
    ScrollingDirection   = Enum.ScrollingDirection.Y,
    ClipsDescendants     = true,   -- CORREÇÃO PRINCIPAL
    Visible              = idx == 1,
    ZIndex               = 5
  })
  Create("UIListLayout", container, {
    Padding   = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
  })

  if idx == 1 then
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 35, 0)
    Stroke(tabBtn, Color3.fromRGB(0, 255, 0), 1)
  end

  tabBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(ContentArea:GetChildren()) do
      if c:IsA("ScrollingFrame") then c.Visible = false end
    end
    for _, b in ipairs(tabsHolder:GetChildren()) do
      if b:IsA("TextButton") then
        b.BackgroundColor3 = Color3.fromRGB(0, 15, 0)
        local st = b:FindFirstChildOfClass("UIStroke")
        if st then st:Destroy() end
      end
    end
    container.Visible       = true
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 35, 0)
    Stroke(tabBtn, Color3.fromRGB(0, 255, 0), 1)
  end)

  return container
end

-- ----------------------------------------------------------------
function Library:AddSection(parent, text)
  local btn = Create("TextButton", parent, {
    Size                   = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 6
  })
  Create("TextLabel", btn, {
    Size                   = UDim2.new(1, -10, 1, 0),
    Position               = UDim2.new(0, 10, 0, 0),
    Text                   = ">> "..text,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 11,
    TextColor3             = Color3.fromRGB(0, 180, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })
  Create("Frame", btn, {
    Size                   = UDim2.new(1, -10, 0, 1),
    Position               = UDim2.new(0, 10, 1, -1),
    BackgroundColor3       = Color3.fromRGB(0, 255, 0),
    BackgroundTransparency = 0.7,
    BorderSizePixel        = 0,
    ZIndex                 = 7
  })
  return btn
end

-- ----------------------------------------------------------------
function Library:AddTextLabel(parent, text)
  local btn = Create("TextButton", parent, {
    Size             = UDim2.new(1, 0, 0, 28),
    BackgroundColor3 = Color3.fromRGB(0, 8, 0),
    Text             = "",
    ZIndex           = 6
  })
  Corner(btn, UDim.new(0, 4))
  Create("TextLabel", btn, {
    Size                   = UDim2.new(1, -10, 1, 0),
    Position               = UDim2.new(0, 10, 0, 0),
    Text                   = text,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 11,
    TextColor3             = Color3.fromRGB(0, 180, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    TextWrapped            = true,
    ZIndex                 = 7
  })
  return btn
end

-- ----------------------------------------------------------------
function Library:AddToggle(parent, name, default, callback)
  local state = {Value = default or false}

  local frame = Create("Frame", parent, {
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(0, 12, 0),
    ZIndex           = 6
  })
  Corner(frame, UDim.new(0, 4))
  local st = Stroke(frame, Color3.fromRGB(0, 100, 0), 1)

  Create("TextLabel", frame, {
    Size                   = UDim2.new(1, -60, 1, 0),
    Position               = UDim2.new(0, 10, 0, 0),
    Text                   = name,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 220, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  local tBg = Create("Frame", frame, {
    Size             = UDim2.fromOffset(40, 18),
    Position         = UDim2.new(1, -48, 0.5, -9),
    BackgroundColor3 = state.Value
      and Color3.fromRGB(0, 100, 0)
      or  Color3.fromRGB(20, 20, 20),
    ZIndex           = 7
  })
  Corner(tBg, UDim.new(1, 0))

  local dot = Create("Frame", tBg, {
    Size             = UDim2.fromOffset(14, 14),
    Position         = state.Value
      and UDim2.new(1, -16, 0.5, -7)
      or  UDim2.new(0,   2, 0.5, -7),
    BackgroundColor3 = Color3.fromRGB(0, 255, 0),
    ZIndex           = 8
  })
  Corner(dot, UDim.new(1, 0))

  local click = Create("TextButton", frame, {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 9
  })

  click.MouseButton1Click:Connect(function()
    state.Value = not state.Value
    if state.Value then
      Tween(tBg,  {BackgroundColor3 = Color3.fromRGB(0, 100, 0)},       0.2)
      Tween(dot,  {Position = UDim2.new(1, -16, 0.5, -7)},              0.2)
    else
      Tween(tBg,  {BackgroundColor3 = Color3.fromRGB(20, 20, 20)},      0.2)
      Tween(dot,  {Position = UDim2.new(0,   2, 0.5, -7)},              0.2)
    end
    if callback then callback(state.Value) end
  end)

  if callback then callback(state.Value) end
  return {Frame2 = frame, Stroke = st, OnOff = state, Callback = callback}
end

-- ----------------------------------------------------------------
function Library:AddButton(parent, name, callback)
  local btn = Create("TextButton", parent, {
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(0, 12, 0),
    Text             = "",
    AutoButtonColor  = false,
    ZIndex           = 6
  })
  Corner(btn, UDim.new(0, 4))
  Stroke(btn, Color3.fromRGB(0, 100, 0), 1)

  Create("TextLabel", btn, {
    Size                   = UDim2.new(1, -40, 1, 0),
    Position               = UDim2.new(0, 35, 0, 0),
    Text                   = name,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 220, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })
  Create("TextLabel", btn, {
    Size                   = UDim2.fromOffset(30, 30),
    Position               = UDim2.new(0, 5, 0, 0),
    Text                   = "[>]",
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 255, 0),
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  btn.MouseEnter:Connect(function()
    Tween(btn, {BackgroundColor3 = Color3.fromRGB(0, 25, 0)}, 0.2)
  end)
  btn.MouseLeave:Connect(function()
    Tween(btn, {BackgroundColor3 = Color3.fromRGB(0, 12, 0)}, 0.2)
  end)
  btn.MouseButton1Click:Connect(function()
    Tween(btn, {BackgroundColor3 = Color3.fromRGB(0, 40, 0)}, 0.1)
    task.wait(0.1)
    Tween(btn, {BackgroundColor3 = Color3.fromRGB(0, 12, 0)}, 0.2)
    if callback then callback() end
  end)
end

-- ----------------------------------------------------------------
function Library:AddSlider(parent, name, min, max, default, callback)
  local val   = default or min
  local frame = Create("Frame", parent, {
    Size             = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = Color3.fromRGB(0, 12, 0),
    ZIndex           = 6
  })
  Corner(frame, UDim.new(0, 4))
  Stroke(frame, Color3.fromRGB(0, 100, 0), 1)

  Create("TextLabel", frame, {
    Size                   = UDim2.new(1, -50, 0, 20),
    Position               = UDim2.new(0, 10, 0, 2),
    Text                   = name,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 220, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  local vLbl = Create("TextLabel", frame, {
    Size                   = UDim2.fromOffset(45, 20),
    Position               = UDim2.new(1, -50, 0, 2),
    Text                   = tostring(val),
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 255, 0),
    TextXAlignment         = Enum.TextXAlignment.Right,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  local sBg = Create("Frame", frame, {
    Size             = UDim2.new(1, -20, 0, 6),
    Position         = UDim2.new(0, 10, 0, 32),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    ZIndex           = 7
  })
  Corner(sBg, UDim.new(1, 0))

  local p    = (val - min) / (max - min)
  local fill = Create("Frame", sBg, {
    Size             = UDim2.new(p, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 255, 0),
    ZIndex           = 8
  })
  Corner(fill, UDim.new(1, 0))

  local sBtn = Create("TextButton", frame, {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 10
  })

  local sliderDragging = false

  local function update(ix)
    local abs = sBg.AbsolutePosition.X
    local w   = sBg.AbsoluteSize.X
    local np  = math.clamp((ix - abs) / w, 0, 1)
    val       = math.floor(min + (max - min) * np)
    vLbl.Text = tostring(val)
    fill.Size = UDim2.new(np, 0, 1, 0)
    if callback then callback(val) end
  end

  sBtn.MouseButton1Down:Connect(function()
    sliderDragging = true
    update(UserInputService:GetMouseLocation().X)
  end)
  UserInputService.InputChanged:Connect(function(i)
    if sliderDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
      update(i.Position.X)
    end
  end)
  UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
      sliderDragging = false
    end
  end)

  local api = {Slider = frame, Max = max, Min = min}
  function api.Increase(amount)
    update(
      sBg.AbsolutePosition.X +
      sBg.AbsoluteSize.X * (((val + amount) - min) / (max - min))
    )
  end
  return api
end

-- ----------------------------------------------------------------
function Library:AddTextBox(parent, name, default, callback)
  local frame = Create("Frame", parent, {
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(0, 12, 0),
    ZIndex           = 6
  })
  Corner(frame, UDim.new(0, 4))
  Stroke(frame, Color3.fromRGB(0, 100, 0), 1)

  Create("TextLabel", frame, {
    Size                   = UDim2.new(0, 100, 1, 0),
    Position               = UDim2.new(0, 10, 0, 0),
    Text                   = name,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 220, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  local box = Create("TextBox", frame, {
    Size               = UDim2.new(1, -120, 1, -8),
    Position           = UDim2.new(0, 110, 0, 4),
    Text               = default or "",
    PlaceholderText    = "Digite...",
    Font               = Configs_HUB.Text_Font,
    TextSize           = 12,
    TextColor3         = Color3.fromRGB(255, 255, 255),
    BackgroundColor3   = Color3.fromRGB(10, 10, 10),
    ClearTextOnFocus   = false,
    ZIndex             = 7
  })
  Corner(box, UDim.new(0, 4))

  box.FocusLost:Connect(function(enter)
    if callback then callback(box.Text, enter) end
  end)
end

-- ----------------------------------------------------------------
-- NOVO: AddCodeBox — para colar scripts grandes (multilinha)
function Library:AddCodeBox(parent, label, placeholder, callback)
  local frame = Create("Frame", parent, {
    Size             = UDim2.new(1, 0, 0, 160),
    BackgroundColor3 = Color3.fromRGB(0, 8, 0),
    ZIndex           = 6
  })
  Corner(frame, UDim.new(0, 4))
  Stroke(frame, Color3.fromRGB(0, 150, 0), 1)

  -- Cabeçalho
  Create("TextLabel", frame, {
    Size                   = UDim2.new(1, -10, 0, 20),
    Position               = UDim2.new(0, 8, 0, 4),
    Text                   = ">> "..label,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 11,
    TextColor3             = Color3.fromRGB(0, 200, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  -- Área de scroll para o TextBox
  local scrollBox = Create("ScrollingFrame", frame, {
    Size                 = UDim2.new(1, -8, 1, -30),
    Position             = UDim2.new(0, 4, 0, 26),
    BackgroundColor3     = Color3.fromRGB(5, 5, 5),
    CanvasSize           = UDim2.new(),
    AutomaticCanvasSize  = Enum.AutomaticSize.XY,
    ScrollBarThickness   = 3,
    ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0),
    ScrollingDirection   = Enum.ScrollingDirection.XY,
    ClipsDescendants     = true,
    ZIndex               = 7
  })
  Corner(scrollBox, UDim.new(0, 4))

  local codeBox = Create("TextBox", scrollBox, {
    Size                   = UDim2.new(1, 0, 1, 0),
    MinimumSize            = Vector2.new(200, 130),
    AutomaticSize          = Enum.AutomaticSize.XY,
    Text                   = "",
    PlaceholderText        = placeholder or "-- Cole seu código aqui...",
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 255, 0),
    BackgroundTransparency = 1,
    TextXAlignment         = Enum.TextXAlignment.Left,
    TextYAlignment         = Enum.TextYAlignment.Top,
    MultiLine              = true,
    ClearTextOnFocus       = false,
    TextWrapped            = false,
    ZIndex                 = 8
  })

  codeBox.FocusLost:Connect(function(enter)
    if callback then callback(codeBox.Text, enter) end
  end)

  -- Expõe o objeto codeBox para leitura externa
  frame.GetText = function() return codeBox.Text end
  frame.SetText = function(t) codeBox.Text = t end

  return frame
end

-- ----------------------------------------------------------------
function Library:AddDropdown(parent, name, options, default, callback)
  local ret   = {Default = default, DefaultText = name}
  local frame = Create("Frame", parent, {
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(0, 12, 0),
    ZIndex           = 6
  })
  Corner(frame, UDim.new(0, 4))
  Stroke(frame, Color3.fromRGB(0, 100, 0), 1)

  local header = Create("TextButton", frame, {
    Size                   = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 7
  })

  local headerLbl = Create("TextLabel", header, {
    Size                   = UDim2.new(1, -30, 1, 0),
    Position               = UDim2.new(0, 10, 0, 0),
    Text                   = name..": "..(default or ""),
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 220, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })
  Create("TextLabel", header, {
    Size                   = UDim2.fromOffset(20, 30),
    Position               = UDim2.new(1, -25, 0, 0),
    Text                   = "▾",
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 14,
    TextColor3             = Color3.fromRGB(0, 255, 0),
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  local list = Create("ScrollingFrame", frame, {
    Size                 = UDim2.new(1, 0, 0, 0),
    Position             = UDim2.new(0, 0, 1, 0),
    BackgroundColor3     = Color3.fromRGB(5, 5, 5),
    Visible              = false,
    ClipsDescendants     = true,
    CanvasSize           = UDim2.new(),
    AutomaticCanvasSize  = Enum.AutomaticSize.Y,
    ScrollBarThickness   = 2,
    ZIndex               = 8
  })
  Create("UIListLayout", list, {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
  Corner(list, UDim.new(0, 4))
  ret.ScrollBar = list

  local function toggleList()
    list.Visible = not list.Visible
    local targetH = list.Visible
      and (30 + math.min(#options, 4) * 25)
      or  30
    Tween(frame, {Size = UDim2.new(1, 0, 0, targetH)}, 0.2)
  end

  header.MouseButton1Click:Connect(toggleList)

  for _, opt in ipairs(options) do
    local b = Create("TextButton", list, {
      Size             = UDim2.new(1, -4, 0, 25),
      Text             = opt,
      Font             = Configs_HUB.Text_Font,
      TextSize         = 11,
      TextColor3       = Color3.fromRGB(0, 200, 0),
      BackgroundColor3 = Color3.fromRGB(10, 10, 10),
      ZIndex           = 8
    })
    Corner(b, UDim.new(0, 2))
    b.MouseButton1Click:Connect(function()
      headerLbl.Text = name..": "..opt
      ret.Default    = opt
      if callback then callback(opt) end
      toggleList()
    end)
  end

  ret.Callback = callback
  return ret
end

-- ----------------------------------------------------------------
function Library:AddKeybind(parent, name, default, callback)
  local key   = default or Enum.KeyCode.Unknown
  local frame = Create("Frame", parent, {
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(0, 12, 0),
    ZIndex           = 6
  })
  Corner(frame, UDim.new(0, 4))
  Stroke(frame, Color3.fromRGB(0, 100, 0), 1)

  Create("TextLabel", frame, {
    Size                   = UDim2.new(1, -60, 1, 0),
    Position               = UDim2.new(0, 10, 0, 0),
    Text                   = name,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 220, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  local b = Create("TextButton", frame, {
    Size             = UDim2.fromOffset(50, 24),
    Position         = UDim2.new(1, -55, 0.5, -12),
    Text             = key.Name,
    Font             = Configs_HUB.Text_Font,
    TextSize         = 10,
    TextColor3       = Color3.fromRGB(0, 255, 0),
    BackgroundColor3 = Color3.fromRGB(0, 20, 0),
    ZIndex           = 7
  })
  Corner(b, UDim.new(0, 4))

  local listening = false
  b.MouseButton1Click:Connect(function()
    listening = true
    b.Text    = "..."
  end)

  UserInputService.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    if listening and i.UserInputType == Enum.UserInputType.Keyboard then
      key       = i.KeyCode
      b.Text    = key.Name
      listening = false
      if callback then callback(key) end
    elseif not listening and i.KeyCode == key then
      if callback then callback(key) end
    end
  end)
end

-- ----------------------------------------------------------------
function Library:AddColorPicker(parent, name, default, callback)
  local color = default or Color3.fromRGB(0, 255, 0)
  local frame = Create("Frame", parent, {
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(0, 12, 0),
    ZIndex           = 6
  })
  Corner(frame, UDim.new(0, 4))
  Stroke(frame, Color3.fromRGB(0, 100, 0), 1)

  Create("TextLabel", frame, {
    Size                   = UDim2.new(1, -60, 1, 0),
    Position               = UDim2.new(0, 10, 0, 0),
    Text                   = name,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 220, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  local show = Create("Frame", frame, {
    Size             = UDim2.fromOffset(40, 18),
    Position         = UDim2.new(1, -48, 0.5, -9),
    BackgroundColor3 = color,
    ZIndex           = 7
  })
  Corner(show, UDim.new(0, 3))

  local b = Create("TextButton", frame, {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 8
  })

  b.MouseButton1Click:Connect(function()
    local pal = Create("Frame", parent, {
      Size             = UDim2.new(1, 0, 0, 34),
      BackgroundColor3 = Color3.fromRGB(5, 5, 5),
      ZIndex           = 10
    })
    Corner(pal, UDim.new(0, 4))
    Create("UIListLayout", pal, {
      FillDirection      = Enum.FillDirection.Horizontal,
      Padding            = UDim.new(0, 4),
      HorizontalAlignment= Enum.HorizontalAlignment.Center,
      VerticalAlignment  = Enum.VerticalAlignment.Center
    })
    local palette = {
      Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1),
      Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(0,1,1),
      Color3.new(1,1,1), Color3.new(0,0,0)
    }
    for _, c in ipairs(palette) do
      local cb = Create("TextButton", pal, {
        Size             = UDim2.fromOffset(28, 28),
        BackgroundColor3 = c,
        Text             = "",
        ZIndex           = 11
      })
      Corner(cb, UDim.new(0, 3))
      cb.MouseButton1Click:Connect(function()
        color               = c
        show.BackgroundColor3 = c
        if callback then callback(c) end
        pal:Destroy()
      end)
    end
  end)
end

-- ----------------------------------------------------------------
function Library:AddMobileToggle(parent, name, callback)
  local f = Create("Frame", ScreenGui, {
    Size             = UDim2.fromOffset(55, 55),
    Position         = UDim2.new(0, 50, 0.5, 0),
    AnchorPoint      = Vector2.new(0, 0.5),
    BackgroundColor3 = Color3.fromRGB(0, 20, 0),
    ZIndex           = 50
  })
  Corner(f, UDim.new(1, 0))
  Stroke(f, Color3.fromRGB(0, 255, 0), 1)

  local btn = Create("TextButton", f, {
    Size                   = UDim2.new(1, 0, 1, 0),
    Text                   = name:sub(1, 3),
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 12,
    TextColor3             = Color3.fromRGB(0, 255, 0),
    BackgroundTransparency = 1
  })

  -- Arrasto do botão mobile
  local mbDrag  = false
  local mbMouse, mbFrame

  f.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
      mbDrag  = true
      mbMouse = input.Position
      mbFrame = f.Position
    end
  end)
  f.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
      mbDrag = false
    end
  end)
  UserInputService.InputChanged:Connect(function(input)
    if mbDrag and input.UserInputType == Enum.UserInputType.Touch then
      local delta = input.Position - mbMouse
      f.Position  = UDim2.new(
        mbFrame.X.Scale, mbFrame.X.Offset + delta.X,
        mbFrame.Y.Scale, mbFrame.Y.Offset + delta.Y
      )
    end
  end)

  btn.MouseButton1Click:Connect(function()
    if callback then callback() end
  end)

  return f
end

-- ----------------------------------------------------------------
-- CORREÇÃO: AddParagraph dinâmico (altura automática)
function Library:AddParagraph(parent, title, text)
  local frame = Create("Frame", parent, {
    Size             = UDim2.new(1, 0, 0, 0),
    AutomaticSize    = Enum.AutomaticSize.Y,
    BackgroundColor3 = Color3.fromRGB(0, 8, 0),
    ClipsDescendants = false,
    ZIndex           = 6
  })
  Corner(frame, UDim.new(0, 4))

  Create("UIPadding", frame, {
    PaddingLeft   = UDim.new(0, 10),
    PaddingRight  = UDim.new(0, 10),
    PaddingTop    = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 6)
  })

  Create("UIListLayout", frame, {
    Padding   = UDim.new(0, 3),
    SortOrder = Enum.SortOrder.LayoutOrder
  })

  local titleLabel = Create("TextLabel", frame, {
    Size                   = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text                   = tostring(title),
    Font                   = Enum.Font.GothamBold,
    TextSize               = 13,
    TextColor3             = Color3.fromRGB(0, 255, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    LayoutOrder            = 1,
    ZIndex                 = 7
  })

  local textLabel = Create("TextLabel", frame, {
    Size                   = UDim2.new(1, 0, 0, 0),
    AutomaticSize          = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Text                   = tostring(text),
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 11,
    TextColor3             = Color3.fromRGB(0, 180, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    TextYAlignment         = Enum.TextYAlignment.Top,
    TextWrapped            = true,
    LayoutOrder            = 2,
    ZIndex                 = 7
  })

  return {Title = titleLabel, Text = textLabel, Frame = frame}
end

-- ----------------------------------------------------------------
function Library:AddImageLabel(parent, imageId, text)
  local img = Create("ImageLabel", parent, {
    Size                   = UDim2.new(1, 0, 0, 60),
    Image                  = "rbxassetid://"..tostring(imageId),
    BackgroundTransparency = 1,
    ScaleType              = Enum.ScaleType.Fit,
    ZIndex                 = 6
  })
  Create("TextLabel", img, {
    Size                   = UDim2.new(1, 0, 0, 16),
    Position               = UDim2.new(0, 0, 1, -16),
    Text                   = text,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 11,
    TextColor3             = Color3.fromRGB(0, 180, 0),
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })
  return img
end

-- ----------------------------------------------------------------
function Library:AddDiscord(parent, link, serverName, iconId)
  iconId = iconId or 10367063084
  local frame = Create("Frame", parent, {
    Size             = UDim2.new(1, 0, 0, 70),
    BackgroundColor3 = Color3.fromRGB(0, 0, 20),
    ZIndex           = 6
  })
  Corner(frame, UDim.new(0, 4))
  Stroke(frame, Color3.fromRGB(0, 80, 255), 1)

  local icon = Create("ImageLabel", frame, {
    Size                   = UDim2.fromOffset(45, 45),
    Position               = UDim2.new(0, 8, 0.5, -22),
    Image                  = "rbxassetid://"..tostring(iconId),
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })
  Corner(icon, UDim.new(1, 0))

  Create("TextLabel", frame, {
    Size                   = UDim2.new(1, -120, 0, 22),
    Position               = UDim2.new(0, 62, 0, 8),
    Text                   = serverName,
    Font                   = Enum.Font.GothamBold,
    TextSize               = 13,
    TextColor3             = Color3.fromRGB(150, 150, 255),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })
  Create("TextLabel", frame, {
    Size                   = UDim2.new(1, -120, 0, 18),
    Position               = UDim2.new(0, 62, 0, 30),
    Text                   = link,
    Font                   = Configs_HUB.Text_Font,
    TextSize               = 10,
    TextColor3             = Color3.fromRGB(100, 100, 200),
    TextXAlignment         = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex                 = 7
  })

  local joinBtn = Create("TextButton", frame, {
    Size             = UDim2.fromOffset(50, 28),
    Position         = UDim2.new(1, -58, 0.5, -14),
    Text             = "JOIN",
    Font             = Enum.Font.GothamBold,
    TextSize         = 12,
    TextColor3       = Color3.fromRGB(255, 255, 255),
    BackgroundColor3 = Color3.fromRGB(50, 50, 200),
    ZIndex           = 7
  })
  Corner(joinBtn, UDim.new(0, 4))

  joinBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(link) end
    joinBtn.Text = "✓"
    Tween(joinBtn, {BackgroundColor3 = Color3.fromRGB(0, 150, 0)}, 0.2)
    self:MakeNotifi("Discord", "Link copiado! Cole no navegador.", 3)
    task.wait(3)
    joinBtn.Text = "JOIN"
    Tween(joinBtn, {BackgroundColor3 = Color3.fromRGB(50, 50, 200)}, 0.2)
  end)
end

-- ----------------------------------------------------------------
function Library:DestroyScript()
  if ScreenGui then ScreenGui:Destroy() end
end

-- ============================================================
--                   BOAS-VINDAS
-- ============================================================
task.delay(1, function()
  Library:MakeNotifi(
    "MatrixHub :: Online",
    "Bem-vindo, "..DisplayName.."! Sistema ativo.",
    5
  )
end)

return Library
