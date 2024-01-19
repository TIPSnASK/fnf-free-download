import funkin.options.categories.GameplayOptions;
import funkin.options.categories.AppearanceOptions;
import funkin.options.categories.MiscOptions;
import funkin.options.keybinds.KeybindsOptions;

var mainOptions = [
	{
		name: 'Controls',
		desc: 'Change Controls for Player 1 and Player 2!',
		state: null,
		substate: KeybindsOptions
	},
	{
		name: 'Gameplay >',
		desc: 'Change Gameplay options such as Downscroll, Scroll Speed, Naughtyness...',
		state: GameplayOptions
	},
	{
		name: 'Appearance >',
		desc: 'Change Appearance options such as Flashing menus...',
		state: AppearanceOptions
	},
	{
		name: 'Miscellaneous >',
		desc: 'Use this menu to reset save data or engine settings.',
		state: MiscOptions
	}
];

function create() {
	var bg:FunkinSprite = new FunkinSprite(-2, -450).loadGraphic(Paths.image('menus/backgrounds/2'));
	bg.alpha = 0.25;
	bg.scale.set(2, 2);
	bg.updateHitbox();
	add(bg);

	
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT) FlxG.switchState(new ModState('menus/Settings'));
}