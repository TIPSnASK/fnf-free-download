import funkin.backend.utils.FunkinParentDisabler;
import funkin.editors.charter.Charter;
import funkin.options.OptionsMenu;

var itemArray:Array<FunkinText> = [];
var pauseCam:FlxCamera;
var menuItems = ['Resume', 'Restart', 'Options', 'Quit'];
var curSelected:Int = 0;
var parentDisabler:FunkinParentDisabler;
// var pauseMusic:FlxSound;

function create() {
	FlxG.state.persistentUpdate = false;
	FlxG.state.persistentDraw = true;
	FlxG.state.paused = true;

	parentDisabler = new FunkinParentDisabler();
	add(parentDisabler);

	// pauseMusic = FlxG.sound.load(Paths.music('breakfast'), 0, true);
	// pauseMusic.persist = false;
	// pauseMusic.group = FlxG.sound.defaultMusicGroup;
	// pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

	pauseCam = new FlxCamera();
	pauseCam.bgColor = 0x5D000000;
	FlxG.cameras.add(pauseCam, false);

	var pausedTxt = new FunkinText(8, 12, FlxG.width, "PAUSED", 54, true);
	pausedTxt.cameras = [pauseCam];
	pausedTxt.font = Paths.font("COMIC.TTF");
	pausedTxt.textField.antiAliasType = 0;
	pausedTxt.textField.sharpness = 400;
	pausedTxt.borderSize = 3;
	add(pausedTxt);

	for (index => line in menuItems) {
		var lastHeight:Float = (CoolUtil.last(itemArray) == null ? 0 : CoolUtil.last(itemArray).height);
		var text = new FunkinText(8, 97 + ((lastHeight/1.1)*itemArray.length), FlxG.width, line, 12, true);
		text.cameras = [pauseCam];
		text.font = Paths.font("COMIC.TTF");
		text.textField.antiAliasType = 0;
		text.textField.sharpness = 400;
		text.borderSize = 2;
		text.alpha = curSelected == index ? 1 : 0.5;
		add(text);

		itemArray.push(text);
	}
}

function onClose() {
	// if (pauseMusic != null)
	// 	FlxG.sound.destroySound(pauseMusic);

	if (FlxG.cameras.list.contains(pauseCam))
		FlxG.cameras.remove(pauseCam, true);
}

function changeItem(value:Int) {
	curSelected = FlxMath.wrap(value, 0, menuItems.length-1);

	for (index => spr in itemArray)
		spr.alpha = curSelected == index ? 1 : 0.5;
}

function selectItem(selected:String) {
	switch(selected) {
		case 'Resume':
			close();
		case 'Restart':
			parentDisabler.reset();
			FlxG.resetState();
		case 'Options':
			FlxG.switchState(new OptionsMenu());
		case 'Quit':
			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			if (PlayState.chartingMode)
				FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, false));
			if (!PlayState.isStoryMode && !PlayState.chartingMode)
				FlxG.switchState(new FreeplayState());
	}
}

function update(elapsed:Float) {
	if (controls.BACK) {
		close();
		return;
	}

	// if (pauseMusic.volume < 0.5)
	// 	pauseMusic.volume += 0.01 * elapsed;

	if (controls.UP_P)
		changeItem(curSelected == 0 ? menuItems.length-1 : curSelected - 1);

	if (controls.DOWN_P)
		changeItem(curSelected == menuItems.length-1 ? 0 : curSelected + 1);

	if (controls.ACCEPT)
		selectItem(menuItems[curSelected]);
}