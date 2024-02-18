import funkin.editors.charter.CharterSelection;

// GO FUCK YOURSELF FUCK OFF I HATE YOU SO FUCKING MUCH OH MY GODDD
function create() {
	FlxG.width = FlxG.initialWidth = 1280;
	FlxG.height = FlxG.initialHeight = 720;
	window.resize(1280, 720);
	FlxG.camera.setSize(1280, 720);
}

function destroy() {
	if (FlxG.game._requestedState is CharterSelection) return;
	FlxG.width = FlxG.initialWidth = 400;
	FlxG.height = FlxG.initialHeight = 400;
	window.resize(800, 800);
	FlxG.camera.setSize(400, 400);
}