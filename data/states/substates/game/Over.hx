var dude:FunkinSprite;
var faker:FunkinSprite;

function create() {
	if (FlxG.sound.music != null)
		FlxG.sound.music.stop();

	FlxG.camera.target = null;
	FlxG.camera.scroll.x = FlxG.camera.scroll.y = 0;
	FlxG.camera.stopFX();

	dude = new FunkinSprite().loadGraphic(Paths.image("game/over/dude-dead"), true, 111, 120);
	dude.animation.frameIndex = 0;
	dude.screenCenter();
	dude.alpha = 0;
	usePlayerSkin(dude.shader = new CustomShader("dude-colorswap"));
	add(dude);

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
		FlxTween.tween(dude, {alpha: 1}, 1);
		FlxTween.tween(faker, {alpha: 0}, 1);
		CoolUtil.playMusic(Paths.music("mus_gameover"));
		_canPressEnter = true;
	});
}

var _canPressEnter:Bool = false;
function update(e:Float) {
	if (controls.ACCEPT && _canPressEnter) {
		_canPressEnter = false;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.music = null;

		FlxTween.completeTweensOf(dude);
		FlxTween.completeTweensOf(faker);
		
		dude.loadGraphic(Paths.image("game/over/dude-alive"));
		dude.screenCenter();
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