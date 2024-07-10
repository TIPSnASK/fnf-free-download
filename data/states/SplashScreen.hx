import haxe.io.Path;
import funkin.backend.MusicBeatState;

function create() {
	var _splashList:Array<String> = [for (_i in Paths.getFolderContent('images/splash-screens')) Path.withoutExtension(_i)];
	var _selected:String = _splashList[FlxG.random.int(0, _splashList.length-1)];
	var splash:FunkinSprite = new FunkinSprite();
	splash.loadSprite(Paths.image('splash-screens/${_selected}'));
	splash.setGraphicSize(400, 400);
	splash.updateHitbox();
	splash.animation.addByPrefix('anim', _selected, switch _selected {
		default: 24;
		case 'dancing': 3;
	}, true);
	splash.playAnim('anim');
	add(splash);

	new FlxTimer().start(2, function() {
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.switchState(new ModState('Title'));
	});
}