import funkin.backend.MusicBeatState;
import funkin.editors.charter.Charter;
import lime.graphics.Image;

// separate them just in case
FlxG.width = FlxG.initialWidth = 400;
FlxG.height = FlxG.initialHeight = 400;
window.resize(FlxG.width*2, FlxG.height*2);

static var initialized:Bool = false;

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

	if (FlxG.game._requestedState is Charter) {
		if (FlxG.width != 1280 || FlxG.height != 720) return;
		
		FlxG.width = FlxG.initialWidth = 1280;
		FlxG.height = FlxG.initialHeight = 720;
		window.resize(FlxG.width, FlxG.height);

		for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);
	} else if (FlxG.width != 400 || FlxG.height != 400) {
		FlxG.width = FlxG.initialWidth = 400;
		FlxG.height = FlxG.initialHeight = 400;
		window.resize(FlxG.width*2, FlxG.height*2);

		for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);
	}
}

function onDestroy() {
	initialized = false;
	FlxG.width = FlxG.initialWidth = 1280;
	FlxG.height = FlxG.initialHeight = 720;
	window.resize(FlxG.width, FlxG.height);
}