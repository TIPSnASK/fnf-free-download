function create() {
	if (playCutscenes)
		cutscene = Paths.script('data/scripts/cutscene');
}

function postCreate() {
	camZoomingStrength = 0;
}

function onGamePause(event) {
	event.cancel();

	persistentUpdate = false;
	persistentDraw = true;
	paused = true;

	openSubState(new ModSubState('substates/game/Pause'));
}

function onGameOver(event) {
	event.cancel();
	if (curStep < 0) return;
	boyfriend.stunned = true;

	persistentUpdate = false;
	persistentDraw = false;
	paused = true;

	vocals.stop();
	if (FlxG.sound.music != null)
		FlxG.sound.music.stop();
	for (strumLine in strumLines.members) strumLine.vocals.stop();

	openSubState(new ModSubState('substates/game/Over'));
}

function onSongEnd() {
	fromGame = false;
}