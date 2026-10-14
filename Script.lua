-- # VERSION 1.0.4

-- SERVICIOS
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = workspace

-- VARIABLES GLOBALES
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- FUNCIONES AUXILIARES
local function CrearInstancia(Clase, Padre, Propiedades)
    local Instancia = Instance.new(Clase)
    if Propiedades then
        for Clave, Valor in pairs(Propiedades) do
            Instancia[Clave] = Valor
        end
    end
    Instancia.Parent = Padre
    return Instancia
end

local function EstaVivo(Personaje)
    if not Personaje then return false end
    local Humanoide = Personaje:FindFirstChildOfClass("Humanoid")
    return Humanoide and Humanoide.Health > 0
end

local function EsVisible(Parte)
    if not Parte then return false end
    local Parametros = RaycastParams.new()
    Parametros.FilterType = Enum.RaycastFilterType.Blacklist
    Parametros.FilterDescendantsInstances = {LocalPlayer.Character or Workspace, Parte.Parent}
    local Resultado = Workspace:Raycast(Camera.CFrame.Position, Parte.Position - Camera.CFrame.Position, Parametros)
    return not Resultado
end

-- SISTEMA DE CÁMARA — CORREGIDO
local function RestablecerCamara()
    if not LocalPlayer.Character then return end
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    Camera.CameraSubject = Humanoid or RootPart or LocalPlayer.Character
end

RunService.Heartbeat:Connect(function()
    local SujetoActual = Camera.CameraSubject
    if SujetoActual and (SujetoActual:IsA("VehicleSeat") or SujetoActual:IsA("Seat")) then
        RestablecerCamara()
    end
end)

-- ✅ AQUÍ ESTABA EL ERROR — ELIMINADO task.wrap QUE NO EXISTE
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    RestablecerCamara()
end)

-- INTERFAZ GRÁFICA
local Pantalla = CrearInstancia("ScreenGui", CoreGui, {
    Name = "Boltague_Menu",
    IgnoreGuiInset = true,
    ResetOnSpawn = false
})

local MarcoPrincipal = CrearInstancia("Frame", Pantalla, {
    Size = UDim2.new(0.35, 0, 0.7, 0),
    Position = UDim2.new(0.325, 0, 0.15, 0),
    BackgroundColor3 = Color3.fromRGB(12, 12, 18),
    BorderSizePixel = 0,
    ClipsDescendants = true
})
CrearInstancia("UICorner", MarcoPrincipal, {CornerRadius = UDim.new(0.035, 0)})

local BarraSuperior = CrearInstancia("Frame", MarcoPrincipal, {
    Size = UDim2.new(1, 0, 0.12, 0),
    BackgroundColor3 = Color3.fromRGB(25, 25, 35),
    BorderSizePixel = 0
})
CrearInstancia("UICorner", BarraSuperior, {CornerRadius = UDim.new(0.035, 0)})
CrearInstancia("TextLabel", BarraSuperior, {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "⚡ BOLTAGUE AIMBOT ⚡",
    TextColor3 = Color3.fromRGB(255, 215, 0),
    Font = Enum.Font.GothamBold,
    TextSize = 22
})

local EtiquetaInfo = CrearInstancia("TextLabel", MarcoPrincipal, {
    Position = UDim2.new(0.05, 0, 0.125, 0),
    Size = UDim2.new(0.9, 0, 0.05, 0),
    BackgroundColor3 = Color3.fromRGB(18, 18, 28),
    TextColor3 = Color3.fromRGB(50, 255, 120),
    Font = Enum.Font.GothamSemibold,
    TextSize = 15,
    BackgroundTransparency = 0.1
})
CrearInstancia("UICorner", EtiquetaInfo, {CornerRadius = UDim.new(0.02, 0)})

-- TABLA DE COLORES DE BOTONES
local ColoresBoton = {}
local function CrearBoton(PosicionY, Texto, ColorFondoInicial)
    local Boton = CrearInstancia("TextButton", MarcoPrincipal, {
        Size = UDim2.new(0.9, 0, 0.085, 0),
        Position = UDim2.new(0.05, 0, PosicionY, 0),
        BackgroundColor3 = ColorFondoInicial,
        TextColor3 = Color3.new(1,1,1),
        Text = Texto,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        AutoButtonColor = false,
        BorderSizePixel = 0
    })
    CrearInstancia("UICorner", Boton, {CornerRadius = UDim.new(0.025, 0)})
    
    ColoresBoton[Boton] = ColorFondoInicial
    Boton.MouseEnter:Connect(function()
        Boton.BackgroundColor3 = ColoresBoton[Boton]:Lerp(Color3.new(1,1,1), 0.15)
    end)
    Boton.MouseLeave:Connect(function()
        Boton.BackgroundColor3 = ColoresBoton[Boton]
    end)
    return Boton
