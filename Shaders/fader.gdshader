shader_type canvas_item;

uniform bool fade = false;
uniform float speed : hint_range(0.01, 1.0) = 0.5;

void fragment() {
	float saved = texture(TEXTURE, UV).a;
	if (fade && saved < 255.0) COLOR.a = saved + speed;
	else if (saved > 0.0) COLOR.a = saved - speed;
 }
