import sys.FileSystem;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxSpriteUtil;
import funkin.backend.assets.ModsFolder;
import haxe.io.Path;

var wiggle:CustomShader = new CustomShader('wiggle');
var wiggle2:CustomShader = new CustomShader('wiggle');

var backdrop1:FlxBackdrop;
var backdrop2:FlxBackdrop;
var image:FunkinSprite;

function create() {
	FlxG.sound.music.pitch = 0.1;

	var _filesArray:Array<String> = FileSystem.readDirectory('mods/${ModsFolder.currentModFolder}/images/menus/discord/');
	image = new FunkinSprite().loadGraphic(Paths.image('menus/discord/${Path.withoutExtension(_filesArray[FlxG.random.int(0, _filesArray.length-1)])}'));
	image.scrollFactor.set();
	image.zoomFactor = 0;
	image.scale.set(1, 1);
	add(image);

	var _splashTextArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('secret'));
	var text:FunkinText = new FunkinText(0, 0, 0, FlxG.random.int(0, 100) == 64 ? "THE SERVER IS GONE, WHY ARE YOU STILL LOOKING FOR IT?" : _splashTextArray[FlxG.random.int(0, _splashTextArray.length-1)], 16, false);
	text.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	text.textField.antiAliasType = 0; // advanced
	text.textField.sharpness = 400; // max i think idk thats what it says
	text.font = Paths.font("Pixellari.ttf");

	var spr:FunkinSprite = gradientText(text, [FlxG.random.color(0xFF8B8B8B, 0xFFFFFFFF, 1, false), 0xFF000000]);

	var speed:Float = FlxG.random.float(5, 100);

	backdrop1 = new FlxBackdrop(spr.pixels, FlxAxes.XY, 0, spr.height);
	backdrop1.y = 12;
	backdrop1.shader = wiggle;
	add(backdrop1);

	backdrop2 = new FlxBackdrop(spr.pixels, FlxAxes.XY, 0, spr.height);
	backdrop2.y = -8;
	backdrop2.shader = wiggle2;
	add(backdrop2);

	if (image.visible = FlxG.random.bool(5)) {
		backdrop1.alpha = backdrop2.alpha = FlxG.random.float(0.15, 0.25);
		backdrop2.velocity.x = -(backdrop1.velocity.x = speed);

		wiggle.wIntensity = -FlxG.random.float(0.025, 0.1);
		wiggle.wStrength = FlxG.random.float(2, 4);
		wiggle.wSpeed = FlxG.random.float(0.5, 1);

		wiggle2.wIntensity = FlxG.random.float(0.025, 0.1);
		wiggle2.wStrength = FlxG.random.float(2, 4);
		wiggle2.wSpeed = FlxG.random.float(0.5, 1);
	} else {
		backdrop1.alpha = FlxG.random.float(0.5, 1);
		backdrop2.alpha = FlxG.random.float(0.5, 1);
		backdrop2.velocity.x = -(backdrop1.velocity.x = speed/10);

		wiggle.wIntensity = -FlxG.random.float(0.025, 0.05);
		wiggle.wStrength = FlxG.random.float(1, 2);
		wiggle.wSpeed = FlxG.random.float(0.2, 0.5);

		wiggle2.wIntensity = FlxG.random.float(0.025, 0.05);
		wiggle2.wStrength = FlxG.random.float(1, 2);
		wiggle2.wSpeed = FlxG.random.float(0.2, 0.5);
	}

	var vignette:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('effects/vignette'));
	vignette.scrollFactor.set();
	vignette.zoomFactor = 0;
	add(vignette);
}

var _timer:Float = 0;
function update(e:Float) {
	_timer += e;
	wiggle.elapsed = _timer;
	wiggle2.elapsed = _timer;

	if (image.visible) {
		backdrop1.y = 12 + (Math.sin(_timer * 2) + 1) * 4; // tank you wizard 🙏
		backdrop2.y = -8 + (Math.sin(_timer * 2) + 1) * 4; // tank you wizard 🙏
	}

	if (controls.BACK) {
		ModsFolder.switchMod(ModsFolder.currentModFolder);
	}
}

function destroy() {
	FlxG.sound.music.pitch = 1;
}