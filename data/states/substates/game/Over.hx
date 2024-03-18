// LAUGH AT ME ALL YOU WANT
var dudeRED:FunkinSprite;
var dudeBLUE:FunkinSprite;
var dude:FunkinSprite;
var faker:FunkinSprite;

var retryText:FunkinText;

function create() {
	if (FlxG.sound.music != null)
		FlxG.sound.music.stop();

	FlxG.camera.target = null;
	FlxG.camera.scroll.x = FlxG.camera.scroll.y = 0;
	FlxG.camera.stopFX();
	
	// LAUGH AT ME ALL YOU WANT

	dude = new FunkinSprite().loadGraphic(Paths.image("game/over/dude-dead"), true, 111, 120);
	dude.animation.frameIndex = 0;
	dude.screenCenter();
	dude.alpha = 0;
	usePlayerSkin(dude.shader = new CustomShader("dude-colorswap"));
	add(dude);
	
	dudeRED = dude.clone();
	dudeRED.screenCenter();
	dudeRED.color = 0xFFFF0000;
	dudeRED.shader = new CustomShader("wiggle");
	dudeRED.shader.wIntensity = 0.05;
	dudeRED.shader.wStrength = 1;
	dudeRED.shader.wSpeed = 1.5;
	dudeRED.alpha = 0.5;
	insert(0, dudeRED);

	dudeBLUE = dudeRED.clone();
	dudeBLUE.screenCenter();
	dudeBLUE.color = 0xFF0000FF;
	dudeBLUE.shader = new CustomShader("wiggle");
	dudeBLUE.shader.wIntensity = -0.05;
	dudeBLUE.shader.wStrength = 1;
	dudeBLUE.shader.wSpeed = 1.5;
	dudeBLUE.alpha = 0.5;
	insert(0, dudeBLUE);

	faker = new FunkinSprite().loadGraphic(Paths.image("game/over/dude-dead"), true, 111, 120);
	faker.animation.frameIndex = 1;
	faker.screenCenter();
	add(faker);

	if (!(Assets.cache.getBitmapData("game over alive yeah")))
		Assets.cache.setBitmapData("game over alive yeah", (new FlxSprite().loadGraphic(Paths.image("game/over/dude-alive"))));

	FlxTween.shake(faker, 0.15, 0.25, FlxAxes.X);
	FlxG.sound.play(Paths.sound("sfx/snd_doorslam"));
	if (FlxG.random.int(0, 100) == 99)
		FlxG.sound.play(Paths.sound("sfx/snd_OHSHIT"), 0.5); // yeah fuck you

	new FlxTimer().start(1.5, (t:FlxTimer) -> {
		t.destroy();
		FlxTween.tween(retryText, {alpha: 1}, 1);
		FlxTween.tween(dude, {alpha: 1}, 1);
		FlxTween.tween(faker, {alpha: 0}, 1);
		CoolUtil.playMusic(Paths.music("mus_gameover"));
		_canPressEnter = true;
	});

	retryText = new FunkinText(0, 75, FlxG.width, "retry?", 14, true);
	retryText.font = Paths.font("COMIC.TTF");
	retryText.textField.antiAliasType = 0;
	retryText.textField.sharpness = 400;
	retryText.borderSize = 0;
	retryText.alignment = "center";
	retryText.alpha = 0;
	add(retryText);
	gradientText(retryText, [0xFFC6375D, 0xFFA23367]);
}

var _canPressEnter:Bool = false;
var _time:Float = 0;
function update(e:Float) {
	_time += e;
	dudeRED.shader.elapsed = _time; // this somehow does both dudeRED and dudeBLUE so
	dudeRED.alpha = dudeBLUE.alpha = dude.alpha * 0.5;
	retryText.y = 75 + (Math.sin(_time * 6) + 1) * 1.25; // tank you wizard 🙏
	if (controls.ACCEPT && _canPressEnter) {
		_canPressEnter = false;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.music = null;
		
		FlxTween.completeTweensOf(dude);
		FlxTween.completeTweensOf(faker);
		
		dude.loadGraphic(Paths.image("game/over/dude-alive"));
		dude.screenCenter();
		dudeRED.visible = dudeBLUE.visible = false;
		FlxG.sound.play(Paths.sound("sfx/snd_ha"));
		new FlxTimer().start(1, (t:FlxTimer) -> {
			t.destroy();
			FlxG.camera.fade(0xFF000000, 0.25, false, () -> {FlxG.switchState(new PlayState());}, true);
		});
	}

	if (controls.BACK) {
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.music = null;

		if (PlayState.isStoryMode)
			FlxG.switchState(new StoryMenuState());
		if (PlayState.chartingMode)
			FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, false));
		if (!PlayState.isStoryMode && !PlayState.chartingMode)
			FlxG.switchState(new FreeplayState());
	}
}

function onClose() {
	if (FlxG.sound.music != null)
		FlxG.sound.music.stop();
	FlxG.sound.music = null;
}