end

-- BOTONES
local BotonESP = CrearBoton(0.18, "ESP: OFF", Color3.fromRGB(220, 40, 40))
local BotonAimbot = CrearBoton(0.28, "Aimbot: OFF", Color3.fromRGB(220, 40, 40))
local BotonInventario = CrearBoton(0.38, "InventoryView: OFF", Color3.fromRGB(220, 40, 40))

local CampoFOV = CrearInstancia("TextBox", MarcoPrincipal, {
    Size = UDim2.new(0.9, 0, 0.085, 0),
    Position = UDim2.new(0.05, 0, 0.48, 0),
    BackgroundColor3 = Color3.fromRGB(40, 40, 55),
    TextColor3 = Color3.fromRGB(255, 80, 80),
    Text = "FOV: 110",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    ClearTextOnFocus = false,
    BorderSizePixel = 0
})
CrearInstancia("UICorner", CampoFOV, {CornerRadius = UDim.new(0.025, 0)})

local BotonObjetivo = CrearBoton(0.58, "Target: Head (fixed)", Color3.fromRGB(80, 120, 255))
local BotonPared = CrearBoton(0.68, "Wallcheck: ON", Color3.fromRGB(30, 200, 60))

local MarcoJugadores = CrearInstancia("ScrollingFrame", MarcoPrincipal, {
    Size = UDim2.new(0.9, 0, 0.23, 0),
    Position = UDim2.new(0.05, 0, 0.78, 0),
    BackgroundColor3 = Color3.fromRGB(22, 22, 32),
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = Color3.fromRGB(100,100,255),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    BorderSizePixel = 0
})
CrearInstancia("UICorner", MarcoJugadores, {CornerRadius = UDim.new(0.025, 0)})
CrearInstancia("UIListLayout", MarcoJugadores, {Padding = UDim.new(0, 5)})

-- CONFIGURACIÓN
local ActivoESP = false
local ActivoAimbot = false
local ActivoInventario = false
local RadioFOV = 110
local ChequearPared = true
local MenuAbierto = true
local JugadoresProtegidos = {}
local BotonesJugador = {}
local ObjetosInventario = {}
local EstadoInventario = {}
local CacheNombresHerramientas = {}

-- SISTEMA DE INVENTARIO
local ColoresRareza = {
    Common = Color3.fromRGB(0, 255, 0),
    Rare = Color3.fromRGB(0, 0, 255),
    Epic = Color3.fromRGB(128, 0, 128),
    Legendary = Color3.fromRGB(255, 215, 0),
    Uncommon = Color3.fromRGB(128, 128, 128)
}
local function ObtenerColorRareza(Rareza)
    return ColoresRareza[Rareza] or Color3.fromRGB(255,255,255)
end
local function BuscarNombreHerramienta(Herramienta)
    if not Herramienta then return "Desconocido" end
    if CacheNombresHerramientas[Herramienta.Name] then
        return CacheNombresHerramientas[Herramienta.Name]
    end
    local Mango = Herramienta:FindFirstChild("Handle")
    if not Mango then
        CacheNombresHerramientas[Herramienta.Name] = Herramienta.Name
        return Herramienta.Name
    end
    local Componentes = {}
    for _, Hijo in ipairs(Mango:GetChildren()) do
        Componentes[Hijo.Name] = true
    end
    for _, Fuente in ipairs({ReplicatedStorage:FindFirstChild("Items"), game:GetService("StarterPack")}) do
        if not Fuente then continue end
        for _, Item in ipairs(Fuente:GetDescendants()) do
            if Item:IsA("Tool") and Item:FindFirstChild("Handle") then
                local Coincide = true
                for Nombre in pairs(Componentes) do
                    if not Item.Handle:FindFirstChild(Nombre) then
                        Coincide = false
                        break
                    end
                end
                if Coincide then
                    CacheNombresHerramientas[Herramienta.Name] = Item.Name
                    return Item.Name
                end
            end
        end
    end
    CacheNombresHerramientas[Herramienta.Name] = Herramienta.Name
    return Herramienta.Name
