import Xml;

var weekndData:Array<{xml:Xml, name:String, color:FlxColor, songs:Array<{name:String, displayName:Null<String>}>}> = [];
var curSelected:Int = 0;

function create() {
	var bg:FunkinSprite = new FunkinSprite(-250).loadGraphic(Paths.image('menus/backgrounds/3'));
	bg.scrollFactor.set();
	bg.scale.set(2,2);
	bg.updateHitbox();
	bg.y = -690;
	add(bg);

	for (i in 0...2) {
		var bar:FunkinSprite = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
		bar.y = i == 0 ? 250 : -344;
		bar.scrollFactor.set();
		add(bar);
	}

	var weekndFiles = Paths.getFolderContent('data/weeknds');
	for (index=>weeknd in weekndFiles) {
		weeknd = StringTools.replace(weeknd, '.xml', '');
		var xml:Xml = Xml.parse(Assets.getText(Paths.xml('weeknds/' + weeknd))).firstElement();
		weekndData.push({
			xml: xml,
			name: xml.get('name'),
			color: FlxColor.fromString(xml.get('color')),
			songs: [
				for (song in xml.elementsNamed('song'))
					{name: song.get('name'), displayName: song.exists('display') ? song.get('display') : null}
			]
		});

		for (node in xml.elementsNamed('banner')) {
			// TODO: DO OTHER TYPES AFTER FINISHING GAMEPLAY
			if (node.get('type') == 'normal') {
				var banner:FunkinSprite = new FunkinSprite(0, 66).loadGraphic(Paths.image('menus/story-mode/' + node.get('file')));
				banner.scrollFactor.set(1, 0);
				banner.x = banner.width*index;
				add(banner);
			}
		}

		var text:FunkinText = new FunkinText(400*index, 10, 400, weekndData[index].name, 24, false);
		text.alignment = 'center';
		text.antialiasing = false;
		text.color = weekndData[index].color;
		add(text);
	}
}

function update(elapsed:Float) {
	if (controls.BACK)
		FlxG.switchState(new ModState('MainMenu'));

	if (FlxG.keys.justPressed.EIGHT)
		FlxG.switchState(new ModState('menus/StoryMenu'));

	if (controls.LEFT_P) curSelected --;
	if (controls.RIGHT_P) curSelected ++;
	curSelected = FlxMath.bound(curSelected, 0, weekndData.length-1);

	FlxG.camera.scroll.x = CoolUtil.fpsLerp(FlxG.camera.scroll.x, 400*curSelected, 0.12);
}