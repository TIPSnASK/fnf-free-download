// shut up vsc

function create() {
	noteskin = uiskin = "gaw";
}

var colorSwapShader:CustomShader = new CustomShader("dude-colorswap");
function postCreate() {
	camera.lock(200, 200, true);

	ladyAndTheTramp.shader = colorSwapShader;
	applyPlayerSkin(colorSwapShader, 'dude');
	ladyAndTheTramp.setColorTransform(1.25, 1.25, 1.25, 1, 0, 0, 0, 0);
}

function update(elapsed:Float) {
	if (ladyAndTheTramp.animation.curAnim != null)
		ladyAndTheTramp.animation.curAnim.frameRate = 12*(Conductor.bpm/150);
}

function beatHit() {
	ladyAndTheTramp.playAnim("idle", true);
}