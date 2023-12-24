import funkin.backend.MusicBeatState;
import funkin.editors.ui.UIState;
import lime.graphics.Image;

// separate them just in case
FlxG.width = FlxG.initialWidth = 400;
FlxG.height = FlxG.initialHeight = 400;
window.resize(FlxG.width*2, FlxG.height*2);

static var initialized:Bool = false;
static var redirectStates:Map<FlxState, String> = [
	MainMenuState => 'MainMenu',
	StoryMenuState => 'menus/StoryMenu',
	FreeplayState => 'menus/Freeplay'
];

static var fixResStates:Array<FlxState> = [
	UIState
];

function new() {
	if (FlxG.save.data.freeINTROSPLASH == null) FlxG.save.data.freeINTROSPLASH = true;
	if (FlxG.save.data.freeFLASH == null) FlxG.save.data.freeFLASH = true;

	window.title = "Made with FNF: Codename Engine";
    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('icon'))));
}

function preStateSwitch() {
	if (!initialized) {
		initialized = true;
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

		for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);
		break;
	}
}

function onDestroy() {
	initialized = false;
	FlxG.width = FlxG.initialWidth = 1280;
	FlxG.height = FlxG.initialHeight = 720;
	window.resize(FlxG.width, FlxG.height);
}