class FlxColorHelper extends flixel.FlxBasic {
	public function maxColor(color:FlxColor):Int
		return Math.max(redFloat(color), Math.max(greenFloat(color), blueFloat(color)));

	public function minColor(color:FlxColor):Int
		return Math.min(redFloat(color), Math.min(greenFloat(color), blueFloat(color)));

	public function red(color:FlxColor):Int
		return (color >> 16) & 0xff;

	public function green(color:FlxColor):Int
		return (color >> 8) & 0xff;

	public function blue(color:FlxColor):Int
		return (color) & 0xff;

	public function alpha(color:FlxColor):Int
		return (color >> 24) & 0xff;

	public function redFloat(color:FlxColor):Float
		return red(color) / 255;

	public function greenFloat(color:FlxColor):Float
		return green(color) / 255;

	public function blueFloat(color:FlxColor):Float
		return blue(color) / 255;

	public function alphaFloat(color:FlxColor):Float
		return alpha(color) / 255;

	public function hue(color:FlxColor):Float {
		var hueRad = Math.atan2(Math.sqrt(3) * (greenFloat(color) - blueFloat(color)), 2 * redFloat(color) - greenFloat(color) - blueFloat(color));
		var hue:Float = 0;
		if (hueRad != 0)
			hue = 180 / Math.PI * hueRad;

		return hue < 0 ? hue + 360 : hue;
	}

	public function saturation(color:FlxColor):Float
		return (maxColor(color) - minColor(color)) / brightness(color);

	public function brightness(color:FlxColor):Float
		return maxColor(color);

	public function lightness(color:FlxColor):Float
		return (maxColor(color) + minColor(color)) / 2;

	public function cyan(color:FlxColor):Float
		return (1 - redFloat(color) - black(color)) / brightness(color);

	public function magenta(color:FlxColor):Float
		return (1 - greenFloat(color) - black(color)) / brightness(color);

	public function yellow(color:FlxColor):Float
		return (1 - blueFloat(color) - black(color)) / brightness(color);

	public function black(color:FlxColor):Float
		return 1 - brightness(color);

	public function rgb(color:FlxColor):FlxColor
		return color & 0x00ffffff;
}