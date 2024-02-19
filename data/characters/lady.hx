public var ladySpeaker:FunkinSprite;

function new() {
	ladySpeaker = new FunkinSprite();
	ladySpeaker.frames = Paths.getFrames("game/stages/speaker");

	state.insert(state.members.indexOf(this), ladySpeaker);
}

function update(elapsed:Float) {
	ladySpeaker.setPosition(x, y);
}