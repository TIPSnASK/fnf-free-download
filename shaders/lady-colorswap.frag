#pragma header

// i stole this from source lol
// the two comments below this one are from deklaswas and tyler i think

//If you want to add a new color to swap, make sure you add a new uniform vector and normal vector.
//Basically, just copy the way it is done for preexisting colors

//thank u deklaswas

// whats up guys

// why arent they responding to me :-(

uniform vec4 colorReplaceSkin;
uniform vec4 colorReplaceHair;
uniform vec4 colorReplaceDye;

uniform vec4 colorReplaceShirt;

uniform vec4 colorReplaceShorts;
uniform vec4 colorReplaceSocks;
uniform vec4 colorReplaceShoes;

vec4 colorSkin = vec4(243.0/255.0, 224.0/255.0, 203.0/255.0, 1.0);
vec4 colorHair = vec4(198.0/255.0, 192.0/255.0, 179.0/255.0, 1.0);
vec4 colorDye = vec4(88.0/255.0, 61.0/255.0, 95.0/255.0, 1.0);

vec4 colorShirt = vec4(63.0/255.0, 114.0/255.0, 112.0/255.0, 1.0);

vec4 colorShorts = vec4(44.0/255.0, 63.0/255.0, 62.0/255.0, 1.0);
vec4 colorSocks = vec4(187.0/255.0, 201.0/255.0, 208.0/255.0, 1.0);
vec4 colorShoes = vec4(53.0/255.0, 69.0/255.0, 77.0/255.0, 1.0);

void main()
{
	// texture2D instead of flixel_texture2D so we get the base texture without any modifications
	vec4 pixelColor = texture2D(bitmap, openfl_TextureCoordv);
	
	float range = 3.0 / 255.0;

	if(abs(pixelColor.r - colorSkin.r) <= range && abs(pixelColor.g - colorSkin.g) <= range && abs(pixelColor.b - colorSkin.b) <= range)
		pixelColor.rgb = colorReplaceSkin.rgb;
	if(abs(pixelColor.r - colorHair.r) <= range && abs(pixelColor.g - colorHair.g) <= range && abs(pixelColor.b - colorHair.b) <= range)
		pixelColor.rgb = colorReplaceHair.rgb;
	if(abs(pixelColor.r - colorDye.r) <= range && abs(pixelColor.g - colorDye.g) <= range && abs(pixelColor.b - colorDye.b) <= range)
		pixelColor.rgb = colorReplaceDye.rgb;

	if(abs(pixelColor.r - colorShirt.r) <= range && abs(pixelColor.g - colorShirt.g) <= range && abs(pixelColor.b - colorShirt.b) <= range)
		pixelColor.rgb = colorReplaceShirt.rgb;

	if(abs(pixelColor.r - colorShorts.r) <= range && abs(pixelColor.g - colorShorts.g) <= range && abs(pixelColor.b - colorShorts.b) <= range)
		pixelColor.rgb = colorReplaceShorts.rgb;
	if(abs(pixelColor.r - colorSocks.r) <= range && abs(pixelColor.g - colorSocks.g) <= range && abs(pixelColor.b - colorSocks.b) <= range)
		pixelColor.rgb = colorReplaceSocks.rgb;
	if(abs(pixelColor.r - colorShoes.r) <= range && abs(pixelColor.g - colorShoes.g) <= range && abs(pixelColor.b - colorShoes.b) <= range)
		pixelColor.rgb = colorReplaceShoes.rgb;

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