import free.game.FreeCharacter;

var character:FreeCharacter;

function create() {
	FlxG.camera.bgColor = 0xFFFFFFFF;
	FlxG.camera.scroll.set(-200, -150);

	character = new FreeCharacter(0, 0, 'dude', false);
	add(character);
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT)
		FlxG.switchState(new ModState('backend/editors/FreeCharEditor'));
}