shader_type canvas_item;

uniform sampler2D perlinNoiseTexture : repeat_enable;
uniform float perlinSize;
uniform float noiseDisplacmentStrength;
uniform float noiseScrollSpeed;
uniform float foamMultiplier;
uniform float foamStrength;
uniform float foamThickness;
uniform sampler2D gradient : source_color;
uniform float dt;
uniform sampler2D tilesTexture;

uniform vec2 rect_min;
uniform vec2 rect_max;

varying vec2 local_pos;
void vertex() {
	local_pos = VERTEX;
}

const vec2 voronoiPoints[20] = {
    vec2(0.12, 0.34),
    vec2(0.78, 0.15),
    vec2(0.45, 0.89),
    vec2(0.91, 0.62),
    vec2(0.23, 0.76),
    vec2(0.56, 0.28),
    vec2(0.34, 0.51),
    vec2(0.67, 0.94),
    vec2(0.08, 0.83),
    vec2(0.84, 0.43),
    vec2(0.39, 0.12),
    vec2(0.72, 0.55),
    vec2(0.17, 0.47),
    vec2(0.63, 0.71),
    vec2(0.96, 0.27),
    vec2(0.49, 0.65),
    vec2(0.29, 0.93),
    vec2(0.54, 0.04),
    vec2(0.03, 0.21),
    vec2(0.88, 0.98)
};

float calculateFoam(vec2 pos){
	vec2 uv01 = (pos - rect_min) / (rect_max - rect_min);
	float value = 0.0;
	float thickness = foamThickness * 0.001;
	ivec2 size = textureSize(tilesTexture, 0);
	if (uv01.x >= -thickness && uv01.x < 1.0 && uv01.y >= -thickness && uv01.y < 1.0) {
		for(int x = -1; x <= 1; x++){
			for(int y = -1; y <= 1; y++){
				value += max(value, texelFetch(tilesTexture, ivec2((uv01 + vec2(float(x), float(y)) * thickness) * vec2(size)), 0).r) * foamStrength * 0.25;
			}
		}
	}
	return clamp(value, 0.0, 1.0);
}

void fragment() {
	float voronoiNoise = 100.0;
	float time = TIME * noiseScrollSpeed * dt;
	vec2 noiseOffset = vec2(texture(perlinNoiseTexture, UV / perlinSize + vec2(sin(time), cos(time))).r - 0.5, texture(perlinNoiseTexture, UV / perlinSize + vec2(cos(time), sin(time))).r - 0.5);
	for (int i = 0; i < 20; i++){
		float dst = length(UV + noiseOffset * noiseDisplacmentStrength - voronoiPoints[i]) * 4.0;
		voronoiNoise = min(dst, voronoiNoise);
	}
	
	float foam = calculateFoam(local_pos + noiseOffset * noiseDisplacmentStrength * foamMultiplier);
	COLOR = vec4(texture(gradient, vec2(voronoiNoise + foam, 0)));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}