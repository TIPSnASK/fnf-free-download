import sys.FileSystem;
import funkin.backend.assets.ModsFolder;

var modList:Array<String> = FileSystem.readDirectory('mods/');
var curSelected:Int = 0;
var subCam:FlxCamera;
var camY:Float = 0;

var _options:Array<FunkinText> = [];

function create() {
	subCam = new FlxCamera();
	subCam.bgColor = 0x83000000;
	FlxG.cameras.add(subCam, false);

	for (i in modList) if (!FileSystem.isDirectory('mods/${i}')) modList.remove(i);
	modList.push('[ DISABLE MODS ]');

	for (index => name in modList) {
		var option = new FunkinText(25, 182 + (45 * index), FlxG.width, name, 32, true);
		option.font = Paths.font("Pixellari.ttf");
		option.textField.antiAliasType = 0;
		option.textField.sharpness = 400;
		option.borderSize = 4;
		option.alpha = index == curSelected ? 1 : 0.5;
		option.cameras = [subCam];
		add(option);
		_options.push(option);
		
		option.onDraw = (spr:MenuOption) -> {
			if (curSelected == index) {
				option.alpha = 1;

				option.colorTransform.color = 0xFF000000;
				option.offset.set(0, -4);
				option.draw();

				option.setColorTransform();
				option.offset.set();
				option.draw();
			} else {
				option.setColorTransform();
				option.alpha = 0.5;
				option.offset.set();
				option.draw();
			}
		}
	}
}

function select(index:Int) {
	camY = _options[curSelected = index].y - 182;
}

function update(elapsed:Float) {
	if (controls.BACK) {
		close();
		return;
	}

	if (controls.UP_P || controls.DOWN_P) select(FlxMath.wrap(controls.UP_P ? curSelected + -1 : curSelected + 1, 0, _options.length-1));

	if (controls.ACCEPT) {
		close();
		if (modList[curSelected] != '[ DISABLE MODS ]') ModsFolder.switchMod(modList[curSelected]);
		else ModsFolder.switchMod('');
		return;
	}

	subCam.scroll.y = lerp(subCam.scroll.y, camY, 0.12);
}

function onClose() {
	FlxG.cameras.remove(subCam, true);
}