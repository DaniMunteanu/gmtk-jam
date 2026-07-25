shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec4 base : source_color;
uniform float frequency = 60.0;
uniform float depth = 0.005;

void fragment() {
    // 1. Calculate the wavy distorted UV coordinates
    vec2 uv = SCREEN_UV;
    uv.x += sin(uv.y * frequency + TIME) * depth;
    uv.x = clamp(uv.x, 0.0, 1.0);
    
    // 2. Sample the screen using the newly distorted UVs
    vec3 c = textureLod(screen_texture, uv, 0.0).rgb;
    
    // 3. Convert to grayscale and apply the base color tint
    float v = dot(c, vec3(0.33333, 0.33333, 0.33333));
    v = sqrt(v);
    
    // 4. Output the final colored and wavy pixel
    COLOR.rgb = base.rgb * v;
    COLOR.a = 1.0; 
}
