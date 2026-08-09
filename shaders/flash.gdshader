shader_type canvas_item;

uniform float flash_factor: hint_range(0.0, 1.0, 0.01);
uniform vec3 flash_color: source_color;

void fragment() {
	COLOR.rgb = mix(COLOR.rgb, flash_color, flash_factor);
}
