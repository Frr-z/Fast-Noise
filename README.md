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
Make sure you check [FastNoiseShowcase.rbxm](ReplicatedStorage/FastNoise/Examples/FastNoiseShowcase.rbxm)! Big thanks to @avocadopeanut

## Performance Tips

1. **Use `.create()`** - Pre-configures the generator
2. **Cache samplers** - Don't create new samplers every frame
3. **Reduce octaves** - Fewer octaves = faster computation
4. **Use Value noise** - Faster than Perlin when quality isn't critical

## License

MIT License - Free for any use!