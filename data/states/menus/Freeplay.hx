var bg:FunkinSprite;
function create() {
	playMenuMusic();
	
	bg = new FunkinSprite(-400, 0).loadGraphic(Paths.image('menus/backgrounds/4'));
	bg.scrollFactor.set(0, 0.25);
	bg.scale.set(2, 2);
	bg.updateHitbox();
	add(bg);
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT) FlxG.switchState(new ModState('menus/Freeplay'));
	if (controls.BACK) FlxG.switchState(new ModState('MainMenu'));
}