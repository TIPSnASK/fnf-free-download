var titleGroup:FlxSpriteGroup;
var textGroup:FlxSpriteGroup;

var curWacky:Array<String> = [];

var people:FunkinSprite;
var enterThingy:FunkinSprite;
var logo:FunkinSprite;

var finished:Bool = false;
var transitioning:Bool = false;

function create() {
	var introGuys:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('menus/spr_bing'));
	introGuys.alpha = 0.001;
	introGuys.scale.set(2, 2);
	introGuys.updateHitbox();
	add(introGuys);

	new FlxTimer().start(0.75, () -> {
		introGuys.alpha = 1;
		FlxG.sound.play(Paths.sound('snd_recordscratch'), 1, false, null, true, () -> {
			new FlxTimer().start(0.25, () -> {
				introGuys.alpha = 0.001;
				new FlxTimer().start(0.5, function() {CoolUtil.playMusic(Paths.music('mus_menu'), true, 1, true, 110);});
			});
		});
	});
	
	titleGroup = new FlxSpriteGroup();
	textGroup = new FlxSpriteGroup();
	add(titleGroup);
	add(textGroup);

	var stupidArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('titlescreen/introText'));
	if (stupidArray.contains('')) stupidArray.remove('');
	curWacky = stupidArray[FlxG.random.int(0, stupidArray.length)].split('--');

	var bg:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('menus/backgrounds/1'));
	bg.scale.set(2, 2);
	bg.updateHitbox();
	bg.x = FlxG.width-bg.width;
	titleGroup.add(bg);

	people = new FunkinSprite();
	people.frames = Paths.getSparrowAtlas('menus/title/dude-n-lady');
	people.animation.addByPrefix('idle', 'spr_menugf_', 9, false);
	people.animation.addByPrefix('yeah', 'spr_menugfyeah', 9, false);
	people.playAnim('idle', true);
	people.scale.set(2, 2);
	people.updateHitbox();
	titleGroup.add(people);

	logo = new FunkinSprite(0, 20).loadGraphic(Paths.image('menus/title/spr_title'));
	logo.scale.set(2, 2);
	logo.updateHitbox();
	logo.screenCenter(FlxAxes.X);
	titleGroup.add(logo);

	enterThingy = new FunkinSprite().loadGraphic(Paths.image('menus/title/spr_titleword'));
	enterThingy.scale.set(2, 2);
	enterThingy.updateHitbox();
	enterThingy.setPosition(5, FlxG.height-enterThingy.height-5);
	titleGroup.add(enterThingy);

	titleGroup.visible = false;
}

function finishIntro() {
	finished = true;
	removeLines();
	if (FlxG.save.data.freeFLASH) FlxG.camera.flash(0xFFFFFFFF, 0.25, null, true);
	titleGroup.visible = true;
}

var timer:Float = 0.0;
function update(elapsed:Float) {
	timer += elapsed;

	enterThingy.alpha = (Math.sin(timer * 2) + 1) * 0.5; // tank you wizard 🙏

	if (FlxG.sound.music != null && controls.ACCEPT && !finished && !transitioning && FlxG.sound.music.playing)
		finishIntro();
	else if (FlxG.sound.music != null && controls.ACCEPT && finished && !transitioning && FlxG.sound.music.playing) {
		FlxG.sound.play(Paths.sound('snd_josh'), 0.8);
		transitioning = true;
		people.playAnim('yeah', true, 'LOCK');
		if (FlxG.save.data.freeFLASH) FlxG.camera.flash(0xFFFFFFFF, 0.25, null, true);
		new FlxTimer().start(1, () -> {
			FlxG.switchState(new ModState('MainMenu'));
		});
	}
}

function beatHit() {
	if (!transitioning)
		people.playAnim('idle', true);

	logo.scale.set(2.15, 2.15);
	FlxTween.tween(logo, {'scale.x': 2, 'scale.y': 2}, 0.25, {ease: FlxEase.circOut});

	if (!finished) {
		switch(curBeat) {
			case 1: line(['TIPSnASK']);
			case 2: line(['PRESENTS']);

			case 4: line(['IN ASSOCIATION WITH']);
			case 6: newLine(['WizardMantis441']);

			case 8: line([curWacky[0]]);
			case 10: newLine([curWacky[1]]);

			case 12: line(['FNF']);
			case 14: newLine(['FREE']);
			case 15: newLine(['DOWNLOAD']);

			case 16: finishIntro();
		}
	}
}

function line(lines:Array<String>) {
	removeLines();
	newLine(lines);
}

function newLine(lines:Array<String>) {
	for (line in lines) {
		var text:FunkinText = new FunkinText(0, (textGroup.length * 45) + 125, FlxG.width, line, 32, false);
		text.alignment = 'center';
		text.antialiasing = false;
		textGroup.add(text);
	}
}

function removeLines() {
	while (textGroup.members.length > 0) {
		textGroup.members[0].destroy();
		textGroup.remove(textGroup.members[0], true);
	}
}
