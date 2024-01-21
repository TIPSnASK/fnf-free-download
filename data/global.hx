import funkin.backend.MusicBeatState;
import funkin.editors.ui.UIState;
import lime.graphics.Image;
import funkin.options.Options;
import flixel.system.ui.FlxSoundTray;
import funkin.backend.system.framerate.Framerate;

FlxG.width = FlxG.initialWidth = 400;
FlxG.height = FlxG.initialHeight = 400;
window.resize(FlxG.width*2, FlxG.height*2);

static var fdInitialized:Bool = false;
static var redirectStates:Map<FlxState, String> = [
	MainMenuState => 'MainMenu',
	StoryMenuState => 'menus/StoryMenu',
	FreeplayState => 'menus/Freeplay'
];

static var fixResStates:Array<FlxState> = [
	UIState
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

function new() {
	if (FlxG.save.data.freeINTROSPLASH == null) FlxG.save.data.freeINTROSPLASH = true;
	if (FlxG.save.data.freeFLASH == null) FlxG.save.data.freeFLASH = true;

	window.title = "Made with FNF: Codename Engine";
	changeWindowIcon("default");

	Options.framerate = 40;
	Options.applySettings();
}

function preStateSwitch() {
	if (!fdInitialized) {
		fdInitialized = true;
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.game._requestedState = FlxG.save.data.freeINTROSPLASH ? new ModState('SplashScreen') : new ModState('Title');
	}

	for (stupid in redirectStates.keys())
		if (FlxG.game._requestedState is stupid) {
			FlxG.game._requestedState = new ModState(redirectStates.get(stupid));
			break;
		}

	for (stupid in fixResStates) {
		var res = [
			FlxG.game._requestedState is stupid ? 1280 : 400,
			FlxG.game._requestedState is stupid ? 720 : 400
		];
		var windowRes = [
			FlxG.game._requestedState is stupid ? 1280 : 800,
			FlxG.game._requestedState is stupid ? 720 : 800
		];
		
		if (FlxG.width == res[0] || FlxG.height == res[1]) return;
	
		FlxG.width = FlxG.initialWidth = res[0];
		FlxG.height = FlxG.initialHeight = res[1];
		window.resize(windowRes[0], windowRes[1]);

		if (!(FlxG.game._requestedState is stupid)) {
			window.x = 560;
			window.y = 126;
		}

		for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);
		break;
	}
}

function postStateSwitch() {
	Framerate.debugMode = 0;

	FlxSoundTray.volumeUpChangeSFX = Paths.sound("volume/snd_ribbit1");
	FlxSoundTray.volumeDownChangeSFX = Paths.sound("volume/snd_ribbit2");
}

function onDestroy() {
	fdInitialized = false;
	FlxG.width = FlxG.initialWidth = 1280;
	FlxG.height = FlxG.initialHeight = 720;
	window.resize(FlxG.width, FlxG.height);
}