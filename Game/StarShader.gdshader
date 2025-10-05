shader_type canvas_item;

uniform vec4 bg_color = vec4(0.10, 0.12, 0.15, 1.0);
uniform vec4 star_color = vec4(0.85, 0.90, 1.0, 1.0);
uniform float speed = 0.08;
uniform float density = 0.9;
uniform float size_px = 1.5;
uniform float twinkle = 0.25;
uniform float seed = 1.234;

float hash(vec2 p){
    p = vec2(dot(p, vec2(127.1, 311.7)),
             dot(p, vec2(269.5, 183.3)));
    return fract(sin(p.x+p.y) * 43758.5453123);
}

float star_layer(vec2 uv, float layer_speed, float layer_scale, float layer_density){
    uv.x = fract(uv.x + TIME * layer_speed);

    vec2 g = floor(uv * layer_scale);
    vec2 f = fract(uv * layer_scale);

    float r = hash(g + seed);
    float make_star = step(1.0 - layer_density, r);

    vec2 sp = vec2(hash(g + 3.7) , hash(g + 7.1));

    float d = length(f - sp);

    float s = smoothstep(size_px / 700.0, 0.0, d);

    float tw = 1.0 + twinkle * (sin(TIME*5.0 + r*40.0) * 0.5);
    return make_star * s * tw;
}

void fragment(){
    vec2 uv = UV;

    vec4 col = bg_color;

    float s1 = star_layer(uv, -speed*1.0,  60.0, density*0.75);
    float s2 = star_layer(uv, -speed*0.6, 120.0, density*0.50);
    float s3 = star_layer(uv, -speed*0.35,220.0, density*0.35);

    float s = s1 + s2 + s3;
    col.rgb = mix(col.rgb, star_color.rgb, clamp(s, 0.0, 1.0));

    COLOR = col;
}
