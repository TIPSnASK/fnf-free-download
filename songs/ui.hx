import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

public var healthBarShadow:FunkinSprite;
public var idkBarShadow:FunkinSprite;
public var idkBarBG:FunkinSprite;
public var idkBar:FlxBar;
public var idkValue:Float = 0;

public var scoreTxtShadow:FunkinText;

function postCreate() {
	for (sl in strumLines.members)
        for (note in sl.notes.members)
            note.alpha = 1;

	camZoomingStrength = 0;

	for (i in [iconP1, iconP2, healthBarBG, healthBar, scoreTxt, missesTxt, accuracyTxt])
		remove(i);

	healthBar = new FlxBar(0, 358, FlxBarFillDirection.RIGHT_TO_LEFT, FlxG.width*0.695, 15, this, 'health', 0, maxHealth);
	healthBar.scrollFactor.set();
	healthBar.createFilledBar(0xFF800080, 0xFFFFFF00);
	healthBar.cameras = [camHUD];
	healthBar.screenCenter(FlxAxes.X);
	add(healthBar);

	healthBarShadow = new FunkinSprite(healthBar.x+2, healthBar.y+(downscroll ? -4 : 2)).makeSolid(healthBar.width+2, healthBar.height+2, 0xFF000000);
	healthBarShadow.scrollFactor.set();
	healthBarShadow.cameras = [camHUD];
	insert(members.indexOf(healthBar), healthBarShadow);
	
	healthBarBG = new FunkinSprite(healthBar.x-2, healthBar.y-2).makeSolid(healthBar.width+4, healthBar.height+4, 0xFF000000);
	healthBarBG.scrollFactor.set();
	healthBarBG.cameras = [camHUD];
	insert(members.indexOf(healthBar), healthBarBG);

	idkBar = new FlxBar(0, healthBar.y - 19, FlxBarFillDirection.RIGHT_TO_LEFT, FlxG.width*0.4, 8);
	idkBar.scrollFactor.set();
	idkBar.createFilledBar(0xFF12484B, 0xFF37949A);
	idkBar.cameras = [camHUD];
	idkBar.screenCenter(FlxAxes.X);
	add(idkBar);

	idkBarShadow = new FunkinSprite(idkBar.x+2, idkBar.y+(downscroll ? -4 : 2)).makeSolid(idkBar.width+2, idkBar.height+2, 0xFF000000);
	idkBarShadow.scrollFactor.set();
	idkBarShadow.cameras = [camHUD];
	insert(members.indexOf(healthBar), idkBarShadow);

	idkBarBG = new FunkinSprite(idkBar.x-2, idkBar.y-2).makeSolid(idkBar.width+4, idkBar.height+4, 0xFF000000);
	idkBarBG.scrollFactor.set();
	idkBarBG.cameras = [camHUD];
	insert(members.indexOf(idkBar), idkBarBG);

	scoreTxt = new FunkinText(10, FlxG.height - 5, FlxG.width-20, 'score: 0 | misses: 0', 16, true);
	scoreTxt.alignment = 'center';
	scoreTxt.antialiasing = false;
	scoreTxt.scrollFactor.set();
	scoreTxt.borderSize = 2;
	add(scoreTxt);

	scoreTxtShadow = new FunkinText(scoreTxt.x+2, scoreTxt.y+2, FlxG.width-20, 'score: 0 | misses: 0', 16, true);
	scoreTxtShadow.alignment = 'center';
	scoreTxtShadow.antialiasing = false;
	scoreTxtShadow.scrollFactor.set();
	scoreTxtShadow.borderSize = 2;
	scoreTxtShadow.color = 0xFF000000;
	insert(members.indexOf(scoreTxt), scoreTxtShadow);

	// var ref:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('ref'));
	// ref.zoomFactor = 0;
	// ref.scrollFactor.set();
	// ref.scale.set(0.5, 0.5);
	// ref.updateHitbox();
	// ref.cameras = [camHUD];
	// ref.alpha = 0.9;
	// insert(0, ref);
}

function postUpdate(elapsed:Float) {
	for (sl in strumLines.members) {
		for (note in sl.notes.members)
			if (note.isSustainNote)
				note.y -= 24;

		for (strum in sl.members)
			strum.alpha = strum.getAnim() == 'pressed' ? 0.5 : 1;
	}

	scoreTxt.text = 'score: ' + songScore + ' | misses: ' + misses;
	scoreTxtShadow.text = 'score: ' + songScore + ' | misses: ' + misses;
}

function onNoteHit(event) {
	event.preventStrumGlow();
	event.showSplash = false;

	if (event.player) {
		idkValue += 0.1;
		idkValue = FlxMath.bound(idkValue, 0, 1);
		idkBar.percent = idkValue*100;
	}
}

function onNoteCreation(event) {
	event.cancel();
	
	var note = event.note;
	note.frames = Paths.getFrames('game/notes/free');
	if (!note.isSustainNote)
		note.animation.addByPrefix('scroll', ['purple', 'blue', 'green', 'red'][event.note.noteData], 0, true);
	else {
		note.animation.addByPrefix('hold', ['purple_hold', 'blue_hold', 'green_hold', 'red_hold'][event.note.noteData], 0, true);
		note.animation.addByPrefix('holdend', ['purple_cap', 'blue_cap', 'green_cap', 'red_cap'][event.note.noteData], 0, true);
	}

	note.updateHitbox();
}

function onStrumCreation(event) {
    event.cancelAnimation();
	event.strum.setPosition(FlxG.width*(switch(event.player) {
		default: 0.53;
		case 0: 0.025;
	}) + (44 * event.strumID), 24);
	event.strum.scrollSpeed = 0.75;
	
	event.cancel();
	
	var strum = event.strum;
	strum.frames = Paths.getFrames('game/notes/free');
	strum.animation.addByPrefix('static', event.animPrefix, 0, true);
	strum.animation.addByPrefix('pressed', event.animPrefix, 0, true); // so it'll stop tracing stupid shit

	strum.updateHitbox();
}