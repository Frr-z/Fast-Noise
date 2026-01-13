# FastNoise

A high-performance, fully-typed noise generation library for Roblox/Luau.

Built with `--!strict`, `--!native`, and `--!optimize 2` for maximum performance.

## Features

- **9 Noise Types**: Perlin, Value, FBM, Billow, Ridged, Worley, Voronoi, Turbulence, Domain Warp
- **2D & 3D Support**: All noise functions work in both dimensions
- **Fully Typed**: Complete type annotations for IntelliSense support
- **Configurable**: Extensive options (octaves, lacunarity, persistence, etc.)
- **Seedable**: All functions support custom seeds for reproducible results
- **Native Optimized**: Uses Luau native code generation

## Installation

### With Rojo

Clone and sync with your project:

```bash
rojo build -o "Fast-Noise.rbxlx"
rojo serve
```

### Manual

Download and place the `FastNoise` folder in `ReplicatedStorage`.

## Quick Start

```lua
local FastNoise = require(ReplicatedStorage.FastNoise)

-- Simple usage
local value = FastNoise.Perlin.noise2D(x, y, seed)

-- With configuration
local fbm = FastNoise.FBM.create({
    octaves = 6,
    lacunarity = 2.0,
    persistence = 0.5,
})
local value = fbm.noise2D(x, y, seed)
```

## Noise Types

### Perlin Noise
Classic gradient noise - smooth, natural-looking patterns.
```lua
local value = FastNoise.Perlin.noise2D(x, y, seed)
local value3D = FastNoise.Perlin.noise3D(x, y, z, seed)
```

### Value Noise
Lattice-based interpolated random values - faster but blockier than Perlin.
```lua
local value = FastNoise.Value.noise2D(x, y, seed)
```

### FBM (Fractal Brownian Motion)
Multiple octaves of noise combined for natural detail at all scales.
```lua
local fbm = FastNoise.FBM.create({
    octaves = 6,
    lacunarity = 2.0,
    persistence = 0.5,
    frequency = 0.01,
})
local value = fbm.noise2D(x, y, seed)
```

### Billow Noise
Billowy, cloud-like patterns using absolute value of noise.
```lua
local billow = FastNoise.Billow.create({
    octaves = 4,
    persistence = 0.5,
})
local value = billow.noise2D(x, y, seed)
```

### Ridged Multifractal
Sharp ridges - perfect for mountain ranges.
```lua
local ridged = FastNoise.Ridged.create({
    octaves = 6,
    gain = 2.0,
    offset = 1.0,
})
local value = ridged.noise2D(x, y, seed)
```

### Worley (Cellular) Noise
Cell-based patterns - great for stones, scales, organic textures.
```lua
local worley = FastNoise.Worley.create({
    frequency = 0.1,
    distanceFunction = "Euclidean", -- "Manhattan", "Chebyshev"
    returnType = "F1", -- "F2", "F2MinusF1", "F1PlusF2"
    jitter = 1.0,
})
local value = worley.noise2D(x, y, seed)
```

### Voronoi Noise
Returns cell IDs - ideal for biome generation.
```lua
local voronoi = FastNoise.Voronoi.create({
    frequency = 0.05,
    returnType = "CellValue", -- "Distance", "Both"
})
local cellId = voronoi.noise2D(x, y, seed)

-- Full data version
local cellValue, distance, cellX, cellY = FastNoise.Voronoi.noise2DFull(x, y, seed)
```

### Turbulence
Turbulent flow patterns with power control.
```lua
local turbulence = FastNoise.Turbulence.create({
    octaves = 4,
    power = 1.0,
})
local value = turbulence.noise2D(x, y, seed)

-- Coordinate displacement
local newX, newY = turbulence.displace2D(x, y, seed, strength)
```

### Domain Warp
Distort coordinates for organic, warped patterns.
```lua
local warp = FastNoise.DomainWarp.create({
    amplitude = 30.0,
    frequency = 0.01,
    octaves = 3,
})

local warpedX, warpedY = warp.warp2D(x, y, seed)
local warpedX, warpedY = warp.warpFractal2D(x, y, seed)
local warpedX, warpedY = warp.warpProgressive2D(x, y, seed, layers)
```

## Utility Functions

```lua
-- Normalize from [-1,1] to [0,1]
local normalized = FastNoise.normalize(value)

-- Map to custom range
local mapped = FastNoise.map(value, 0, 100)

-- Clamp value
local clamped = FastNoise.clamp(value, -0.5, 0.5)

-- Deterministic hash
local hash = FastNoise.hash(x, y, z, seed)

-- Combine multiple noise values
local combined = FastNoise.combine({
    { value = noise1, weight = 1.0 },
    { value = noise2, weight = 0.5 },
})

-- Create sampler by name
local sampler = FastNoise.createSampler("FBM", { octaves = 4 })
```

## Example: Terrain Generation

```lua
local FastNoise = require(ReplicatedStorage.FastNoise)

local SIZE = 50
local SCALE = 0.05
local HEIGHT = 20
local SEED = 12345

local fbm = FastNoise.FBM.create({
    octaves = 6,
    persistence = 0.5,
    lacunarity = 2.0,
})

for x = 1, SIZE do
    for z = 1, SIZE do
        local noise = fbm.noise2D(x * SCALE, z * SCALE, SEED)
        local height = FastNoise.map(noise, 0, HEIGHT)
        
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, height, 1)
        part.Position = Vector3.new(x, height / 2, z)
        part.Anchored = true
        part.Parent = workspace
    end
end
```

## Module Structure

```
FastNoise/
├── init.lua        -- Main module & utilities
├── Perlin.lua      -- Perlin gradient noise
├── Value.lua       -- Value interpolated noise
├── FBM.lua         -- Fractal Brownian Motion
├── Billow.lua      -- Billow/cloud noise
├── Ridged.lua      -- Ridged multifractal
├── Worley.lua      -- Cellular/Worley noise
├── Voronoi.lua     -- Voronoi diagrams
├── Turbulence.lua  -- Turbulence patterns
├── DomainWarp.lua  -- Domain warping
└── Examples/
    └── TerrainGenerator.lua
```

## Examples
Make sure you check [FastNoiseShowcase.rbxm](ReplicatedStorage\FastNoise\Examples\FastNoiseShowcase.rbxm)! Big thanks to @avocadopeanut

## Performance Tips

1. **Use `.create()`** - Pre-configures the generator
2. **Cache samplers** - Don't create new samplers every frame
3. **Reduce octaves** - Fewer octaves = faster computation
4. **Use Value noise** - Faster than Perlin when quality isn't critical

## License

MIT License - Free for any use!