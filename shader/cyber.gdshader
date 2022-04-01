shader_type canvas_item;

uniform vec4 color : hint_color;
uniform int offset = 0;
uniform int d = 16;
uniform int strength = 1;
uniform float duration = 2.0;
uniform float progress : hint_range(0,1);

bool is_cyber(int coord, float uv) {
	//float progress = mod(TIME, duration)/duration;
	return (coord - offset) % d < strength && uv < 2.0 * progress && uv > 2.0 * (progress - 0.5);
}

void fragment() {
	COLOR = vec4(0);
	if(is_cyber(int(FRAGCOORD.x), UV.y) || is_cyber(int(FRAGCOORD.y), UV.x)) {
		COLOR = color;
	}
}