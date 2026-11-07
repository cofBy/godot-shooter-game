shader_type canvas_item;

uniform float spiralMultiplier;
uniform float transTime;
uniform sampler2D gradient : source_color;
uniform float outerColorRange;

float line(vec2 p, vec2 a, vec2 b) // I stole this from the goat Inigo Quilez
{
    vec2 pa = p-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h );
}

vec2 rotate(vec2 p, vec2 center, float r){
	mat2 rot = mat2(vec2(cos(r), -sin(r)),
	                vec2(sin(r),  cos(r)));
	return (p - center) * rot + center;
}

void fragment() {
	vec2 spirledUV = rotate(UV, vec2(0.5, 0.5), length(UV - vec2(0.5, 0.5)) * spiralMultiplier);
	float trans = 1.5 * line(spirledUV, vec2(0.0, 0.5), vec2(1.0, 0.5));
	float value = step(transTime, trans);
	vec3 color = texture(gradient, vec2(smoothstep(transTime, transTime + outerColorRange, trans), 0.0)).xyz;
	COLOR = vec4(color, value);
}