end
local function ObtenerHerramientasJugador(Jugador)
    local Lista = {}
    for _, Contenedor in ipairs({Jugador:FindFirstChild("Backpack"), Jugador.Character}) do
        if not Contenedor then continue end
        for _, Herramienta in ipairs(Contenedor:GetChildren()) do
            if Herramienta:IsA("Tool") then
                table.insert(Lista, {
                    Nombre = BuscarNombreHerramienta(Herramienta),
                    Rareza = Herramienta:GetAttribute("RarityName") or "Common",
                    Equipada = (Herramienta.Parent == Jugador.Character)
                })
            end
        end
    end
    return Lista
end
local function CrearDisplayInventario(Jugador)
    if not Jugador then return end
    EliminarDisplayInventario(Jugador)
    if not Jugador.Character then return end
    local Raiz = Jugador.Character:FindFirstChild("HumanoidRootPart")
    if not Raiz then return end
    local Gui = CrearInstancia("BillboardGui", Raiz, {
        Name = "InventoryView",
        Size = UDim2.new(0, 300, 0, 100),
        StudsOffset = Vector3.new(0, -4, 0),
        AlwaysOnTop = true,
        Active = false
    })
    local Contenedor = CrearInstancia("Frame", Gui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    })
    CrearInstancia("UIListLayout", Contenedor, {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })
    ObjetosInventario[Jugador.Name] = {Gui = Gui, Contenedor = Contenedor}
end
local function ActualizarDisplayInventario(Jugador)
    if not ActivoInventario then return end
    if not ObjetosInventario[Jugador.Name] then
        CrearDisplayInventario(Jugador)
        if not ObjetosInventario[Jugador.Name] then return end
    end
    local Herramientas = ObtenerHerramientasJugador(Jugador)
    local CadenaEstado = ""
    for _, H in ipairs(Herramientas) do
        CadenaEstado ..= H.Nombre .. H.Rareza .. tostring(H.Equipada)
    end
    if EstadoInventario[Jugador.Name] == CadenaEstado then return end
    EstadoInventario[Jugador.Name] = CadenaEstado
    local Contenedor = ObjetosInventario[Jugador.Name].Contenedor
    for _, Hijo in ipairs(Contenedor:GetChildren()) do
        if Hijo:IsA("TextLabel") then Hijo:Destroy() end
    end
    for _, Herramienta in ipairs(Herramientas) do
        CrearInstancia("TextLabel", Contenedor, {
            Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            Text = "- " .. Herramienta.Nombre,
            TextColor3 = ObtenerColorRareza(Herramienta.Rareza),
            TextTransparency = Herramienta.Equipada and 0 or 0.1,
            TextStrokeTransparency = Herramienta.Equipada and 0.8 or 1
        })
    end
end
local function EliminarDisplayInventario(Jugador)
    if ObjetosInventario[Jugador.Name] then
        ObjetosInventario[Jugador.Name].Gui:Destroy()
        ObjetosInventario[Jugador.Name] = nil
        EstadoInventario[Jugador.Name] = nil
    end
end

-- SISTEMA ESP
local function EliminarESP(Personaje)
    if not Personaje then return end
    local Cabeza = Personaje:FindFirstChild("Head")
    if Cabeza and Cabeza:FindFirstChild("AnouarNameHP") then
        Cabeza.AnouarNameHP:Destroy()
    end
    if Personaje:FindFirstChild("AnouarHighlight") then
        Personaje.AnouarHighlight:Destroy()
    end
