#pragma header

uniform vec4 eyeColor;

void main()
{
	// texture2D instead of flixel_texture2D so we get the base texture without any modifications
	vec4 pixelColor = texture2D(bitmap, openfl_TextureCoordv);
	
	if (pixelColor.rgb = vec3(32/255, 30/255, 40/255)) {
		pixelColor = eyeColor;
	}

	// apply the colorTransform stuff that flixel_texture2D normally does (stolen from FlxGraphicsShader lol!!!)
	if (hasColorTransform) {
		mat4 colorMultiplier = mat4(0);
		colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
		colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
		colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
		colorMultiplier[3][3] = openfl_ColorMultiplierv.w;

		pixelColor = clamp(openfl_ColorOffsetv + (pixelColor * colorMultiplier), 0.0, 1.0);
	}
	
	// alpha fix (also stolen from FlxGraphicsShader)
	if (pixelColor.a > 0.0) {
		gl_FragColor = vec4(pixelColor.rgb * pixelColor.a * openfl_Alphav, pixelColor.a * openfl_Alphav);
	} else {
		gl_FragColor = vec4(pixelColor.rgb / pixelColor.a, pixelColor.a);
	}
}