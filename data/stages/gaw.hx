// shut up vsc

function create() {
	noteskin = uiskin = "gaw";
}

var colorSwapShader:CustomShader = new CustomShader("dude-colorswap");
function postCreate() {
	camGame.followLerp = 0;
	camGame.scroll.set(0,0);

	ladyAndTheTramp.shader = colorSwapShader;
	usePlayerSkin(colorSwapShader);
	ladyAndTheTramp.setColorTransform(1.25, 1.25, 1.25, 1, 0, 0, 0, 0);
}

function update(elapsed:Float) {
	if (ladyAndTheTramp.animation.curAnim != null)
		ladyAndTheTramp.animation.curAnim.frameRate = 12*(Conductor.bpm/150);
}

function beatHit() {
	ladyAndTheTramp.playAnim("idle", true);
}