end
local function AplicarESP(Personaje)
    if not Personaje then return end
    local Jugador = Players:GetPlayerFromCharacter(Personaje)
    if not Jugador or Jugador == LocalPlayer then return end
    EliminarESP(Personaje)
    local Cabeza = Personaje:FindFirstChild("Head")
    local Humanoide = Personaje:FindFirstChildOfClass("Humanoid")
    if not Cabeza or not Humanoide or not EstaVivo(Personaje) then return end
    local GuiNombre = CrearInstancia("BillboardGui", Cabeza, {
        Name = "AnouarNameHP",
        Adornee = Cabeza,
        Size = UDim2.new(0,180,0,40),
        StudsOffset = Vector3.new(0,2.8,0),
        AlwaysOnTop = true
    })
    CrearInstancia("TextLabel", GuiNombre, {
        Size = UDim2.new(1,0,0,18),
        BackgroundTransparency = 1,
        Text = Jugador.DisplayName ~= Jugador.Name and (Jugador.DisplayName .. " (@" .. Jugador.Name .. ")") or Jugador.Name,
        TextColor3 = Color3.new(1,1,1),
        TextStrokeTransparency = 0,
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })
    local MarcoVida = CrearInstancia("Frame", GuiNombre, {
        Size = UDim2.new(1,-6,0,6),
        Position = UDim2.new(0,3,0,18),
        BackgroundColor3 = Color3.new(0,0,0)
    })
    CrearInstancia("UICorner", MarcoVida, {CornerRadius = UDim.new(0,3)})
    local BarraVida = CrearInstancia("Frame", MarcoVida, {
        Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = Color3.fromRGB(0,255,100)
    })
    CrearInstancia("UICorner", BarraVida, {CornerRadius = UDim.new(0,3)})
    local EtiquetaVida = CrearInstancia("TextLabel", MarcoVida, {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        TextStrokeTransparency = 0,
        TextSize = 9,
        Font = Enum.Font.GothamBold
    })
    local function ActualizarVida()
        if Humanoide.Parent and EstaVivo(Personaje) then
            local Porcentaje = math.clamp(Humanoide.Health / Humanoide.MaxHealth, 0, 1)
            BarraVida.Size = UDim2.new(Porcentaje, 0, 1, 0)
            EtiquetaVida.Text = math.floor(Humanoide.Health) .. "/" .. Humanoide.MaxHealth
        else
            EliminarESP(Personaje)
        end
    end
    Humanoide.HealthChanged:Connect(ActualizarVida)
    Humanoide.Died:Connect(function() EliminarESP(Personaje) end)
    ActualizarVida()
    CrearInstancia("Highlight", Personaje, {
        Name = "AnouarHighlight",
        OutlineColor = Color3.fromRGB(255,215,0),
        OutlineTransparency = 0,
        FillTransparency = 1
    })
end

-- CONTROLES DE BOTONES
BotonESP.MouseButton1Click:Connect(function()
    ActivoESP = not ActivoESP
    BotonESP.Text = "ESP: " .. (ActivoESP and "ON" or "OFF")
    local NuevoColor = ActivoESP and Color3.fromRGB(30, 200, 60) or Color3.fromRGB(220, 40, 40)
    BotonESP.BackgroundColor3 = NuevoColor
    ColoresBoton[BotonESP] = NuevoColor
end)
BotonInventario.MouseButton1Click:Connect(function()
    ActivoInventario = not ActivoInventario
    BotonInventario.Text = "InventoryView: " .. (ActivoInventario and "ON" or "OFF")
    local NuevoColor = ActivoInventario and Color3.fromRGB(30, 200, 60) or Color3.fromRGB(220, 40, 40)
    BotonInventario.BackgroundColor3 = NuevoColor
    ColoresBoton[BotonInventario] = NuevoColor
    if not ActivoInventario then
        for _, Jugador in ipairs(Players:GetPlayers()) do
            if Jugador ~= LocalPlayer then
                EliminarDisplayInventario(Jugador)
            end
        end
    end
end)
BotonAimbot.MouseButton1Click:Connect(function()
    ActivoAimbot = not ActivoAimbot
    BotonAimbot.Text = "Aimbot: " .. (ActivoAimbot and "ON" or "OFF")
    local NuevoColor = ActivoAimbot and Color3.fromRGB(30, 200, 60) or Color3.fromRGB(220, 40, 40)
    BotonAimbot.BackgroundColor3 = NuevoColor
    ColoresBoton[BotonAimbot] = NuevoColor
end)

local MODOS_MIRA = {
    {Nombre = "Head (fixed)", Parte = "Head", Color = Color3.fromRGB(100,100,255)},
    {Nombre = "Torso (fixed)", Parte = "HumanoidRootPart", Color = Color3.fromRGB(255,150,50)},
    {Nombre = "Right Arm (fixed)", Parte = "RightUpperArm", Color = Color3.fromRGB(50,205,50)},
    {Nombre = "Left Arm (fixed)", Parte = "LeftUpperArm", Color = Color3.fromRGB(50,255,150)},
    {Nombre = "Auto Switch (Head ↔ Torso)", Partes = {"Head", "HumanoidRootPart"}, Color = Color3.fromRGB(180,100,255)},
    {Nombre = "Auto Switch (Right Arm ↔ Left Arm)", Partes = {"RightUpperArm", "LeftUpperArm"}, Color = Color3.fromRGB(255, 255, 0)}
}
local IndiceModoActual = 1
local IndiceAutoActual = 1
local TiempoCambio = 0
local INTERVALO_CAMBIO = 0.7

