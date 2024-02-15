import Xml;

var weekndData:Array<{xml:Xml, name:String, color:FlxColor, rating:String, songs:Array<{name:String, displayName:Null<String>}>}> = [];
var curSelected:Int = 0;

var songsTxt:FunkinText;
var ratingTxt:FunkinText;
var whyDoYouLookLikeThat:FunkinText;

function create() {
	playMenuMusic();
	
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
		
		var shadow:FunkinSprite = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
		shadow.y = i == 0 ? bar.y - 5 : bar.y + 5;
		shadow.scrollFactor.set();
		shadow.alpha = 0.45;
		add(shadow);
	}

	var weekndFiles = Paths.getFolderContent('data/weeknds');
	for (index=>weeknd in weekndFiles) {
		weeknd = StringTools.replace(weeknd, '.xml', '');
		var xml:Xml = Xml.parse(Assets.getText(Paths.xml('weeknds/' + weeknd))).firstElement();
		weekndData.push({
			xml: xml,
			name: xml.get('name'),
			color: FlxColor.fromString(xml.get('color')),
			rating: xml.get('rating'),
			songs: [
				// TODO: PRE DISPLAY NAME
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
		// lunarcleint figured this out thank you lunar holy shit 🙏
		text.textField.antiAliasType = 0; // advanced
		text.textField.sharpness = 400; // max i think idk thats what it says
		text.font = Paths.font("COMICBD.TTF");
		add(text);

		gradientText(text, [
			weekndData[index].color,
			FlxColor.fromRGB(
				(((weekndData[index].color >> 16) & 0xff)) - 64,
				(((weekndData[index].color >> 8) & 0xff)) - 64,
				(((weekndData[index].color) & 0xff)) - 64,
				255
			)
		]);
	}

	songsTxt = new FunkinText(10, 260, FlxG.width-20, 'Songs\n', 16, false);
	songsTxt.alignment = 'left';
	songsTxt.antialiasing = false;
	songsTxt.scrollFactor.set();
	add(songsTxt);

	ratingTxt = new FunkinText(10, 260, FlxG.width-20, 'Rating\n', 16, false);
	ratingTxt.alignment = 'right';
	ratingTxt.antialiasing = false;
	ratingTxt.scrollFactor.set();
	add(ratingTxt);

	whyDoYouLookLikeThat = new FunkinText(10, 275, FlxG.width-20, 'PLAY', 24, false);
	whyDoYouLookLikeThat.alignment = 'center';
	whyDoYouLookLikeThat.antialiasing = false;
	whyDoYouLookLikeThat.scrollFactor.set();
	add(whyDoYouLookLikeThat);

	for (text in [songsTxt, ratingTxt, whyDoYouLookLikeThat]) {
		// lunarcleint figured this out thank you lunar holy shit 🙏
		text.textField.antiAliasType = 0; // advanced
		text.textField.sharpness = 400; // max i think idk thats what it says
		text.font = Paths.font("COMIC" + (text == whyDoYouLookLikeThat ? "BD" : "") + ".TTF");
	}

	updateStuff();
}

function updateStuff() {
	songsTxt.text = 'Songs\n';
	for (stupid in weekndData[curSelected].songs)
		songsTxt.text += (stupid.displayName == null ? stupid.name : stupid.displayName) + '\n';

	ratingTxt.text = 'Rating\n' + weekndData[curSelected].rating;
}

var timer:Float = 0.0;
function update(elapsed:Float) {
	timer += elapsed;

	if (controls.ACCEPT) {
		FlxG.sound.play(Paths.sound("menus/snd_josh")).persist = true;
		var convertedData = {
			name: weekndData[curSelected].name,
			id: curSelected,
			sprite: '',
			chars: [],
			songs: [for (song in weekndData[curSelected].songs) song],
			difficulties: [weekndData[curSelected].rating]
		};

		PlayState.loadWeek(convertedData, weekndData[curSelected].rating);
		FlxG.switchState(new PlayState());
	}

	if (controls.BACK)
		FlxG.switchState(new ModState('MainMenu'));

	if (FlxG.keys.justPressed.EIGHT)
		FlxG.switchState(new ModState('menus/StoryMenu'));

	if (controls.LEFT_P) {
		curSelected --;
		curSelected = FlxMath.bound(curSelected, 0, weekndData.length-1);
		updateStuff();
	} if (controls.RIGHT_P) {
		curSelected ++;
		curSelected = FlxMath.bound(curSelected, 0, weekndData.length-1);
		updateStuff();
	}

	whyDoYouLookLikeThat.y = 275 + (Math.sin(timer * 7) + 1) * 0.75; // tank you wizard 🙏

	FlxG.camera.scroll.x = CoolUtil.fpsLerp(FlxG.camera.scroll.x, 400*curSelected, 0.12);
}