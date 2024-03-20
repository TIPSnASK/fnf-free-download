public var camera = {
	pos: [
		0 => {x: 265, y: 175},
		1 => {x: 570, y: 175},
		2 => {x: 450, y: 175}
	],

	lock: (x:Float, y:Float) -> {
		_locked = true;
		_lockPos = {x: x, y: y};
	},

	snap: () -> {
		if (_locked)
			camGame.scroll.set(_lockPos.x - camGame.width * 0.5, _lockPos.y - camGame.height * 0.5);
		else
			camGame.scroll.set(camera.pos[curCameraTarget].x - camGame.width * 0.5, camera.pos[curCameraTarget].y - camGame.height * 0.5);
	}
};
var _locked:Bool = false;
var _lockPos:{x:Float, y:Float} = {x: 0, y: 0};

function postCreate() {
	camGame.followLerp = 0.02;
}

function onCameraMove(event) {
	if (startingSong) camGame.snapToTarget();
	if (!_locked)
		event.position.set(camera.pos[curCameraTarget].x, camera.pos[curCameraTarget].y);
	else
		event.position.set(_lockPos.x, _lockPos.y);
}