BotonObjetivo.MouseButton1Click:Connect(function()
    IndiceModoActual = IndiceModoActual % #MODOS_MIRA + 1
    local Modo = MODOS_MIRA[IndiceModoActual]
    BotonObjetivo.Text = "Target: " .. Modo.Nombre
    BotonObjetivo.BackgroundColor3 = Modo.Color
    ColoresBoton[BotonObjetivo] = Modo.Color
end)
BotonPared.MouseButton1Click:Connect(function()
    ChequearPared = not ChequearPared
    BotonPared.Text = "Wallcheck: " .. (ChequearPared and "ON" or "OFF")
    local NuevoColor = ChequearPared and Color3.fromRGB(30, 200, 60) or Color3.fromRGB(220, 40, 40)
    BotonPared.BackgroundColor3 = NuevoColor
    ColoresBoton[BotonPared] = NuevoColor
end)
CampoFOV.FocusLost:Connect(function(EntradaPerdida)
    if EntradaPerdida then
        local Valor = tonumber(CampoFOV.Text:match("%d+"))
        if Valor and Valor >= 20 and Valor <= 600 then
            RadioFOV = Valor
            CampoFOV.Text = "FOV: " .. Valor
        else
            CampoFOV.Text = "FOV: " .. RadioFOV
        end
    end
end)

-- LISTA DE JUGADORES
local function ActualizarListaProtegidos()
    for _, Boton in ipairs(BotonesJugador) do Boton:Destroy() end
    BotonesJugador = {}
    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador == LocalPlayer then continue end
        local Protegido = JugadoresProtegidos[Jugador] or false
        local Boton = CrearInstancia("TextButton", MarcoJugadores, {
            Size = UDim2.new(1,-10,0,30),
            BackgroundColor3 = Protegido and Color3.fromRGB(40, 80, 200) or Color3.fromRGB(45, 45, 60),
            Text = Jugador.DisplayName .. " (@" .. Jugador.Name .. ")" .. (Protegido and " ✔" or ""),
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.GothamSemibold,
            TextSize = 13,
            AutoButtonColor = false
        })
        CrearInstancia("UICorner", Boton, {CornerRadius = UDim.new(0,6)})
        table.insert(BotonesJugador, Boton)
        Boton.MouseButton1Click:Connect(function()
            JugadoresProtegidos[Jugador] = not JugadoresProtegidos[Jugador]
            ActualizarListaProtegidos()
        end)
    end
    local CantidadProtegidos = 0
    for _ in pairs(JugadoresProtegidos) do CantidadProtegidos += 1 end
    EtiquetaInfo.Text = "Protegidos: " .. CantidadProtegidos .. " | Slots: ilimitados"
end

-- LÓGICA DE OBJETIVO
local function ObtenerParteObjetivo(Personaje)
    local Modo = MODOS_MIRA[IndiceModoActual]
    local NombreParte = Modo.Partes and Modo.Partes[IndiceAutoActual] or Modo.Parte
    local Parte = Personaje:FindFirstChild(NombreParte)
    if Parte then return Parte end
    if NombreParte == "RightUpperArm" then
        Parte = Personaje:FindFirstChild("Right Arm")
    elseif NombreParte == "LeftUpperArm" then
        Parte = Personaje:FindFirstChild("Left Arm")
    end
    return Parte or Personaje:FindFirstChild("Head") or Personaje:FindFirstChild("HumanoidRootPart")
end
local function BuscarObjetivoMasCercano()
    local Objetivo = nil
    local DistanciaMinima = math.huge
    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador == LocalPlayer or JugadoresProtegidos[Jugador] then continue end
        if not Jugador.Character or not EstaVivo(Jugador.Character) then continue end
        local ParteObjetivo = ObtenerParteObjetivo(Jugador.Character)
        if not ParteObjetivo then continue end
        local PosicionPantalla, EnPantalla = Camera:WorldToViewportPoint(ParteObjetivo.Position)
        if not EnPantalla then continue end
        local Distancia = (Vector2.new(PosicionPantalla.X, PosicionPantalla.Y) - Camera.ViewportSize/2).Magnitude
        if Distancia < DistanciaMinima and Distancia <= RadioFOV then
            if not ChequearPared or EsVisible(ParteObjetivo) then
                DistanciaMinima = Distancia
                Objetivo = Jugador
            end
        end
    end
    return Objetivo
end

