public var ladySpeaker:FunkinSprite;

function postCreate() {
	ladySpeaker = new FunkinSprite();
	ladySpeaker.frames = Paths.getFrames("game/stages/speaker");

	// state.insert(, ladySpeaker);
}

var firstFrame:Bool = true;
function update(elapsed:Float) {
	if (firstFrame) {
		firstFrame = false;
		state.insert(state.members.indexOf(this), ladySpeaker);
	}
	ladySpeaker.setPosition(x - (ladySpeaker.width*0.1), y + 76);
}