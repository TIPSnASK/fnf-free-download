import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

var titleGroup:FlxSpriteGroup;
var textGroup:FlxSpriteGroup;

var curWacky:Array<String> = [];

var people:FunkinSprite;
var enterThingy:FunkinSprite;
var logo:FunkinSprite;

var finished:Bool = false;
var transitioning:Bool = false;

var splashText:FunkinText;

var markupRules:Array<FlxTextFormatMarkerPair> = [
	new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF9100, true), "||") // dx format
];

function create() {
	var introGuys:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('menus/spr_bing'));
	introGuys.alpha = 0.001;
	introGuys.scale.set(2, 2);
	introGuys.updateHitbox();
	introGuys.shader = new CustomShader('player-icon');
	introGuys.shader.favColor = FlxColorHelper.vec4(getFavColor('dude'));	
	add(introGuys);

	new FlxTimer().start(0.75, () -> {
		introGuys.alpha = 1;
		FlxG.sound.play(Paths.sound('sfx/snd_recordscratch'), 1, false, null, true, () -> {
			new FlxTimer().start(0.25, () -> {
				introGuys.alpha = 0.001;
				new FlxTimer().start(0.5, function() {playMenuMusic();});
			});
		});
	});
	
	titleGroup = new FlxSpriteGroup();
	textGroup = new FlxSpriteGroup();
	add(titleGroup);
	add(textGroup);

	var stupidArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('titlescreen/titletext'));
	if (stupidArray.contains('')) stupidArray.remove('');
	curWacky = stupidArray[FlxG.random.int(0, stupidArray.length-1)].split('--');

	var bg:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('menus/backgrounds/1'));
	bg.scale.set(2, 2);
	bg.updateHitbox();
	bg.x = FlxG.width-bg.width;
	titleGroup.add(bg);

	people = new FunkinSprite();
	people.frames = Paths.getSparrowAtlas('menus/title/dude-n-lady');
	people.animation.addByPrefix('idle', 'spr_menugf_', 0, false);
	people.animation.addByPrefix('yeah', 'spr_menugfyeah', 0, false);
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

	var _splashTextArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('titlescreen/splashtext'));
	splashText = new FunkinText(185, logo.y + logo.height - 10, 200, _splashTextArray[FlxG.random.int(0, _splashTextArray.length-1)], 16, true);
	splashText.alignment = 'center';
	splashText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	splashText.textField.antiAliasType = 0; // advanced
	splashText.textField.sharpness = 400; // max i think idk thats what it says
	splashText.font = Paths.font("Pixellari.ttf");
	splashText.borderSize = 2;
	splashText.angle = -10;
	splashText.color = FlxG.random.color(0xFF8B8B8B, 0xFFFFFFFF, 1, false);
	splashText.applyMarkup(splashText.text, markupRules);
	titleGroup.add(splashText);

	titleGroup.visible = false;
}

function finishIntro() {
	finished = true;
	removeLines();
	flash(FlxG.camera, {color: 0xFFFFFFFF, time: 0.25, force: true}, null);
	titleGroup.visible = true;

	if (FlxG.sound.music.time < 8720)
		FlxG.sound.music.time = 8720;
}

var timer:Float = 0.0;
function update(elapsed:Float) {
	timer += elapsed;

	enterThingy.alpha = FlxMath.bound((Math.sin(timer * 5) + 1) * 0.5, 0.2, 1); // tank you wizard 🙏
	splashText.y = logo.y + logo.height - 10 + (Math.sin(timer * 4) + 1) * 2; // tank you wizard 🙏
	splashText.x = 185 + (Math.sin(timer * 8) + 1) * 2; // tank you wizard 🙏

	people.animation.curAnim.frameRate = 12*(Conductor.bpm/150);

	if (FlxG.sound.music != null && controls.ACCEPT && !finished && !transitioning && FlxG.sound.music.playing)
		finishIntro();
	else if (FlxG.sound.music != null && controls.ACCEPT && finished && !transitioning && FlxG.sound.music.playing) {
		FlxG.sound.play(Paths.sound('menus/snd_josh'), 0.8);
		transitioning = true;
		people.playAnim('yeah', true, 'LOCK');
		flash(FlxG.camera, {color: 0xFFFFFFFF, time: 0.25, force: true}, null);
		new FlxTimer().start(1, () -> {
			FlxG.switchState(new ModState('MainMenu'));
		});
	}
}

function beatHit() {
	if (!transitioning)
		people.playAnim('idle', true);

	splashText.scale.set(1.25, 1.25);
	FlxTween.tween(splashText, {'scale.x': 1, 'scale.y': 1}, 0.5, {ease: FlxEase.backOut});

	FlxTween.cancelTweensOf(logo);
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
		var lastHeight:Float = CoolUtil.last(textGroup.members) == null ? 0 : CoolUtil.last(textGroup.members).height;
		var text:FunkinText = new FunkinText(0, 125 + (lastHeight*(textGroup.length)), FlxG.width, line, 32, false);
		text.alignment = 'center';
		text.antialiasing = false;
		// lunarcleint figured this out thank you lunar holy shit 🙏
		text.textField.antiAliasType = 0; // advanced
		text.textField.sharpness = 400; // max i think idk thats what it says
		text.font = Paths.font("Pixellari.ttf");
		textGroup.add(text);
	}
}

function removeLines() {
	while (textGroup.members.length > 0) {
		textGroup.members[0].destroy();
		textGroup.remove(textGroup.members[0], true);
	}
}
