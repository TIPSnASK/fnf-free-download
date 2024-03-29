// shut up vsc
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;

public var isNightTime:Bool = false;
var sky:FunkinSprite;
var houseLights:FunkinSprite;
var theStupidThing1:FunkinSprite;
var theStupidThing2:FunkinSprite;

function create() {
	isNightTime = curSong == "stars";
}

function postCreate() {
	if (!isNightTime) {
		insert(0, sky = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF91CFDD));
		sky.scrollFactor.set();
		sky.zoomFactor = 0;
	} else {
		insert(0, sky = new FunkinSprite(0, -75).loadGraphic(Paths.image("game/stages/house/googlenightsky")));
		sky.scrollFactor.set(0.5, 0.5);
		sky.shader = new CustomShader("wiggle-but-weird");
		sky.shader.wIntensity = 0.025;
		sky.shader.wStrength = 5;
		sky.shader.wSpeed = 1;
		sky.shader.threeFuckingTextureCalls = false;
		sky.setColorTransform(0.5, 0.2, 0.7, 1, 40, 40, 40, 0);

		insert(5, houseLights = new FunkinSprite());
		houseLights.loadSprite(Paths.image("game/stages/house/lights"));
		houseLights.animation.add("lights", [0,1,2,3], 0, true, false, false);
		houseLights.playAnim("lights", true);

		add(theStupidThing1 = new FunkinSprite().makeSolid(300, 475, 0xFF000000));
		theStupidThing1.screenCenter();
		theStupidThing1.x -= 120;
		theStupidThing1.y -= 25;
		theStupidThing1.angle = 12.5;

		add(theStupidThing2 = new FunkinSprite().makeSolid(300, 475, 0xFF000000));
		theStupidThing2.screenCenter();
		theStupidThing2.x += 400;
		theStupidThing2.y -= 25;
		theStupidThing2.angle = -12.5;

		var test:FunkinSprite;
		test = new FunkinSprite().makeGraphic(50, 50, 0);
		test = FlxSpriteUtil.drawCircle(test, -1, -1, 25, 0x93FFFFFF);
		test.screenCenter();
		test.x += 50;
		test.y += 80;
		test.antialiasing = false;
		test.setGraphicSize(225, 40);
		test.updateHitbox();
		add(test);

		for (name => spr in stage.stageSprites) {
			spr.color = 0xFF261B33;
		}

		dad.onDraw = (spr:Character) -> {
			spr.color = 0xFF614C75;
			spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
			spr.alpha = 1;
			spr.draw();
	
			spr.setColorTransform(0, 0, 0, 0.45);
			spr.offset.set(-spr.globalOffset.x + 4, -spr.globalOffset.y);
			spr.draw();
		};
	
		boyfriend.onDraw = (spr:Character) -> {
			spr.color = 0xFF614C75;
			spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
			spr.alpha = 1;
			spr.draw();
	
			spr.setColorTransform(0, 0, 0, 0.45);
			spr.offset.set(-spr.globalOffset.x + -4, -spr.globalOffset.y);
			spr.draw();
		};
	
		gf.onDraw = (spr:Character) -> {
			spr.color = 0xFF614C75;
			spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
			spr.alpha = 1;
			spr.draw();
	
			spr.setColorTransform(0, 0, 0, 0.45);
			spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y + 4);
			spr.draw();
		};

		ladySpeaker.onDraw = (spr:FunkinSprite) -> {
			spr.color = 0xFF614C75;
			spr.offset.set();
			spr.alpha = 1;
			spr.draw();
	
			spr.setColorTransform(0, 0, 0, 0.45);
			spr.offset.set(0, 4);
			spr.draw();
		};

		speakerLight = true;
	}
}

function beatHit(b) {
	if (isNightTime)
		houseLights.animation.curAnim.curFrame = FlxMath.wrap(Std.int(b/speakerInterval), 0, 3);
}

var _time:Float = 0;
function update(e:Float) {
	if (!isNightTime) return;
	_time += e;
	sky.shader.elapsed = _time;
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
		case "stars":
			switch s {
				case 448:
					gf.visible = ladySpeaker.visible = houseLights.visible = speakerLight = false;
					for (name => spr in stage.stageSprites) {
						spr.visible = false;
					}
					dad.onDraw = boyfriend.onDraw = null;
					dad.setColorTransform();
					boyfriend.setColorTransform();
					dad.color = boyfriend.color = 0xFF000000;
					dad.offset.set(-dad.globalOffset.x, -dad.globalOffset.y);
					boyfriend.offset.set(-boyfriend.globalOffset.x, -boyfriend.globalOffset.y);
					dad.scale.set(2, 2);
					dad.updateHitbox();
					boyfriend.scale.set(2, 2);
					boyfriend.updateHitbox();

					dad.x -= 80;
					dad.y += 80;

					boyfriend.x += 40;
					boyfriend.y += 60;
				case 512:
					dad.scale.set(1, 1);
					dad.updateHitbox();
					boyfriend.scale.set(1, 1);
					boyfriend.updateHitbox();
					dad.color = boyfriend.color = 0xFFFFFFFF;

					dad.x += 120; // +40
					dad.y -= 80;

					boyfriend.x -= 80;
					boyfriend.y -= 60;

					camera.lock(camera.pos[2].x, camera.pos[2].y, true);
					camera.snap();

					dad.onDraw = (spr:Character) -> {
						spr.color = 0xFFFFFFFF;
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
						spr.alpha = 1;
						spr.draw();
				
						spr.setColorTransform(0, 0, 0, 0.5);
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y + -4);
						spr.draw();
					};
				
					boyfriend.onDraw = (spr:Character) -> {
						spr.color = 0xFFFFFFFF;
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
						spr.alpha = 1;
						spr.draw();
				
						spr.setColorTransform(0, 0, 0, 0.5);
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y + -4);
						spr.draw();
					};
			}
	}
}