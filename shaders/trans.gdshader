shader_type canvas_item;

uniform sampler2D transTex;
uniform float transTime;

void fragment() {
	float value = step(transTime, texture(transTex, UV).r);
	COLOR = vec4(vec3(0.0), value);
}
