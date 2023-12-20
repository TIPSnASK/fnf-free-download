import funkin.backend.MusicBeatState;

function create() {
	var splash:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('splash'));
	add(splash);

	new FlxTimer().start(2, function() {
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.switchState(new ModState('menus/Title'));
	});
}