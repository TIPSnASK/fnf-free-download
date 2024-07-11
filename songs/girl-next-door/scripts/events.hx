var ladyDance:FunkinSprite;
var dudeDance:FunkinSprite;

var danceBreak:FunkinSprite;

function postCreate() {
	ladyDance = new FunkinSprite(boyfriend.x - 50, boyfriend.y - 65);
	dudeDance = new FunkinSprite(boyfriend.x - 20, boyfriend.y - 10);

	for (index => char in [ladyDance, dudeDance]) {
		char.loadSprite(Paths.image('game/stages/bus/girl-next-door/${['lady', 'dude'][index]}-dance'));
		char.animation.addByPrefix('danceDown', 'spr_${['lady', 'dude'][index]}dancedown', 12, false);
		char.animation.addByPrefix('danceUp', 'spr_${['lady', 'dude'][index]}danceup', 12, false);
		char.beatAnims = [{name: 'danceDown', forced: true}, {name: 'danceUp', forced: true}];
		char.beatInterval = 1;
		if (index == 0)
			char.addOffset('danceUp', -2, -1);
		insert(members.indexOf(boyfriend)-1, char);
		char.shader = new CustomShader('${['lady', 'dude'][index]}-colorswap');
		applyPlayerSkin(char.shader, '${['lady', 'dude'][index]}');
		char.visible = false;
	}

	danceBreak = new FunkinSprite(0, 75);
	danceBreak.loadSprite(Paths.image('game/stages/bus/girl-next-door/dancebreak'));
	danceBreak.screenCenter(0x01);
	danceBreak.scrollFactor.set();
	add(danceBreak);
	danceBreak.visible = false;

	danceBreak.onDraw = (spr:FunkinSprite) -> {
		spr.offset.set(0, 0);
		spr.draw();

		spr.offset.set(0, (-2) + (Math.sin(timer * 4.5) + 1) * 2);
		spr.draw();
	}
}

var timer:Float = 0;
function update(e:Float) {
	timer += e;
}

function stepHit(s) {
	switch s {
		case 128:
			ladyDance.visible = dudeDance.visible = danceBreak.visible = !(boyfriend.visible = gf.visible = false);
		case 192:
			ladyDance.visible = dudeDance.visible = danceBreak.visible = !(boyfriend.visible = gf.visible = true);
	}
}