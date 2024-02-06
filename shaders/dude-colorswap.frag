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
	vec4 pixelColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
	
	float range = 5.0 / 255.0;

	if(abs(pixelColor.r - colorHat.r) <= range) {
		if(abs(pixelColor.g - colorHat.g) <= range) {
			if(abs(pixelColor.b - colorHat.b) <= range) {
				pixelColor.rgb = colorReplaceHat.rgb;
			}
		}
	}
	if(abs(pixelColor.r - colorSkin.r) <= range) {
		if(abs(pixelColor.g - colorSkin.g) <= range) {
			if(abs(pixelColor.b - colorSkin.b) <= range) {
				pixelColor.rgb = colorReplaceSkin.rgb;
			}
		}
	}
	if(abs(pixelColor.r - colorHair.r) <= range) {     
		if(abs(pixelColor.g - colorHair.g) <= range) {
			if(abs(pixelColor.b - colorHair.b) <= range) {
				pixelColor.rgb = colorReplaceHair.rgb;
			} 
		}
	}
	
	
	if(abs(pixelColor.r - colorShirt.r) <= range) {
		if(abs(pixelColor.g - colorShirt.g) <= range) {
			if(abs(pixelColor.b - colorShirt.b) <= range) {
				pixelColor.rgb = colorReplaceShirt.rgb;
			}
		}
	}
	if(abs(pixelColor.r - colorStripe.r) <= range) {
		if(abs(pixelColor.g - colorStripe.g) <= range) {
			if(abs(pixelColor.b - colorStripe.b) <= range) {
				pixelColor.rgb = colorReplaceStripe.rgb;
			}
		}
	}
	
	
	if(abs(pixelColor.r - colorPants.r) <= range) {
		if(abs(pixelColor.g - colorPants.g) <= range) {
			if(abs(pixelColor.b - colorPants.b) <= range) {
					pixelColor.rgb = colorReplacePants.rgb;
			}
		}
	}
	if(abs(pixelColor.r - colorShoes.r) <= range) {
		if(abs(pixelColor.g - colorShoes.g) <= range) {
			if(abs(pixelColor.b - colorShoes.b) <= range) {
				pixelColor.rgb = colorReplaceShoes.rgb;
			}
		}
	}
	
	gl_FragColor = pixelColor;
}