import funkin.editors.ui.UIState;

var subCam:FlxCamera;
var names:Array<String> = ['dude', 'lady'];
var characters:Array<FunkinSprite> = [];
var texts:Array<FunkinText> = [];
var curSelected:Int = 0;

function create() {
	subCam = new FlxCamera();
	subCam.bgColor = 0x71000000;
	FlxG.cameras.add(subCam, false);

	for (index => name in names) {
		var spr:FunkinSprite = new FunkinSprite((200*index)-47.5).loadGraphic(Paths.image('editors/skins/portraits/${name}'));
		spr.cameras = [subCam];
		spr.scale.set(0.75, 0.75);
		spr.updateHitbox();
		spr.screenCenter(FlxAxes.Y);
		add(spr);
		characters.push(spr);

		var txt:FunkinText = new FunkinText(spr.x, spr.y + spr.height, spr.width, name, 16, true);
		txt.cameras = [subCam];
		txt.font = Paths.font("COMIC.TTF");
		txt.textField.antiAliasType = 0;
		txt.textField.sharpness = 400;
		txt.borderSize = 2;
		txt.alignment = 'center';
		add(txt);
		texts.push(txt);

		spr.alpha = txt.alpha = index == curSelected ? 1 : 0.5;
	}
}

function select(index:Int) {
	curSelected = index;
	for (_index => spr in characters) spr.alpha = texts[_index].alpha = _index == index ? 1 : 0.5;
}

var _frame1Fix:Bool = false;
function update(e:Float) {
	if (_frame1Fix) {
		if (controls.BACK) close();

		if (controls.LEFT_P || controls.RIGHT_P) select(FlxMath.wrap(curSelected + (controls.LEFT_P ? -1 : 1), 0, characters.length-1));
		if (controls.ACCEPT) {
			editingSkinType = names[curSelected];
			FlxG.switchState(new UIState(true, 'skins/SkinSelector'));
		}
	}
	_frame1Fix = true;
}

function onClose() {
	FlxG.cameras.remove(subCam, true);
}