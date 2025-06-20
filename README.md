# TPRS-LUT for LÖVE
A port of Marty McFly's LUT shader from Reshade to LÖVE
## How to use
### lut:init(path:String, size:Int, tiles:Int, ?chroma:Float = 1, ?luma:Float = 1)
- path: Where is your LUT located?
- size: How big are the red-green blocks in your LUT? (in pixels)
- tiles: How many blocks are in your LUT?
- chroma: Intensity of color
- luma: Intensity of brightness

The Classic version is the same, but you have to use `LUT.shader` when you want to set the shader
### LUT(path:String, size:Int, tiles:Int, ?chroma:Float = 1, ?luma:Float = 1)
Variables:
- lut: `Image`
- chroma: `Float`
- luma: `Float`

Methods:
- setChroma(chroma): Sets the chroma to the variable AND the shader
- setLuma(luma): Ditto, but applies to the luma
