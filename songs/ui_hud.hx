// shut up vsc

import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import karaoke.game.FreeIcon;

public var flowBar:FlxBar;
public var flow:Float = 0;

public var scoreTxtShadow:FunkinText;

public var playerIcon:FreeIcon;
public var opponentIcon:FreeIcon;
public var playerIconShadow:FreeIcon;
public var opponentIconShadow:FreeIcon;

public var uiskin:String = "default";

function onCountdown(event) {
	if (event.swagCounter != 4) {
		event.spritePath = "game/spr_countdown_" + event.swagCounter;
		event.soundPath = "gameplay/snd_" + (event.swagCounter == 3 ? "go" : FlxMath.remapToRange(event.swagCounter-1, -1, 3, 3, -1));
		event.scale = 2;
	}
}

function onPostCountdown(event) {
	if (event.sprite != null) {
		var spr = event.sprite;
		spr.antialiasing = false;
		FlxTween.cancelTweensOf(spr);
		FlxTween.tween(spr, {alpha: 0}, Conductor.crochet / 1000, {
			onComplete: (tween:FlxTween) -> {
				spr.destroy();
				remove(spr, true);
			}
		});
	}
}

function onSongStart() {
	canPause = true;
}

// WON'T WORK IF YOU GOT CODENAME THROUGH ACTION BUILDS!!
var outlineColor:FlxColor = 0xFF000000;
function outlineDraw(spr:FlxSprite) {
	var w:Int = 2;

	spr.setGraphicSize(spr.width+w, spr.height+w);
	spr.colorTransform.color = outlineColor;
	spr.offset.set(-2, -2);
	spr.draw();

	spr.offset.set();
	spr.draw();

	spr.setGraphicSize(spr.width-w, spr.height-w);
	spr.setColorTransform();
	spr.draw();
}

function postCreate() {
	canPause = false;
	for (sl in strumLines.members) {
        for (note in sl.notes.members)
            note.alpha = 1;
	}

	for (i in [iconP1, iconP2, healthBarBG, healthBar, scoreTxt, missesTxt, accuracyTxt])
		remove(i);

	healthBar = new FlxBar(0, 358, FlxBarFillDirection.RIGHT_TO_LEFT, FlxG.width*0.695, 15, this, 'health', 0, maxHealth);
	healthBar.scrollFactor.set();
	healthBar.createFilledBar(0xFF800080, getFavColor('dude'));
	healthBar.cameras = [camHUD];
	healthBar.screenCenter(FlxAxes.X);

	// WON'T WORK IF YOU GOT CODENAME THROUGH ACTION BUILDS!!
	healthBar.onDraw = outlineDraw;

	add(healthBar);

	flowBar = new FlxBar(0, healthBar.y - 19, FlxBarFillDirection.RIGHT_TO_LEFT, FlxG.width*0.4, 8);
	flowBar.scrollFactor.set();
	flowBar.createFilledBar(0xFF12484B, 0xFF37949A);
	flowBar.cameras = [camHUD];
	flowBar.screenCenter(FlxAxes.X);

	// WON'T WORK IF YOU GOT CODENAME THROUGH ACTION BUILDS!!
	flowBar.onDraw = outlineDraw;

	add(flowBar);

	scoreTxt = new FunkinText(10, healthBar.y + healthBar.height + 2, FlxG.width-20, 'score: 0 | misses: 0', 16, true);
	scoreTxt.alignment = 'center';
	scoreTxt.antialiasing = false;
	scoreTxt.scrollFactor.set();
	scoreTxt.borderSize = 2;
	scoreTxt.cameras = [camHUD];
	scoreTxt.font = Paths.font("COMIC.TTF");

	// WON'T WORK IF YOU GOT CODENAME THROUGH ACTION BUILDS!!
	scoreTxt.onDraw = (spr:FunkinText) -> {
		spr.colorTransform.color = outlineColor;
		spr.offset.set(-2, -2);
		spr.draw();

		spr.setColorTransform();
		spr.offset.set();
		spr.draw();
	};

	add(scoreTxt);

	// lunarcleint figured this out thank you lunar holy shit 🙏
	scoreTxt.textField.antiAliasType = 0; // advanced
	scoreTxt.textField.sharpness = 400; // max i think idk thats what it says

	// var ref:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('ref'));
	// ref.zoomFactor = 0;
	// ref.scrollFactor.set();
	// ref.scale.set(0.5, 0.5);
	// ref.updateHitbox();
	// ref.cameras = [camHUD];
	// ref.alpha = 0.9;
	// insert(0, ref);

	playerIcon = new FreeIcon('dude-${uiskin}');
	playerIcon.cameras = [camHUD];
	playerIcon.shader = new CustomShader('player-icon');
	playerIcon.shader.favColor = FlxColorHelper.vec4(getFavColor('dude'));
	add(playerIcon);

	opponentIcon = new FreeIcon('strad-${uiskin}');
	opponentIcon.cameras = [camHUD];
	add(opponentIcon);

	playerIcon.y = healthBar.y - (playerIcon.height/2.25);
	opponentIcon.y = healthBar.y - (opponentIcon.height/2.25);

	playerIconShadow = new FreeIcon('dude-${uiskin}');
	playerIconShadow.cameras = [camHUD];
	playerIconShadow.color = 0xFF000000;
	insert(members.indexOf(healthBar), playerIconShadow);

	opponentIconShadow = new FreeIcon('strad-${uiskin}');
	opponentIconShadow.cameras = [camHUD];
	opponentIconShadow.color = 0xFF000000;
	insert(members.indexOf(healthBar), opponentIconShadow);

	switch(uiskin) {
		case "gaw":
			outlineColor = 0xFFFFFFFF;
			
			healthBar.createFilledBar(0xFF000000, 0xFF000000);
			flowBar.createFilledBar(0xFF000000, 0xFFFFFFFF);

			scoreTxt.onDraw = (spr:FunkinText) -> {
				spr.colorTransform.color = outlineColor;
				spr.offset.set(-2, -2);
				spr.draw();
		
				spr.setColorTransform();
				spr.color = 0xFF000000;
				spr.offset.set();
				spr.draw();
			};
			scoreTxt.setFormat(scoreTxt.font, scoreTxt.size, 0xFF000000, scoreTxt.alignment, scoreTxt.borderStyle, 0xFFFFFFFF);
	}
}

var timer:Float = 0;
function postUpdate(elapsed:Float) {
	timer += elapsed;

	scoreTxt.text = 'score: ${songScore} | misses: ${misses}';

	flowBar.y = Std.int((healthBar.y - 18) + (Math.sin(timer * 4.5) + 1) * 1.25); // tank you wizard 🙏

	playerIcon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0)) - 5);
	opponentIcon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0))) - (opponentIcon.width - 10);
	playerIconShadow.setPosition(playerIcon.x + 2, playerIcon.y + 2);
	opponentIconShadow.setPosition(opponentIcon.x + (downscroll ? -2 : 2), opponentIcon.y + (downscroll ? -2 : 2));

	playerIcon.health = healthBar.percent / 100;
	opponentIcon.health = 1 - (healthBar.percent / 100);
}