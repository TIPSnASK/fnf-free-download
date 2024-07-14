// shut up vsc
import flixel.util.FlxGradient;

public var isNightTime:Bool = false;
var sky:FunkinSprite;
var houseLights:FunkinSprite;
var theStupidThing1:FunkinSprite;
var theStupidThing2:FunkinSprite;
var dumbCircle:FunkinSprite;

var ladyDance:Character;

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
		houseLights.animation.add("lights", FlxG.save.data.freeCOLORCHANGING ? [0,1,2,3] : [0], 0, true, false, false);
		houseLights.playAnim("lights", true);

		insert(6, cyan = new FunkinSprite(95, 104).loadGraphic(Paths.image("game/stages/house/cyan")));
		cyan.kill();

		insert(5, dumbCircle = new FunkinSprite().loadGraphic(Paths.image("game/stages/house/ididntwanttomakethisasprite")));
		dumbCircle.screenCenter();
		dumbCircle.x += 140;
		dumbCircle.y += 80;
		dumbCircle.antialiasing = false;
		dumbCircle.alpha = 0.5;

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

		dumbCircle.alpha = theStupidThing1.alpha = theStupidThing2.alpha = 0;

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

		ladyDance = new Character(boyfriend.x + 75, boyfriend.y - 55, "lady-stars", true);
		player.characters.push(ladyDance);
		insert(members.indexOf(boyfriend)+1, ladyDance);
		ladyDance.kill();
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

					flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
				case 512:
					gf.visible = ladySpeaker.visible = houseLights.visible = speakerLight = true;
					for (name => spr in stage.stageSprites) {
						spr.visible = true;
					}

					dad.scale.set(1, 1);
					dad.updateHitbox();
					boyfriend.scale.set(1, 1);
					boyfriend.updateHitbox();
					dad.color = boyfriend.color = 0xFFFFFFFF;

					dad.x += 120;
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

					dumbCircle.alpha = (theStupidThing1.alpha = theStupidThing2.alpha = 1) * 0.5;

					flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
				case 528: flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
				case 576:
					gf.visible = false;
					dad.x += 40;
					boyfriend.x -= 40;
					ladyDance.revive();
					ladyDance.x -= 85;
					ladyDance.onDraw = (spr:Character) -> {
						spr.color = 0xFFFFFFFF;
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
						spr.alpha = 1;
						spr.draw();
				
						spr.setColorTransform(0, 0, 0, 0.5);
						spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y + -4);
						spr.draw();
					};
					flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
				case 640:
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

					dumbCircle.alpha = theStupidThing1.alpha = theStupidThing2.alpha = 0;

					dad.x = 260;
					boyfriend.x = 540;
					gf.visible = true;
					ladyDance.kill();
					camera.unlock();
					cyan.revive();
					flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
		}
	}
}

function onEvent(e) if (curSong == "stars" && e.event.name == "go off") {
	if (e.event.params[0] != 2) {
		var positions:Array<Float> = switch e.event.params[0] {
			case 0: [212, -70, 450];
			case 1: [212+225, -70+225, 450+225];
		};
		dumbCircle.x = positions[0];
		dumbCircle.y = 261;
		dumbCircle.setGraphicSize(257,dumbCircle.height); dumbCircle.updateHitbox();

		theStupidThing1.x = positions[1];
		theStupidThing1.y = -63;

		theStupidThing2.x = positions[2];
		theStupidThing2.y = -63;
	} else {
		dumbCircle.x = 258;
		dumbCircle.y = 261;
		dumbCircle.setGraphicSize(385,dumbCircle.height); dumbCircle.updateHitbox();

		theStupidThing1.x = -15;
		theStupidThing1.y = -63;

		theStupidThing2.x = 450+225-55;
		theStupidThing2.y = -63;
	}
}