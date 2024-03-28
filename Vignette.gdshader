shader_type canvas_item;
uniform vec2 player_position = vec2(0.5, 0.5);
uniform vec4 color = vec4(0.0, 0.0, 0.0, 0.0);

uniform float MULTIPLIER = 1.0;
uniform float SCALE = 0.6;
uniform float SOFTNESS = 0.6;

void fragment(){
	float val = distance(vec2(UV.x , UV.y * MULTIPLIER), vec2(player_position.x , player_position.y * MULTIPLIER));
	val = val / SCALE;
	float vignette = smoothstep(0.2, SOFTNESS, val);
	COLOR = vec4(color.rgb , vignette );
}
