import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import funkin.backend.assets.ModsFolder;
import funkin.savedata.FunkinSave;
import Xml;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

var weeknds:Array<Xml> = [for (i in FileSystem.readDirectory('mods/${ModsFolder.currentModFolder}/data/weeknds/')) Xml.parse(Assets.getText(Paths.file('data/weeknds/${i}'))).firstElement()];
var songs:Array<Xml> = [];

var _songsFolder:Array<String> = [for (i in FileSystem.readDirectory('mods/${ModsFolder.currentModFolder}/songs/')) Path.withoutExtension(i)];
var _textArray:Array<FunkinText> = [];
var _iconArray:Array<FunkinSprite> = [];
var _infoArray:Array<FunkinText> = [];
var _colors:Array<FlxColor> = [];
var _songDatas:Array<{name:String, diff:String}> = [];
var _modes:Array<String> = ["$normal mode$", '%opponent mode%', '#coop mode#'];
var _selectedMode:Int = 0;

var bg:FunkinSprite;
var modeText:FunkinText;

var curSelected:Int = 0;
var camY:Float = 0;

var normalFormat:FlxTextFormat = new FlxTextFormat(0xFF00FF62, true);
var opponentModeFormat:FlxTextFormat = new FlxTextFormat(0xFFFF0055, true);
var coopModeFormat:FlxTextFormat = new FlxTextFormat(0xFF0099FF, true);

var markupRules:Array<FlxTextFormatMarkerPair> = [
	new FlxTextFormatMarkerPair(normalFormat, "$"),
	new FlxTextFormatMarkerPair(opponentModeFormat, "%"),
	new FlxTextFormatMarkerPair(coopModeFormat, "#")
];

function create() {
	playMenuMusic();
	
	bg = new FunkinSprite(-400, -50).loadGraphic(Paths.image('menus/backgrounds/4'));
	bg.scrollFactor.set(0, 0.25);
	bg.scale.set(2, 2);
	bg.updateHitbox();
	add(bg);

	for (weekndIndex => weekndNode in weeknds) {
		for (songIndex => songNode in [for (_i in weekndNode.elementsNamed('song')) _i]) {
			if (!_songsFolder.contains(songNode.get('name'))) continue;
			var text:FunkinText = new FunkinText(32, (40 * (weekndIndex + songIndex)), 0, songNode.exists('display') ? songNode.get('display') : songNode.get('name'), 16, true);
			text.antialiasing = false;
			// lunarcleint figured this out thank you lunar holy shit 🙏
			text.textField.antiAliasType = 0; // advanced
			text.textField.sharpness = 400; // max i think idk thats what it says
			text.font = Paths.font("Pixellari.ttf");
			text.borderSize = 2;
			add(text);
			_textArray.push(text);

			var meta:Json = Json.parse(Assets.getText(Paths.file('songs/${songNode.get('name')}/meta.json')));
			var icon:FunkinSprite = new FunkinSprite(FlxG.width - 175).loadGraphic(Paths.image('menus/freeplay/characters/${meta.icon}'));
			icon.scrollFactor.set(1, 5);
			icon.y = (-icon.height - 52) - 630 + (202 * (weekndIndex+songIndex));
			add(icon);
			_iconArray.push(icon);

			var saveInfo = FunkinSave.getSongHighscore(songNode.get('name'), weekndNode.get('rating'));
			var info:FunkinText = new FunkinText(icon.x, icon.y + icon.height + 2, icon.width, 'Score: ${saveInfo.score}\nMisses: ${saveInfo.misses}', 16, true);
			info.alignment = 'center';
			info.antialiasing = false;
			// lunarcleint figured this out thank you lunar holy shit 🙏
			info.textField.antiAliasType = 0; // advanced
			info.textField.sharpness = 400; // max i think idk thats what it says
			info.font = Paths.font("Pixellari.ttf");
			info.borderSize = 2;
			info.scrollFactor.set(icon.scrollFactor.x, icon.scrollFactor.y);
			add(info);
			_infoArray.push(info);

			var _timer:Float = 0;
			icon.onDraw = text.onDraw = info.onDraw = (spr:FlxSprite) -> {
				_timer += FlxG.elapsed;
				if (spr == info) {
					spr.y = icon.y + icon.height + 2 + (Math.sin(_timer+(weekndIndex+songIndex)) + 1) * 1.5; // tank you wizard 🙏
				}
				
				spr.colorTransform.color = 0xFF000000;
				spr.offset.set(0, -4);
				spr.draw();

				if (spr == icon) {
					spr.offset.set();
					spr.setGraphicSize(spr.width + 2, spr.height + 2);
					spr.draw();
					spr.setGraphicSize(spr.width - 2, spr.height - 2);
				}

				var mult:Float = curSelected == weekndIndex+songIndex ? 1 : 0.75;
				spr.setColorTransform(mult, mult, mult);
				spr.offset.set();
				spr.draw();
			}

			_songDatas.push({name: songNode.get('name'), diff: weekndNode.get('rating')});
			songs.push(songNode);
		}
	}

	_colors = rainbow(_textArray.length, 0.75, 1.25, 1);

	select(0);
}

function postCreate() {
	var _underlay:FunkinSprite = new FunkinSprite().makeGraphic(FlxG.width, 25, 0x67000000);
	_underlay.scrollFactor.set();
	_underlay.zoomFactor = 0;
	_underlay.y = FlxG.height - _underlay.height;
	add(_underlay);

	modeText = new FunkinText(_underlay.x, _underlay.y + 3, _underlay.width, '< ${_modes[_selectedMode]} >', 16, true);
	modeText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	modeText.textField.antiAliasType = 0; // advanced
	modeText.textField.sharpness = 400; // max i think idk thats what it says
	modeText.font = Paths.font("Pixellari.ttf");
	modeText.borderSize = 2;
	modeText.scrollFactor.set();
	modeText.alignment = 'center';
	add(modeText);
	modeText.applyMarkup(modeText.text, markupRules);
}

function select(index:Int) {
	FlxTween.cancelTweensOf(bg);
	camY = _textArray[curSelected = index].y - (FlxG.width/2) + 8;
	FlxTween.color(bg, 1, bg.color, _colors[index], {ease: FlxEase.cubeOut});
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT) FlxG.switchState(new ModState('menus/Freeplay'));
	if (controls.BACK) FlxG.switchState(new ModState('MainMenu'));

	if (controls.LEFT_P || controls.RIGHT_P) {
		_selectedMode = FlxMath.wrap(_selectedMode + (controls.LEFT_P ? -1 : 1), 0, _modes.length-1);
		modeText.text = '< ${_modes[_selectedMode]} >';
		modeText.applyMarkup(modeText.text, markupRules);
	}
	if (controls.DOWN_P || controls.UP_P) select(FlxMath.wrap(curSelected + (controls.DOWN_P ? 1 : -1), 0, _textArray.length-1));

	if (controls.ACCEPT) {
		PlayState.loadSong(_songDatas[curSelected].name, _songDatas[curSelected].diff, _selectedMode == 1, _selectedMode == 2);
		FlxG.sound.play(Paths.sound("menus/snd_josh")).persist = true;
		FlxG.switchState(new PlayState());
	}

	FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, camY, 0.12);
}