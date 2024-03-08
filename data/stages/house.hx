// shut up vsc
import flixel.util.FlxGradient;

var sky:FunkinSprite;
function create() {
	insert(0, sky = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF91CFDD));
	sky.scrollFactor.set();
	sky.zoomFactor = 0;
}

// switch statement in stephit because life isnt good var hate
function stepHit(s) {
	switch curSong {
		case "summer":
			switch s {
				case 376:
					camGame.fade(0xFFFFFFFF, convertTime(0, 2, 0), false, null, true);
				case 384:
					camGame.flash(0xFFFFFFFF, 0.001, null, true); // stop the fade or something? idk
					camGame.fade(0xFFFFFFFF, convertTime(1, 0, 0), true, null, true);

					FlxGradient.overlayGradientOnFlxSprite(sky, sky.width, sky.height, [0xFFE6966E, 0xFFE8B66C], 0, 0, 1, 90, true);

					for (name => spr in stage.stageSprites) {
						spr.color = 0xFFFFC8AD;
					}

					dad.onDraw = (spr:Character) -> {
						spr.color = 0xFFFFC8AD;
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
						spr.alpha = 1;
						spr.draw();
				
						spr.setColorTransform(0, 0, 0, 0.4);
						spr.offset.set(-spr.globalOffset.x + 4, -spr.globalOffset.y + -4);
						spr.draw();
					};
				
					boyfriend.onDraw = (spr:Character) -> {
						spr.color = 0xFFFFC8AD;
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
						spr.alpha = 1;
						spr.draw();
				
						spr.setColorTransform(0, 0, 0, 0.4);
						spr.offset.set(-spr.globalOffset.x + -4, -spr.globalOffset.y + -4);
						spr.draw();
					};
				
					gf.onDraw = (spr:Character) -> {
						spr.color = 0xFFFFC8AD;
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
						spr.alpha = 1;
						spr.draw();
				
						spr.setColorTransform(0, 0, 0, 0.4);
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y + -4);
						spr.draw();
					};

					ladySpeaker.onDraw = (spr:FunkinSprite) -> {
						spr.color = 0xFFFFC8AD;
						spr.offset.set();
						spr.alpha = 1;
						spr.draw();
				
						spr.setColorTransform(0, 0, 0, 0.4);
						spr.offset.set(0, -4);
						spr.draw();
					};
					speakerLight = true;
			}
	}
}

function onCameraMove(event) {
	if (startingSong) camGame.snapToTarget();
	switch(curCameraTarget) {
		case 0: event.position.set(280, 175);
		case 1: event.position.set(570, 175);
		case 2: event.position.set(450, 175);
	}
}