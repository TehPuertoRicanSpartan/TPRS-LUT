-- TPRS-LUT by TehPuertoRicanSpartan
-- Original shader code by Marty McFly (i ported it from reshade bcz i don't have time to learn glsl lmfao)

local lut = {}

local shaderCode = [[

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

function lut:init(path, size, tiles, chorma, luma)
    local shader = love.graphics.newShader(shaderCode)

    local image = type(path) == "string" and love.graphics.newImage(path) or path
    image:setFilter("nearest")
    shader:send("lut", image)
    shader:send("size", size)
    shader:send("tiles", tiles)

    shader:send("chroma", chorma or 1.0)
    shader:send("luma", luma or 1.0)

    return shader
end

return lut