shader_type canvas_item;

uniform float slashRadius;
uniform float thickness : hint_range(0.0, 0.2, 0.01);
uniform vec2 slashCenter;
uniform float multiplierStrength : hint_range(0.01, 0.3, 0.01);
uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform sampler2D perlinNoise : repeat_enable;
uniform float perlinStrength : hint_range(0.0, 10.0, 0.1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float xchange = 2.0 * texture(perlinNoise, UV + vec2(sin(TIME), cos(TIME))).r - 1.0;
	float ychange = 2.0 * texture(perlinNoise, UV + vec2(cos(TIME), sin(TIME))).r - 1.0;
	vec2 coord = UV + vec2(xchange, ychange) / 256.0 * perlinStrength;
	
	float sdf = abs(length(coord - slashCenter) - slashRadius);
	float multiplier = multiplierStrength * (1.0 - coord.x + slashCenter.x);
	float slash = (sdf + multiplier < thickness ? 1.0 : 0.0);
	COLOR = vec4(mix(vec4(0), mix(color1, color2, 1.0 - UV.x), slash));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
