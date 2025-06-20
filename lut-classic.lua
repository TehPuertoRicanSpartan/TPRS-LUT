-- TPRS-LUT by TehPuertoRicanSpartan
-- Original shader code by Marty McFly (i ported it from reshade bcz i don't have time to learn glsl lmfao)

-- requires Classic (https://github.com/rxi/classic)

local LUT = Classic:extend("LUT")

local code = [[

extern Image lut;
extern number size;
extern number tiles;
extern number chroma;
extern number luma;

vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords)
{
    vec4 texture = Texel(tex, tex_coords);
    vec2 texelsize = vec2(
        1.0 / size,
        1.0 / size
    );
    texelsize.x /= tiles;

    vec3 lutcoord = vec3(
        (texture.rg*size-texture.rg+0.5)*texelsize.xy,
        texture.b*size-texture.b
    );
    float lerpfact = fract(lutcoord.z);
    lutcoord.x += (lutcoord.z-lerpfact)*texelsize.y;

    vec3 lutcolor = mix(Texel(lut, lutcoord.xy).rgb, Texel(lut, vec2(lutcoord.x+texelsize.y,lutcoord.y)).xyz,lerpfact);

    texture.rgb = mix(normalize(texture.rgb), normalize(lutcolor.rgb), chroma) * mix(length(texture.rgb), length(lutcolor.rgb), luma);
    return texture * color;
}

]]

function LUT:new(lut, size, tiles, chroma, luma)
    self.shader = love.graphics.newShader(code)

    self.chroma = chroma or 1.0
    self.luma = luma or 1.0

    self:load(lut, size, tiles)
    self:setChroma(self.chroma)
    self:setLuma(self.luma)
end

function LUT:load(lut, size, tiles)
    self.lut = lut

    local lut_img = type(lut) == "string" and love.graphics.newImage(lut) or lut
    lut_img:setFilter("nearest")

    self.shader:send("lut", lut_img)
    self.shader:send("size", size)
    self.shader:send("tiles", tiles)
end

function LUT:setChroma(chroma)
    self.chroma = chroma or 1.0
    self.shader:send("chroma", chroma)
end

function LUT:setLuma(luma)
    self.luma = luma or 1.0
    self.shader:send("luma", luma)
end

return LUT