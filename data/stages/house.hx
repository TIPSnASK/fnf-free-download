// shut up vsc

var sky:FunkinSprite;
function create() {
	insert(0, sky = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xFF91CFDD));
	sky.scrollFactor.set();
	sky.zoomFactor = 0;
}

function onCameraMove(event) {
	if (startingSong) camGame.snapToTarget();
	switch(curCameraTarget) {
		case 0: event.position.set(280, 175);
		case 1: event.position.set(570, 175);
		case 2: event.position.set(450, 175);
	}
}