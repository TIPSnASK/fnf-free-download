import flixel.FlxState;
import funkin.editors.charter.CharterSelection;
import funkin.editors.character.CharacterSelection;
import funkin.editors.UIDebugState;
import funkin.editors.DebugOptions;
import funkin.editors.ui.UIState;
import Type;

var options:Array<{name:String, state:FlxState}> = [
	{
		name: 'Chart Editor',
		state: CharterSelection
	},
	{
		name: 'Character Editor',
		state: CharacterSelection
	},
	{
		name: 'UI Debug State',
		state: UIDebugState
	},
	{
		name: 'Debug Options',
		state: DebugOptions
	}
];

var subCam:FlxCamera;
var curSelected:Int = 0;

var _lastMouseVisible:Bool = FlxG.mouse.visible;

function create() {
	FlxG.mouse.visible = true;

	subCam = new FlxCamera();
	subCam.bgColor = 0;
	FlxG.cameras.add(subCam, false);

	for (index => name in Paths.getFolderDirectories('data/states/editors'))
		options.push({name: name, state: UIState});

	for (index => data in options) {
		var bg:FunkinSprite = new FunkinSprite(0, (Std.int(FlxG.height/options.length))*index).makeGraphic(FlxG.width, Std.int(FlxG.height/options.length), 0xFF000000);
		bg.cameras = [subCam];
		bg.alpha = curSelected == index ? 0.75 : 0.5;
		add(bg);
		bg.onDraw = (spr:FlxSprite) -> {
			if (FlxG.mouse.overlaps(spr)) curSelected = index;

			spr.alpha = lerp(spr.alpha, curSelected == index ? 0.75 : 0.5, 0.32);
			spr.draw();
		}

		var text:FunkinText = new FunkinText(10, bg.y + 13, bg.width, data.name, 32, true);
		text.cameras = [subCam];
		text.font = Paths.font("Pixellari.ttf");
		text.textField.antiAliasType = 0;
		text.textField.sharpness = 400;
		text.borderSize = 3;
		add(text);
		var mult:Float = 0.75;
		text.onDraw = (spr:FlxSprite) -> {
			mult = lerp(mult, curSelected == index ? 1 : 0.75, 0.32);
			spr.setColorTransform(mult, mult, mult);
			spr.draw();
		}
	}
}

function update(elapsed:Float) {
	if (controls.BACK) close();

	if (controls.DOWN_P || controls.UP_P) curSelected = FlxMath.wrap(curSelected + (controls.DOWN_P ? 1 : -1), 0, options.length-1);

	if (controls.ACCEPT || FlxG.mouse.justPressed) {
		FlxG.sound.play(Paths.sound("menus/snd_josh")).persist = true;
		currentEditor = options[curSelected].name;
		FlxG.switchState(Type.createInstance(options[curSelected].state, options[curSelected].state == UIState ? [true, 'editors/${options[curSelected].name}/state'] : []));
	}
}

function onClose() {
	FlxG.cameras.remove(subCam, true);
	FlxG.mouse.visible = _lastMouseVisible;
}