--[[
	FastNoise Terrain Generator Example
	Generates a 50x50 terrain using parts to visualize each noise type
	
	Place this script in ServerScriptService
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FastNoise = require(ReplicatedStorage.FastNoise)

-- Configuration
local TERRAIN_SIZE = 50
local PART_SIZE = 1
local HEIGHT_MULTIPLIER = 20
local FREQUENCY = 0.05
local SEED = 12345

-- Spacing between each terrain demo
local TERRAIN_SPACING = 60

-- Color gradient for height (low to high)
local function getColorForHeight(normalizedHeight: number): Color3
	-- Water (blue) -> Sand (yellow) -> Grass (green) -> Rock (gray) -> Snow (white)
	if normalizedHeight < 0.2 then
		return Color3.fromRGB(30, 100, 200) -- Water
	elseif normalizedHeight < 0.35 then
		return Color3.fromRGB(210, 180, 140) -- Sand
	elseif normalizedHeight < 0.6 then
		return Color3.fromRGB(50, 150, 50) -- Grass
	elseif normalizedHeight < 0.8 then
		return Color3.fromRGB(100, 100, 100) -- Rock
	else
		return Color3.fromRGB(240, 240, 250) -- Snow
	end
end

-- Create a part at position with height
local function createPart(parent: Folder, x: number, z: number, height: number, offsetX: number)
	local normalizedHeight = math.clamp((height + 1) / 2, 0, 1)
	local actualHeight = normalizedHeight * HEIGHT_MULTIPLIER
	
	local part = Instance.new("Part")
	part.Size = Vector3.new(PART_SIZE, PART_SIZE, PART_SIZE)
	part.Position = Vector3.new(x + offsetX, actualHeight, z)
	part.Anchored = true
	part.Color = getColorForHeight(normalizedHeight)
	part.Material = Enum.Material.SmoothPlastic
	part.Parent = parent
	
	return part
end

-- Create label for terrain type
local function createLabel(parent: Folder, text: string, offsetX: number)
	local part = Instance.new("Part")
	part.Size = Vector3.new(20, 5, 1)
	part.Position = Vector3.new(offsetX + TERRAIN_SIZE / 2, 30, -5)
	part.Anchored = true
	part.Transparency = 0.5
	part.Color = Color3.fromRGB(50, 50, 50)
	part.Material = Enum.Material.SmoothPlastic
	part.Parent = parent
	
	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.Parent = part
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = surfaceGui
end

-- Generate terrain using a noise function
local function generateTerrain(name: string, noiseFunc: (number, number) -> number, offsetIndex: number)
	local folder = Instance.new("Folder")
	folder.Name = name .. "_Terrain"
	folder.Parent = workspace
	
	local offsetX = offsetIndex * TERRAIN_SPACING
	
	createLabel(folder, name, offsetX)
	
	print(`Generating {name} terrain...`)
	
	for x = 0, TERRAIN_SIZE - 1 do
		for z = 0, TERRAIN_SIZE - 1 do
			local height = noiseFunc(x, z)
			createPart(folder, x, z, height, offsetX)
		end
		
		-- Yield every row to prevent timeout
		if x % 10 == 0 then
			task.wait()
		end
	end
	
	print(`{name} terrain complete!`)
end

-- Main generation
print("=== FastNoise Terrain Generation Demo ===")
print("Generating 9 different terrain types...")

-- 1. Perlin Noise
generateTerrain("Perlin", function(x, z)
	return FastNoise.Perlin.noise2D(x * FREQUENCY, z * FREQUENCY, SEED)
end, 0)

-- 2. Value Noise
generateTerrain("Value", function(x, z)
	return FastNoise.Value.noise2D(x * FREQUENCY, z * FREQUENCY, SEED)
end, 1)

-- 3. FBM (Fractal Brownian Motion)
generateTerrain("FBM", function(x, z)
	return FastNoise.FBM.noise2D(x * FREQUENCY, z * FREQUENCY, SEED, {
		octaves = 6,
		lacunarity = 2.0,
		persistence = 0.5,
	})
end, 2)

-- 4. Billow Noise
generateTerrain("Billow", function(x, z)
	return FastNoise.Billow.noise2D(x * FREQUENCY, z * FREQUENCY, SEED, {
		octaves = 6,
		lacunarity = 2.0,
		persistence = 0.5,
	})
end, 3)

-- 5. Ridged Multifractal
generateTerrain("Ridged", function(x, z)
	return FastNoise.Ridged.noise2D(x * FREQUENCY, z * FREQUENCY, SEED, {
		octaves = 6,
		lacunarity = 2.0,
		gain = 2.0,
	})
end, 4)

-- 6. Worley F1
generateTerrain("Worley_F1", function(x, z)
	local value = FastNoise.Worley.noise2D(x * FREQUENCY, z * FREQUENCY, SEED, {
		returnType = "F1",
		distanceFunction = "Euclidean",
	})
	return value * 2 - 1 -- Convert 0-1 to -1 to 1
end, 5)

-- 7. Worley F2-F1
generateTerrain("Worley_F2-F1", function(x, z)
	local value = FastNoise.Worley.noise2D(x * FREQUENCY, z * FREQUENCY, SEED, {
		returnType = "F2MinusF1",
		distanceFunction = "Euclidean",
	})
	return value * 2 - 1
end, 6)

-- 8. Voronoi
generateTerrain("Voronoi", function(x, z)
	local value = FastNoise.Voronoi.noise2D(x * FREQUENCY, z * FREQUENCY, SEED, {
		returnType = "CellValue",
	})
	return value * 2 - 1
end, 7)

-- 9. Domain Warped FBM
generateTerrain("DomainWarp", function(x, z)
	local warpedX, warpedZ = FastNoise.DomainWarp.warpFractal2D(x * FREQUENCY, z * FREQUENCY, SEED, {
		amplitude = 2.0,
		frequency = 1.0,
		octaves = 3,
	})
	return FastNoise.FBM.noise2D(warpedX, warpedZ, SEED, {
		octaves = 4,
		lacunarity = 2.0,
		persistence = 0.5,
	})
end, 8)

print("=== All terrains generated! ===")
print("Walk around to see each noise type visualization.")
print("Terrains from left to right:")
print("1. Perlin | 2. Value | 3. FBM | 4. Billow | 5. Ridged")
print("6. Worley F1 | 7. Worley F2-F1 | 8. Voronoi | 9. Domain Warp")

return nil