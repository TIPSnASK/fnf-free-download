#pragma header

uniform vec4 favColor;

void main()
{
	// texture2D instead of flixel_texture2D so we get the base texture without any modifications
	vec4 pixelColor = texture2D(bitmap, openfl_TextureCoordv);

	if(pixelColor.r == 1.0 && pixelColor.g == 0. && pixelColor.b == 0.0)
		pixelColor.rgb = favColor.rgb;

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
	if (pixelColor.a > 0.0) gl_FragColor = vec4(pixelColor.rgb * pixelColor.a * openfl_Alphav, pixelColor.a * openfl_Alphav);
	else gl_FragColor = vec4(pixelColor.rgb / pixelColor.a, pixelColor.a);
}