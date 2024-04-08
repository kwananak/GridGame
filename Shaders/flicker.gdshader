shader_type canvas_item;

uniform float brightness : hint_range(1.0, 2) = 1;
uniform float brightness_drop_percent : hint_range(0, 1) = 1.0;
uniform float glow_period : hint_range(0.01, 4) = 1.0;
uniform float flicker_period : hint_range(2, 40) = 10.0;
uniform float flicker_spikes_sharpness : hint_range(1, 40) = 30.0;

void fragment() {
	vec4 tex = vec4(1.0, 1.0, 1.0, 0.05);
	COLOR = tex;
	
	float flicker = sin(TIME * (flicker_period * sin(TIME) * flicker_period * 0.3));
	float graph = (sin(TIME * glow_period) * flicker_spikes_sharpness - (flicker_spikes_sharpness - 1.0));
	graph = float(graph > 0.0);
	
	float cycle = smoothstep(0.9, 0.95, graph * flicker);
	
	COLOR.rgb *= brightness - brightness_drop_percent * cycle;
}
