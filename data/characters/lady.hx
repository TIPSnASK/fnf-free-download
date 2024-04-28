// ffs
static var ladySpeaker:FunkinSprite;
static var speakerLightSpr:FunkinSprite;

static var speakerAuto:Bool = true;
static var speakerInterval:Int = 2;
static var speakerLight:Bool = false;

var skin:CustomShader;
function postCreate() {
	ladySpeaker = new FunkinSprite();
	ladySpeaker.frames = Paths.getFrames("game/stages/speaker");
	ladySpeaker.animation.add("hi", [0, 1, 2, 3], 0, true, false, false);
	ladySpeaker.playAnim("hi", true);

	speakerLightSpr = new FunkinSprite();
	speakerLightSpr.frames = Paths.getFrames("game/stages/speaker-lights");
	speakerLightSpr.animation.add("hi", [0, 3, 2, 1], 0, true, false, false);
	speakerLightSpr.playAnim("hi", true);

	shader = skin = new CustomShader("lady-colorswap");
	useLadySkin(skin);
}

var firstFrame:Bool = true;
function update(elapsed:Float) {
	if (firstFrame) {
		firstFrame = false;
		state.insert(state.members.indexOf(this), ladySpeaker);
		state.insert(state.members.indexOf(this), speakerLightSpr);
	}
	ladySpeaker.setPosition(x - (ladySpeaker.width*0.2), y + 77);
	speakerLightSpr.setPosition(x - (speakerLightSpr.width*0.2), y);

	speakerLightSpr.visible = speakerLight;
}

function beatHit(b) {
	if (speakerAuto && b > 0) {
		ladySpeaker.animation.curAnim.curFrame = speakerLightSpr.animation.curAnim.curFrame = FlxMath.wrap(Std.int(b/speakerInterval), 0, 3);
	}
}

// ffs
function destroy() {
	ladySpeaker = null;
	speakerLightSpr = null;

	speakerAuto = null;
	speakerInterval = null;
	speakerLight = null;
}