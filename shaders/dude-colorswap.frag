#pragma header

// i stole this from source lol
// the two comments below this one are from deklaswas and tyler i think

//If you want to add a new color to swap, make sure you add a new uniform vector and normal vector.
//Basically, just copy the way it is done for preexisting colors

//thank u deklaswas

// whats up guys

// why arent they responding to me :-(

uniform vec4 colorReplaceHat;
uniform vec4 colorReplaceSkin;
uniform vec4 colorReplaceHair;

uniform vec4 colorReplaceShirt;
uniform vec4 colorReplaceStripe;

uniform vec4 colorReplacePants;
uniform vec4 colorReplaceShoes;

vec4 colorHat = vec4(140.0/255.0, 151.0/255.0, 194.0/255.0, 1.0);
vec4 colorSkin = vec4(238.0/255.0, 214.0/255.0, 196.0/255.0, 1.0);
vec4 colorHair = vec4(71.0/255.0, 62.0/255.0, 56.0/255.0, 1.0);

vec4 colorShirt = vec4(215.0/255.0, 121.0/255.0, 156.0/255.0, 1.0);
vec4 colorStripe = vec4(101.0/255.0, 54.0/255.0, 98.0/255.0, 1.0);

vec4 colorPants = vec4(97.0/255.0, 87.0/255.0, 146.0/255.0, 1.0);
vec4 colorShoes = vec4(56.0/255.0, 54.0/255.0, 68.0/255.0, 1.0);

void main()
{
	// texture2D instead of flixel_texture2D so we get the base texture without any modifications
	vec4 pixelColor = texture2D(bitmap, openfl_TextureCoordv);
	
	float range = 3.0 / 255.0;

	if(abs(pixelColor.r - colorHat.r) <= range && abs(pixelColor.g - colorHat.g) <= range && abs(pixelColor.b - colorHat.b) <= range)
		pixelColor.rgb = colorReplaceHat.rgb;
	if(abs(pixelColor.r - colorSkin.r) <= range && abs(pixelColor.g - colorSkin.g) <= range && abs(pixelColor.b - colorSkin.b) <= range)
		pixelColor.rgb = colorReplaceSkin.rgb;
	if(abs(pixelColor.r - colorHair.r) <= range && abs(pixelColor.g - colorHair.g) <= range && abs(pixelColor.b - colorHair.b) <= range)
		pixelColor.rgb = colorReplaceHair.rgb;

	if(abs(pixelColor.r - colorShirt.r) <= range && abs(pixelColor.g - colorShirt.g) <= range && abs(pixelColor.b - colorShirt.b) <= range)
		pixelColor.rgb = colorReplaceShirt.rgb;
	if(abs(pixelColor.r - colorStripe.r) <= range && abs(pixelColor.g - colorStripe.g) <= range && abs(pixelColor.b - colorStripe.b) <= range)
		pixelColor.rgb = colorReplaceStripe.rgb;

	if(abs(pixelColor.r - colorPants.r) <= range && abs(pixelColor.g - colorPants.g) <= range && abs(pixelColor.b - colorPants.b) <= range)
		pixelColor.rgb = colorReplacePants.rgb;
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