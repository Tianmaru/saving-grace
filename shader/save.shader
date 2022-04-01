shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if(1.0 - UV.y > progress) {
		COLOR.rgb = vec3(0.0, 0.0, 0.0);
	}
}