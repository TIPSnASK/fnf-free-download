import funkin.backend.MusicBeatState;
import lime.graphics.Image;
import funkin.options.Options;
import flixel.system.ui.FlxSoundTray;
import funkin.backend.system.framerate.Framerate;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxGradient;
import Xml;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

import funkin.options.OptionsMenu;
import funkin.editors.charter.Charter;
import funkin.editors.EditorTreeMenu;
import funkin.options.TreeMenu;

FlxG.width = FlxG.initialWidth = 400;
FlxG.height = FlxG.initialHeight = 400;
window.resize(FlxG.width*2, FlxG.height*2);

static var initialized:Bool = false;
static var fromGame:Bool = false; // for things you can go to through the pause menu and stuff

static var redirectStates:Map<FlxState, String> = [
	MainMenuState => 'MainMenu',
	StoryMenuState => 'menus/StoryMenu',
	FreeplayState => 'menus/Freeplay'
];

// IM GONNA KILLL YOUUUUUUU
static var fixResStates:Array<FlxState> = [
	Charter
];

static function flash(cam:FlxCamera, data:{color:FlxColor, time:Float, force:Bool}, onComplete:Void->Void) {
	if (FlxG.save.data.freeFLASH) {
		cam.flash(data.color, data.time, onComplete, data.force);
	} else {
		if (onComplete != null) {
			new FlxTimer().start(data.time, null, onComplete);
		}
	}
}

static function changeWindowIcon(name:String) {
	window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('window-icons/' + name))));
}

static function convertTime(steps:Float, beats:Float, sections:Float):Float {
	return ((Conductor.stepCrochet*steps)/1000 + (Conductor.stepCrochet*(beats*4))/1000 + (Conductor.stepCrochet*(sections*16))/1000)-0.01;
}

static function gradientText(text:FlxText, colors:Array<FlxColor>) {
	return FlxSpriteUtil.alphaMask(
		text,
		FlxGradient.createGradientBitmapData(text.width, text.height, colors),
		text.pixels
	);
}

static function getInnerData(xml:Xml) {
	var it = xml.iterator();
	if (!it.hasNext())
		return null;
	var v = it.next();
	if (it.hasNext()) {
		var n = it.next();
		if (v.nodeType == Xml.PCData && n.nodeType == Xml.CData && StringTools.trim(v.nodeValue) == "") {
			if (!it.hasNext())
				return n.nodeValue;
			var n2 = it.next();
			if (n2.nodeType == Xml.PCData && StringTools.trim(n2.nodeValue) == "" && !it.hasNext())
				return n.nodeValue;
		}
		return null;
	}
	if (v.nodeType != Xml.PCData && v.nodeType != Xml.CData)
		return null;
	return v.nodeValue;
}

static function coolText(text:String):Array<String> {
	var trim:String;
	return [for(line in text.split("\n")) if ((trim = StringTools.trim(line)) != "" && !StringTools.startsWith(trim, "#")) trim];
}

static function loadDudeSkin(shader:CustomShader, name:String) {
	var path:String = Paths.txt("skins/" + name);
	var userSkins = Json.parse(File.getContent("mods/free-download-skins.json"));
	var dumbData:Array<String> = [];

	if (Assets.exists(path))
		dumbData = CoolUtil.coolTextFile(path);
	else {
		for (dumb in userSkins.skins) {
			if (dumb.name == name) {
				dumbData = coolText(dumb.data);
			}
		}
	}

	if (dumbData != []) {
		for (index => line in dumbData) {
			var lineData:Array<Float> = [for (ass in line.split(",")) Std.parseFloat(StringTools.trim(ass))/255];

			// Invalid Cast
			// because life isnt good
			switch(index) {
				case 0: // hat
					shader.colorReplaceHat = lineData;
				case 1: // skin
					shader.colorReplaceSkin = lineData;
				case 2: // hair
					shader.colorReplaceHair = lineData;

				case 3: // shirt
					shader.colorReplaceShirt = lineData;
				case 4: // stripe
					shader.colorReplaceStripe = lineData;

				case 5: // pants
					shader.colorReplacePants = lineData;
				case 6: // shoes
					shader.colorReplaceShoes = lineData;
			}
		}
	} else {
		trace("that skin doesnt exist!");
		loadDudeSkin(shader, "default");
	}
}

static function playMenuMusic() {
	if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
		CoolUtil.playMusic(Paths.music('mus_menu'), true, 1, true, 110);
		FlxG.sound.music.persist = true;
	}
}

function new() {
	if (FlxG.save.data.freeINTROSPLASH == null) FlxG.save.data.freeINTROSPLASH = true;
	if (FlxG.save.data.freeFLASH == null) FlxG.save.data.freeFLASH = true;

	window.title = "Made with FNF: Codename Engine";
	changeWindowIcon("default");

	// Options.framerate = 40; // commented because annoying
	// Options.applySettings();

	if (!FileSystem.exists("mods/free-download-skins.json")) {
		File.saveContent("mods/free-download-skins.json", "{\"selected\": \"default\", \"skins\": []}");
	}

	FlxG.autoPause = false; // sorry but i gotta be biblically accurate or else.....
}

function preStateSwitch() {
	if (!initialized) {
		initialized = true;
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.game._requestedState = FlxG.save.data.freeINTROSPLASH ? new ModState('SplashScreen') : new ModState('Title');
	}

	for (stupid => smart in redirectStates)
		if (FlxG.game._requestedState is stupid) {
			FlxG.game._requestedState = new ModState(smart);
			break;
		}

	for (stupid in fixResStates) {
		window.resizable = FlxG.game._requestedState is stupid;

		var res = [
			FlxG.game._requestedState is stupid ? 1280 : 400,
			FlxG.game._requestedState is stupid ? 720 : 400
		];
		var windowRes = [
			FlxG.game._requestedState is stupid ? 1280 : 800,
			FlxG.game._requestedState is stupid ? 720 : 800
		];
		
		if (FlxG.width == res[0] && FlxG.height == res[1]) return;
	
		FlxG.width = FlxG.initialWidth = res[0];
		FlxG.height = FlxG.initialHeight = res[1];
		window.resize(windowRes[0], windowRes[1]);

		for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);
		break;
	}
}

public var fullscreenSound:FlxSound;
function postStateSwitch() {
	Framerate.debugMode = 0;

	FlxSoundTray.volumeUpChangeSFX = Paths.sound("volume/snd_ribbit1");
	FlxSoundTray.volumeDownChangeSFX = Paths.sound("volume/snd_ribbit2");
	FlxG.sound.soundTray.alpha = 0;

	window.title = "Made with FNF: Codename Engine";

	for (cam in FlxG.cameras.list)
		cam.antialiasing = false;

	fullscreenSound = FlxG.sound.load(Paths.sound("sfx/snd_weirdnoise"));
	fullscreenSound.persist = true;
}

function update(elapsed:Float) {
	if (FlxG.fullscreen) {
		fullscreenSound.play(true);
		FlxG.fullscreen = false;
	}
}

function destroy() {
	initialized = null;
	fromGame = null;
	FlxG.width = FlxG.initialWidth = 1280;
	FlxG.height = FlxG.initialHeight = 720;
	window.resize(FlxG.width, FlxG.height);
	window.resizable = true;
	FlxG.autoPause = true;
}