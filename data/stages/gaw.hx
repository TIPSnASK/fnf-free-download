// shut up vsc

function create() {
	noteskin = uiskin = "gaw";
}

var colorSwapShader:CustomShader = new CustomShader("dude-colorswap");
function postCreate() {
	camGame.followLerp = 0;
	camGame.scroll.set(0,0);

	ladyAndTheTramp.shader = colorSwapShader;
	colorSwapShader.colorReplaceHat = [0.5, 0.5, 0.5, 1.0];
	colorSwapShader.colorReplaceSkin = [0.5, 0.5, 0.5, 1.0];
	colorSwapShader.colorReplaceHair = [0.5, 0.5, 0.5, 1.0];
	colorSwapShader.colorReplaceShirt = [0.5, 0.5, 0.5, 1.0];
	colorSwapShader.colorReplaceStripe = [0.5, 0.5, 0.5, 1.0];
	colorSwapShader.colorReplacePants = [0.5, 0.5, 0.5, 1.0];
	colorSwapShader.colorReplaceShoes = [0.5, 0.5, 0.5, 1.0];
	ladyAndTheTramp.setColorTransform(1.25, 1.25, 1.25, 1, 0, 0, 0, 0);
}

function update(elapsed:Float) {
	if (ladyAndTheTramp.animation.curAnim != null)
		ladyAndTheTramp.animation.curAnim.frameRate = 12*(Conductor.bpm/150);
}

function beatHit() {
	ladyAndTheTramp.playAnim("idle", true);
}