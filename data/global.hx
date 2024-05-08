import funkin.backend.MusicBeatState;
import lime.graphics.Image;
import funkin.options.Options;
import flixel.system.ui.FlxSoundTray;
import funkin.backend.system.framerate.Framerate;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxGradient;
import Xml;
import sys.FileSystem;
import sys.io.File;
import openfl.system.Capabilities;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.group.FlxSpriteGroup;

import karaoke.backend.util.FlxColorHelper;

static var FlxColorHelper = new FlxColorHelper();

FlxG.width = FlxG.initialWidth = 400;
FlxG.height = FlxG.initialHeight = 400;
window.resize(FlxG.width*2, FlxG.height*2);

static var initialized:Bool = false;
static var fromGame:Bool = false; // for things you can go to through the pause menu and stuff

static var noteskin:String = "default";

static var editingSkinType:String = "lady";
static var currentSkinToEdit:String = "default";

static var redirectStates:Map<FlxState, String> = [
	MainMenuState => 'MainMenu',
	StoryMenuState => 'menus/StoryMenu',
	FreeplayState => 'menus/Freeplay'
];

static function getFavColor(type:String):FlxColor {
	var userXml:Xml = Xml.parse(File.getContent('mods/fnffdcne-data.xml')).firstElement();
	return FlxColor.fromString(getSkinXml(type, [for (_i in userXml.elementsNamed('skins')) _i][0].get('selected${type}')).get('fav'));
}

static function applyPlayerSkin(shader:CustomShader, type:String):FlxColor {
	var userXml:Xml = Xml.parse(File.getContent('mods/fnffdcne-data.xml')).firstElement();
	return applySkin(shader, type, [for (_i in userXml.elementsNamed('skins')) _i][0].get('selected${type}'));
}

static function getIdentityXml():Xml {
	var userXml:Xml = Xml.parse(File.getContent('mods/fnffdcne-data.xml')).firstElement();
	return [for (_i in userXml.elementsNamed('identities')) _i][0];
}

static function getAllSkinXmls(type:String):Array<Xml> {
	var defXml:Xml = Xml.parse(Assets.getText(Paths.xml("def-skins"))).firstElement();
	var userXml:Xml = Xml.parse(File.getContent('mods/fnffdcne-data.xml')).firstElement();
	var userSkinsXml:Xml = [for (_i in userXml.elementsNamed('skins')) _i][0];
	var elements:Array<Xml> = [for (i in defXml.elementsNamed(type)) i];
	for (i in userSkinsXml) if (i.nodeName == type) elements.push(i);
	return elements;
}

static function getSkinXml(type:String, name:String):Xml {
	var returnXml:Xml = null;
	for (skin in getAllSkinXmls(type)) {
		if (skin.get("name") == name) {
			returnXml = skin;
			break;
		}
	}
	return returnXml;
}

// dumbass name but its funny
static function shaderifySkinXml(shader:CustomShader, xml:Xml) {
	switch xml.nodeName {
		default: // um??
		case "dude":
			shader.colorReplaceHat = FlxColorHelper.vec4(FlxColor.fromString(xml.get("hat")));
			shader.colorReplaceSkin = FlxColorHelper.vec4(FlxColor.fromString(xml.get("skin")));
			shader.colorReplaceHair = FlxColorHelper.vec4(FlxColor.fromString(xml.get("hair")));
			
			shader.colorReplaceShirt = FlxColorHelper.vec4(FlxColor.fromString(xml.get("shirt")));
			shader.colorReplaceStripe = FlxColorHelper.vec4(FlxColor.fromString(xml.get("stripe")));
			
			shader.colorReplacePants = FlxColorHelper.vec4(FlxColor.fromString(xml.get("pants")));
			shader.colorReplaceShoes = FlxColorHelper.vec4(FlxColor.fromString(xml.get("shoes")));
		case "lady":
			shader.colorReplaceSkin = FlxColorHelper.vec4(FlxColor.fromString(xml.get("skin")));
			shader.colorReplaceHair = FlxColorHelper.vec4(FlxColor.fromString(xml.get("hair")));
			shader.colorReplaceDye = FlxColorHelper.vec4(FlxColor.fromString(xml.get("dye")));
			
			shader.colorReplaceShirt = FlxColorHelper.vec4(FlxColor.fromString(xml.get("shirt")));
			
			shader.colorReplaceShorts = FlxColorHelper.vec4(FlxColor.fromString(xml.get("shorts")));
			shader.colorReplaceSocks = FlxColorHelper.vec4(FlxColor.fromString(xml.get("socks")));
			shader.colorReplaceShoes = FlxColorHelper.vec4(FlxColor.fromString(xml.get("shoes")));
	}
	if (xml.exists("fav"))
		return FlxColor.fromString(xml.get("fav"));
	else return null;
}

