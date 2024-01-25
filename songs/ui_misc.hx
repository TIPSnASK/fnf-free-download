function create() {
	if (playCutscenes && PlayState.isStoryMode)
		cutscene = Paths.script('data/scripts/cutscene');
}

function postCreate() {
	camZoomingStrength = 0;
}

function onGamePause(event) {
	for (sl in strumLines.members) {
		for (character in sl.characters) {
			var data = {
				anim: character.animation.curAnim,
				context: character.lastAnimContext
			};
			character.playAnim("paused", true);

			new FlxTimer().start(.001, (t:FlxTimer) -> {
				if (character != null)
					character.playAnim(data.anim.name, true, data.context, false, data.anim.curFrame);
				t.destroy();
			});
		}
	}

	event.cancel();

	persistentUpdate = false;
	persistentDraw = true;
	paused = true;

	openSubState(new ModSubState('substates/game/Pause'));
}