-- CÍRCULO FOV — PROTEGIDO CONTRA FALLO
local CirculoFOV = nil
pcall(function()
    if Drawing then
        CirculoFOV = Drawing.new("Circle")
        CirculoFOV.Thickness = 2
        CirculoFOV.Color = Color3.fromRGB(255,0,0)
        CirculoFOV.Transparency = 0.6
        CirculoFOV.Filled = false
        CirculoFOV.Visible = false
    end
end)

-- CONEXIONES PRINCIPALES
RunService.RenderStepped:Connect(function()
    if CirculoFOV then
        CirculoFOV.Position = Camera.ViewportSize / 2
        CirculoFOV.Radius = RadioFOV
        CirculoFOV.Visible = ActivoAimbot
    end
    if ActivoAimbot then
        local Objetivo = BuscarObjetivoMasCercano()
        if Objetivo and Objetivo.Character then
            local Parte = ObtenerParteObjetivo(Objetivo.Character)
            if Parte then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Parte.Position), 1)
            end
        end
    end
end)

-- PROCESAR JUGADOR
local function ProcesarJugador(Jugador)
    Jugador.CharacterAdded:Connect(function(Personaje)
        task.wait(0.1)
        if ActivoESP then AplicarESP(Personaje) end
        if ActivoInventario then CrearDisplayInventario(Jugador) end
    end)
    Jugador.CharacterRemoving:Connect(function(Personaje)
        EliminarESP(Personaje)
        EliminarDisplayInventario(Jugador)
    end)
end
for _, Jugador in ipairs(Players:GetPlayers()) do
    if Jugador ~= LocalPlayer then
        ProcesarJugador(Jugador)
    end
end
Players.PlayerAdded:Connect(ProcesarJugador)
Players.PlayerRemoving:Connect(function(Jugador)
    JugadoresProtegidos[Jugador] = nil
    EliminarDisplayInventario(Jugador)
    if Jugador.Character then EliminarESP(Jugador.Character) end
    ActualizarListaProtegidos()
end)

-- BUCLE DE ACTUALIZACIÓN
RunService.Heartbeat:Connect(function(DeltaTiempo)
    for _, Jugador in ipairs(Players:GetPlayers()) do
        if Jugador == LocalPlayer or not Jugador.Character then continue end
        local Personaje = Jugador.Character
        local TieneESP = Personaje:FindFirstChild("Head") 
            and Personaje.Head:FindFirstChild("AnouarNameHP")
        if ActivoESP and not TieneESP then
            AplicarESP(Personaje)
        elseif not ActivoESP and TieneESP then
            EliminarESP(Personaje)
        end
    end
    if ActivoInventario then
        for _, Jugador in ipairs(Players:GetPlayers()) do
            if Jugador ~= LocalPlayer then
                ActualizarDisplayInventario(Jugador)
            end
        end
    end
    local Modo = MODOS_MIRA[IndiceModoActual]
    if ActivoAimbot and Modo.Partes then
        TiempoCambio += DeltaTiempo
        if TiempoCambio >= INTERVALO_CAMBIO then
            TiempoCambio = 0
            IndiceAutoActual = IndiceAutoActual % #Modo.Partes + 1
        end
    end
end)

-- TECLA PARA MOSTRAR/OCULTAR MENÚ
UserInputService.InputBegan:Connect(function(Entrada, Procesado)
    if not Procesado and Entrada.KeyCode == Enum.KeyCode.G then
        MenuAbierto = not MenuAbierto
        MarcoPrincipal.Visible = MenuAbierto
        if MenuAbierto then ActualizarListaProtegidos() end
    end
end)

-- ARRASTRE DE VENTANA
local Arrastrando = false
local PosicionInicial, MouseInicial
BarraSuperior.InputBegan:Connect(function(Entrada)
    if Entrada.UserInputType == Enum.UserInputType.MouseButton1 then
        Arrastrando = true
        PosicionInicial = MarcoPrincipal.Position
        MouseInicial = Entrada.Position
    end
end)
UserInputService.InputChanged:Connect(function(Entrada)
    if Arrastrando and Entrada.UserInputType == Enum.UserInputType.MouseMovement then
        local Diferencia = Entrada.Position - MouseInicial
        MarcoPrincipal.Position = UDim2.new(
            PosicionInicial.X.Scale, PosicionInicial.X.Offset + Diferencia.X,
            PosicionInicial.Y.Scale, PosicionInicial.Y.Offset + Diferencia.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(Entrada)
    if Entrada.UserInputType == Enum.UserInputType.MouseButton1 then
        Arrastrando = false
    end
end)

-- INICIO
ActualizarListaProtegidos()
