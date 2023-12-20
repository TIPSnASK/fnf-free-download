FlxG.width = FlxG.initialWidth = FlxG.height = FlxG.initialHeight = 400;
window.resize(800, 820);
window.resizable = false;

function preStateSwitch() {
	if (FlxG.game._requestedState is TitleState)
		FlxG.game._requestedState = new ModState('backend/editors/FreeCharEditor');
}

function postStateSwitch()
	for (camera in FlxG.cameras.list)
		camera.pixelPerfectRender = true;