shader_type canvas_item;

uniform bool negative = false;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (negative) COLOR = vec4(1.0 - color.rgb, color.a);
}
