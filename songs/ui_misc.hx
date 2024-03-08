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

function onSongEnd() {
	fromGame = false;
}