static function applySkin(shader:CustomShader, type:String, name:String) {
	return shaderifySkinXml(shader, getSkinXml(type, name));
}

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

// thanks katie 🔥
static function rainbow(amount:Int, s:Float, b:Float, a:Float):Array<FlxColor> {
	var _colors:Array<FlxColor> = [];
	for (_i in 0...amount)
		_colors.push(FlxColor.fromHSB(_i/amount*360, s, b, a));
	return _colors;
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

static function playMenuMusic() {
	if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
		CoolUtil.playMusic(Paths.music('mus_menu'), true, 1, true, 110);
		FlxG.sound.music.persist = true;
	}
}

function new() {
	if (FlxG.camera != null)
		FlxG.camera.bgColor = 0xFF000000;

	if (FlxG.save.data.freeINTROSPLASH == null) FlxG.save.data.freeINTROSPLASH = true;
	if (FlxG.save.data.freeFLASH == null) FlxG.save.data.freeFLASH = true;
	if (FlxG.save.data.freeFPS == null) FlxG.save.data.freeFPS = true;
	if (FlxG.save.data.freeFULLSCREENEASTEREGG == null) FlxG.save.data.freeFULLSCREENEASTEREGG = true;
	if (FlxG.save.data.freeAUTOHIDEFPS == null) FlxG.save.data.freeAUTOHIDEFPS = true;
	if (FlxG.save.data.freeDXSTRUMS == null) FlxG.save.data.freeDXSTRUMS = false;
	if (FlxG.save.data.freeBOTPLAY == null) FlxG.save.data.freeBOTPLAY = false;

	if (!FileSystem.exists('mods/fnffdcne-data.xml'))
		File.saveContent('mods/fnffdcne-data.xml', '<data>\n\t<skins selecteddude="default" selectedlady="default"></skins>\n\t<identities dudename="Dude" dudeprns="He/Him/His" ladyname="Lady" ladyprns="She/Her/Hers"/>\n</data>');

	window.title = "Made with FNF: Codename Engine";
	changeWindowIcon("default");

	FlxG.width = FlxG.initialWidth = 400;
	FlxG.height = FlxG.initialHeight = 400;
	window.resize(FlxG.width*2, FlxG.height*2);
	window.resizable = true;
	for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);

	window.x = (Capabilities.screenResolutionX / 2) - (window.width / 2);
	window.y = (Capabilities.screenResolutionY / 2) - (window.height / 2);

	FlxG.mouse.load(Paths.image("cursor"), 1.25, -8, -5);
	FlxG.mouse.useSystemCursor = false;
}

function preStateSwitch() {
	if (!initialized) {
		initialized = true;
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.game._requestedState = FlxG.save.data.freeINTROSPLASH ? new ModState('SplashScreen') : new ModState('Title');
	}

	for (stupid => smart in redirectStates) {
		if (FlxG.game._requestedState is stupid) {
			FlxG.game._requestedState = new ModState(smart);
		}
	}
}

