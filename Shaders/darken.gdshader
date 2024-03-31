shader_type canvas_item;

const float difference = 0.15;
uniform bool darken = false;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	if (darken) COLOR.rgb = tex.rgb - vec3(difference);
	COLOR.a = tex.a;
}
