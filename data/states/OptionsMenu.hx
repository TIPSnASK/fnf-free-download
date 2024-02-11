// codename engine i love you but why are you so Bitchy today
function create() {
	FlxG.width = FlxG.initialWidth = 1280;
	FlxG.height = FlxG.initialHeight = 720;
	window.resize(1280, 720);
	FlxG.camera.setSize(1280, 720);
}

function destroy() {
	FlxG.width = FlxG.initialWidth = 400;
	FlxG.height = FlxG.initialHeight = 400;
	window.resize(800, 800);
	FlxG.camera.setSize(400, 400);
}