public var fullscreenSound:FlxSound;
public var volumeCam:FlxCamera;
public var volumeTray:FunkinSprite;
public var volumeBar:FlxBar;
public var volumeGroup:FlxSpriteGroup;
var _hideSTTimer:FlxTimer;
var _stAlphaTween:FlxTween;
function postStateSwitch() {
	if (FlxG.save.data.freeAUTOHIDEFPS) Framerate.debugMode = 0;

	FlxSoundTray.volumeUpChangeSFX = Paths.sound("volume/snd_ribbit1");
	FlxSoundTray.volumeDownChangeSFX = Paths.sound("volume/snd_ribbit2");
	FlxG.sound.volumeHandler = soundTray;
	FlxG.sound.soundTray.alpha = 0;

	window.title = "Made with FNF: Codename Engine";

	for (cam in FlxG.cameras.list) {
		cam.antialiasing = false;
	}

	fullscreenSound = FlxG.sound.load(Paths.sound("sfx/snd_weirdnoise"));
	fullscreenSound.persist = true;

	FlxG.autoPause = FlxG.save.data.freeTOLOOKAWAY;

	if (FlxG.save.data.freeFPS) FlxG.drawFramerate = FlxG.updateFramerate = 40;
	else FlxG.drawFramerate = FlxG.updateFramerate = Options.framerate;

	volumeCam = new FlxCamera();
	volumeCam.bgColor = 0;
	FlxG.cameras.add(volumeCam, false);

	volumeGroup = new FlxSpriteGroup();
	volumeGroup.cameras = [volumeCam];
	FlxG.state.add(volumeGroup);

	volumeTray = new FunkinSprite();
	volumeTray.frames = Paths.getSparrowAtlas("volume");
	volumeTray.animation.addByPrefix("unmuted", "unmuted", 0, true);
	volumeTray.animation.addByPrefix("muted", "muted", 0, true);
	volumeGroup.add(volumeTray);

	volumeBar = new FlxBar(354, 134, FlxBarFillDirection.BOTTOM_TO_TOP, 36, 121, null, "", 0, 1, false);
	volumeBar.createFilledBar(0xFF555660, 0xFFDEE0FF, false);
	volumeGroup.add(volumeBar);

	volumeGroup.alpha = 0;

	_hideSTTimer = new FlxTimer();

	FlxG.mouse.useSystemCursor = false;
}

function soundTray(volume:Float) {
	FlxTween.cancelTweensOf(volumeGroup, ["alpha"]);
	FlxTween.tween(volumeGroup, {alpha: 1}, 0.25, {ease: FlxEase.cubeOut});
	_hideSTTimer.cancel();
	if (volume != _vol) volumeGroup.y = volume > _vol ? -5 : 5;
	_vol = volume;
	volumeTray.playAnim(volume < 0.1 ? 'muted' : 'unmuted');

	_hideSTTimer.start(0.5, (t:FlxTimer) -> {FlxTween.tween(volumeGroup, {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});});
}

var pressed:Bool = false; // workaround
var _vol:Float = 0;
function update(elapsed:Float) {
	if (FlxG.fullscreen && FlxG.save.data.freeFULLSCREENEASTEREGG) {
		fullscreenSound.play(true);
		FlxG.fullscreen = false;
	}

	if (FlxG.mouse.justPressed && !pressed) {FlxG.sound.play(Paths.sound("sfx/snd_clickdown"), 0.5); pressed = true;}
	if (FlxG.mouse.justReleased && pressed) {FlxG.sound.play(Paths.sound("sfx/snd_clickup"), 0.5); pressed = false;}

	volumeBar.value = CoolUtil.fpsLerp(volumeBar.value, _vol, 0.25);
	volumeGroup.y = CoolUtil.fpsLerp(volumeGroup.y, 0, 0.25);
}

function destroy() {
	initialized = fromGame = noteskin = editingSkinType = currentSkinToEdit = null;
	FlxG.width = FlxG.initialWidth = 1280;
	FlxG.height = FlxG.initialHeight = 720;
	window.resize(FlxG.width, FlxG.height);
	window.resizable = true;
	FlxG.autoPause = true;
	FlxG.drawFramerate = FlxG.updateFramerate = Options.framerate;

	FlxG.sound.volumeHandler = null;
	FlxG.sound.soundTray.alpha = 1;
}