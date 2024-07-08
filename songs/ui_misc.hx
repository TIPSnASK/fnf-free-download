var _speed:Float = 1;

function create() {
	if (playCutscenes)
		cutscene = Paths.script('data/scripts/cutscene');
}

function postCreate() {
	camZoomingStrength = 0;

	for (sL in strumLines.members)
		if (!sL.cpu)
			sL.cpu = FlxG.save.data.freeBOTPLAY;
}

function postUpdate(e:Float) {
	if (FlxG.keys.pressed.TWO) _speed -= 0.01;
	if (FlxG.keys.justPressed.THREE) _speed = 1;
	if (FlxG.keys.pressed.FOUR) _speed += 0.01;
	
	FlxG.timeScale = inst.pitch = vocals.pitch = _speed;
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