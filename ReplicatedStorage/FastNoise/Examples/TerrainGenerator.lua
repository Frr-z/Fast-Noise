local tamanho = 50
local escala = 0.01
local altura_maxima = 50


local function gerar(pos, aleatorio )
    for x = 0, tamanho do
        for z = 0, tamanho do
            local valor_noise = aleatorio and math.random() or math.noise(x * escala, z * escala)
            local y = valor_noise * altura_maxima

            local part = Instance.new("Part")
            part.Size = Vector3.new(1,1,1)
            part.Position = pos + Vector3.new(x, y, z)
            part.Anchored = true
            part.Parent = workspace
            task.wait()
        end
    end
end

gerar(Vector3.new(0,0,0), true)

gerar(Vector3.new(100, 0, 0), false)



return nil