// holy shit this is literally all of the fucking code 😭

import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.options.OptionsMenu;

import funkin.editors.ui.UIState;

var bg:FunkinSprite;
var options:FunkinSprite;
var optionList:Array<String> = ['StoryMenu', 'Freeplay', 'Settings', 'Discord'];
var curSelected:Int = 0;

function create() {
	bg = new FunkinSprite().loadGraphic(Paths.image('menus/backgrounds/2'));
	bg.scale.set(2, 2);
	bg.updateHitbox();
	add(bg);

	options = new FunkinSprite();
	options.frames = Paths.getSparrowAtlas('menus/main-menu/options');
	for (index=>name in optionList)
		options.animation.addByPrefix(name, 'spr_titlewords2_' + index, 0, true);
	options.scale.set(2, 2);
	options.updateHitbox();
	options.screenCenter();
	add(options);
	options.playAnim('story mode', true);
}

function update(elapsed:Float) {
	if (controls.ACCEPT) {
		if (Assets.exists(Paths.script('data/states/menus/' + optionList[curSelected])))
			FlxG.switchState(new ModState('menus/' + optionList[curSelected]));
		else if (optionList[curSelected] != "Settings")
			trace(optionList[curSelected] + ': yooooooooo');
		else if (optionList[curSelected] == "Settings")
			FlxG.switchState(new OptionsMenu());
	}

	if (controls.LEFT_P || controls.RIGHT_P)
		FlxG.switchState(new UIState(true, "MakeADude"));

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		openSubState(new EditorPicker());
	}
	
	if (controls.SWITCHMOD) {
		persistentUpdate = false;
		openSubState(new ModSwitchMenu());
	}

	if (controls.UP_P) curSelected --;
	if (controls.DOWN_P) curSelected ++;
	curSelected = FlxMath.wrap(curSelected, 0, optionList.length-1);
	options.playAnim(optionList[curSelected], true);

	bg.y = CoolUtil.fpsLerp(bg.y, -150 * curSelected, 0.06);
}