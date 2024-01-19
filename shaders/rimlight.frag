#pragma header

uniform vec2 offset;
uniform vec3 color;
uniform float intensity;

void main() {
	vec4 c = flixel_texture2D(bitmap, openfl_TextureCoordv);
	vec4 dc = flixel_texture2D(bitmap, openfl_TextureCoordv.xy + offset.xy*vec2(0.005, -0.01).xy);

	gl_FragColor = vec4(mix(c.rgb, color.rgb, intensity*dc.a), c.a);
}