import haxe.io.Path;
import funkin.backend.MusicBeatState;

function create() {
	var _splashList:Array<String> = [for (_i in Paths.getFolderContent('images/splash-screens')) Path.withoutExtension(_i)];
	var splash:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('splash-screens/${_splashList[FlxG.random.int(0, _splashList.length-1)]}'));
	splash.setGraphicSize(400, 400);
	splash.updateHitbox();
	add(splash);

	new FlxTimer().start(2, function() {
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.switchState(new ModState('Title'));
	});
}