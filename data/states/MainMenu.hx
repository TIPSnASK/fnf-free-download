// holy shit this is literally all of the fucking code 😭

import funkin.menus.ModSwitchMenu;
import funkin.options.OptionsMenu;
import funkin.backend.MusicBeatState;

var bg:FunkinSprite;
var options:FunkinSprite;
var optionList:Array<String> = ['StoryMenu', 'Freeplay', 'Settings', 'Discord', 'Credits'];
var curSelected:Int = 0;

function create() {
	playMenuMusic();

	bg = new FunkinSprite().loadGraphic(Paths.image('menus/backgrounds/2'));
	bg.scale.set(2, 2);
	bg.updateHitbox();
	add(bg);

	options = new FunkinSprite();
	options.frames = Paths.getSparrowAtlas('menus/main-menu/options');
	for (index=>name in optionList)
		options.animation.addByPrefix(name, 'spr_titlewords2_${index}', 0, true);
	options.scale.set(2, 2);
	options.updateHitbox();
	options.screenCenter();
	add(options);
	options.playAnim('story mode', true);
}

function update(elapsed:Float) {
	if (controls.ACCEPT) {
		if (Assets.exists(Paths.script('data/states/menus/${optionList[curSelected]}'))) {
			FlxG.sound.play(Paths.sound("menus/snd_josh")).persist = optionList[curSelected] != 'Discord';
			MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = optionList[curSelected] == 'Discord';
			FlxG.switchState(new ModState('menus/${optionList[curSelected]}'));
		}
	}

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		openSubState(new ModSubState('substates/editors/EditorSelect'));
	}
	
	if (controls.SWITCHMOD) {
		persistentUpdate = false;
		openSubState(new ModSubState('substates/menus/ModSwitch'));
	}

	if (controls.DOWN_P || controls.UP_P) {
		curSelected = FlxMath.wrap(curSelected + (controls.DOWN_P ? 1 : -1), 0, optionList.length-1);
		options.playAnim(optionList[curSelected], true);
		options.x = (optionList[curSelected] != 'Credits' ? -22 : 0);
		options.y = (optionList[curSelected] != 'Credits' ? -22 : 0);
	}

	bg.y = CoolUtil.fpsLerp(bg.y, -125 * curSelected, 0.06);
}