import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.input.gamepad.FlxGamepadInputID;
import sys.io.File;

var subCam:FlxCamera;

var list:String = 'GAMEPAD';
var controlList:Array<{name:String, buttons:Array<FlxGamepadInputID>, spr:FunkinText}> = [];
var curSelected:Int = 0;

var titleText:FunkinText; // its like a reference!!!

var _options:Array<String> = ['NOTE_LEFT', 'NOTE_DOWN', 'NOTE_UP', 'NOTE_RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT', 'ACCEPT', 'BACK', 'PAUSE', 'RESET', 'SWITCHMOD'];
var _optionsIni:Array<String> = ['NoteLeft', 'NoteDown', 'NoteUp', 'NoteRight', 'Left', 'Down', 'Up', 'Right', 'Accept', 'Back', 'Pause', 'Reset', 'SwitchMod'];
var _optionsDisplay:Array<String> = ['$(GAME) Left$', '$(GAME) Down$', '$(GAME) Up$', '$(GAME) Right$', '%(MENU) Left%', '%(MENU) Down%', '%(MENU) Up%', '%(MENU) Right%', '%(MENU) Accept%', '%(MENU) Back%', '*Pause*', '*Reset*', '*Switch Mod*'];

var gameFormat:FlxTextFormat = new FlxTextFormat(0xFF00FF62, true);
var menuFormat:FlxTextFormat = new FlxTextFormat(0xFF0099FF, true);
var generalFormat:FlxTextFormat = new FlxTextFormat(0xFFFF96CB, true);
var nullFormat:FlxTextFormat = new FlxTextFormat(0xFFFFA600, true);

var markupRules:Array<FlxTextFormatMarkerPair> = [
	new FlxTextFormatMarkerPair(gameFormat, "$"),
	new FlxTextFormatMarkerPair(menuFormat, "%"),
	new FlxTextFormatMarkerPair(nullFormat, "#"),
	new FlxTextFormatMarkerPair(generalFormat, "*")
];

var controllerBinds:Map<String, String> = IniUtil.parseString(File.getContent('mods/fnffdcne-controller.ini'));
function getKeybinds(control:String) {
	return [for (i in [for (_i in controllerBinds[control].split(',')) Std.parseInt(_i)]) i];
}

function create() {
	subCam = new FlxCamera();
	subCam.bgColor = 0xA8000000;
	FlxG.cameras.add(subCam, false);

	titleText = new FunkinText(0, 25, FlxG.width, 'EDITING ${list} CONTROLS', 16, true);
	titleText.alignment = 'center';
	titleText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	titleText.textField.antiAliasType = 0; // advanced
	titleText.textField.sharpness = 400; // max i think idk thats what it says
	titleText.font = Paths.font("Pixellari.ttf");
	titleText.borderSize = 2;
	titleText.cameras = [subCam];
	add(titleText);

	setup();
}

function setup() {
	for (i in controlList) if (i.spr != null) remove(i.spr);
	controlList = [];
	
	for (index => name in _options) {
		var data = {
			name: name,
			buttons: getKeybinds(_optionsIni[index]),
			spr: null
		}

		var spr:FunkinText;
		data.spr = spr = new FunkinText(25, 55+(25*index), FlxG.width-50, '${_optionsDisplay[index]}: ${FlxGamepadInputID.toStringMap[data.buttons[0]] == null ? '#null#' : FlxGamepadInputID.toStringMap[data.buttons[0]]}', 16, true);
		spr.alignment = 'center';
		spr.antialiasing = false;
		// lunarcleint figured this out thank you lunar holy shit 🙏
		spr.textField.antiAliasType = 0; // advanced
		spr.textField.sharpness = 400; // max i think idk thats what it says
		spr.font = Paths.font("Pixellari.ttf");
		spr.borderSize = 2;
		spr.cameras = [subCam];
		add(spr);
		spr.applyMarkup(spr.text, markupRules);

		var _timer:Float = 0;
		spr.onDraw = (s:FunkinText) -> {
			_timer += FlxG.elapsed;
			if (curSelected == index) {
				spr.alpha = 1;
				spr.y = 55+(25*index) + (Math.sin(_timer * 4) + 1) * 1.5; // tank you wizard 🙏

				spr.colorTransform.color = 0xFF000000;
				spr.offset.set(0, -4);
				spr.draw();

				spr.setColorTransform();
				spr.offset.set();
				spr.draw();
			} else {
				spr.y = 55+(25*index);

				spr.setColorTransform();
				spr.alpha = 0.5;
				spr.offset.set();
				spr.draw();
			}
		}

		controlList.push(data);
	}
}

var _frame1Fix:Bool = false;
var _editing:Bool = false;
var _dontAutoGoBackFFS:FlxTimer = new FlxTimer().start(0.25);
function update(e:Float) {
	if (_frame1Fix) {
		if (!_editing) {
			if (controls.BACK && _dontAutoGoBackFFS.finished) close();

			if (controls.DOWN_P || controls.UP_P) curSelected = FlxMath.wrap(curSelected + (controls.DOWN_P ? 1 : -1), 0, _options.length-1);

			if (controls.ACCEPT && _dontAutoGoBackFFS.finished) {
				_editing = true;
				controlList[curSelected].spr.text = '${_optionsDisplay[curSelected]}: WAITING FOR INPUT...';
				controlList[curSelected].spr.applyMarkup(controlList[curSelected].spr.text, markupRules);
			}
		} else {
			var _theFuckingButton:FlxGamepadInputID = gamepad.firstJustPressedID();
			if (_theFuckingButton != -1) {
				_editing = false;
				controlList[curSelected].buttons = [_theFuckingButton];
				controlList[curSelected].spr.text = '${_optionsDisplay[curSelected]}: ${FlxGamepadInputID.toStringMap[_theFuckingButton]}';
				controlList[curSelected].spr.applyMarkup(controlList[curSelected].spr.text, markupRules);
				controllerBinds[_optionsIni[curSelected]] = Std.string(_theFuckingButton);
				trace(_theFuckingButton, FlxGamepadInputID.toStringMap[_theFuckingButton], gamepad.detectedModel);
				_dontAutoGoBackFFS.start(0.25);
			}
		}
	}
	_frame1Fix = true;
}

function onClose() {
	var _finalIni:String = '';
	for (key => value in controllerBinds)
		_finalIni += '${key} = "${value}"\n';
	File.saveContent('mods/fnffdcne-controller.ini', _finalIni);
	updateGamepadBinds();
	_dontAutoGoBackFFS.destroy();
	FlxG.cameras.remove(subCam, true);
}