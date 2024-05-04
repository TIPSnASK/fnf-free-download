import Xml;
import flixel.addons.display.FlxBackdrop;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIText;
import karaoke.game.FreeIcon;
import sys.io.File;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

var camZoom:Float = 1;
var camPos:{x:Float,y:Float} = {x: 0, y: 0};

var xml:Xml = Xml.parse(File.getContent('mods/fnffdcne-data.xml')).firstElement();
var skinsXml:Xml = [for (_i in xml.elementsNamed('skins')) _i][0];
var skins:Array<Xml> = getAllSkinXmls(editingSkinType);
var identitiesXml:Xml = [for (_i in xml.elementsNamed('identities')) _i][0];

var char:FunkinSprite;
var icon:FunkinSprite;
var skin:CustomShader = new CustomShader('${editingSkinType}-colorswap');
var fav:CustomShader = new CustomShader('player-icon');

var camUI:FlxCamera;
var topTiles:FlxBackdrop;
var bottomTiles:FlxBackdrop;

var skinName:UIText;

var name:UITextBox;
var pronouns:UITextBox;

var editButton:UIButton;
var deleteButton:UIButton;
var acceptButton:UIButton;

var curSelected:Int = 0;
var canScroll:Bool = true;

var bg:FunkinSprite;

var selectedFormat:FlxTextFormat = new FlxTextFormat(0xFF00FF62, true);
var notSelectedFormat:FlxTextFormat = new FlxTextFormat(0xFFFF0055, true);
var markupRules:Array<FlxTextFormatMarkerPair> = [new FlxTextFormatMarkerPair(selectedFormat, "$"), new FlxTextFormatMarkerPair(notSelectedFormat, "%")];

function create() {
	bg = new FunkinSprite().loadGraphic(Paths.image("menus/backgrounds/4"));
	bg.scale.set(1, 1);
	bg.zoomFactor = 0.25;
	bg.scrollFactor.set(0, 0.25);
	add(bg);

	char = new FunkinSprite().loadGraphic(Paths.image('editors/skins/portraits/${editingSkinType}'));
	char.screenCenter();
	char.shader = skin;
	char.scale.set(0.75, 0.75);
	add(char);

	icon = new FreeIcon('${editingSkinType}-default', true);
	icon.screenCenter();
	icon.x += 70;
	icon.shader = fav;
	add(icon);
}

// convenience
function select(index:Int) {
	FlxTween.cancelTweensOf(bg);
	var _color:FlxColor;
	fav.favColor = FlxColorHelper.vec4(_color = shaderifySkinXml(skin, skins[curSelected = index]));
	updateSkinName();
	FlxTween.color(bg, 1, bg.color, _color, {ease: FlxEase.cubeOut});
}

function updateSkinName() {
	skinName.text = '<             ${skins[curSelected].get('name')}             >\n${(skins[curSelected].get('name') == skinsXml.get('selected${editingSkinType}') ? '$[SELECTED]$' : '%[UNSELECTED]%')}';
	skinName.applyMarkup(skinName.text, markupRules);
}

function postCreate() {
	playMenuMusic();

	camUI = new FlxCamera();
	camUI.bgColor = 0;
	FlxG.cameras.add(camUI, false);

	topTiles = new FlxBackdrop(Paths.image("menus/cool_tile_pattern_bro"), FlxAxes.X);
	topTiles.cameras = [camUI];
	topTiles.scale.set(0.8, 1);
	topTiles.updateHitbox();
	topTiles.velocity.x = 75;
	add(topTiles);

	bottomTiles = new FlxBackdrop(Paths.image("menus/cool_tile_pattern_bro"), FlxAxes.X);
	bottomTiles.cameras = [camUI];
	bottomTiles.scale.set(0.8, 1);
	bottomTiles.updateHitbox();
	bottomTiles.velocity.x = -75;
	bottomTiles.y = FlxG.height-bottomTiles.height;
	bottomTiles.flipY = true;
	add(bottomTiles);

	name = new UITextBox(5, FlxG.height-58, identitiesXml.get('${editingSkinType}name'), 172, 24, false);
	name.cameras = [camUI];
	name.label.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	name.label.textField.antiAliasType = 0; // advanced
	name.label.textField.sharpness = 400; // max i think idk thats what it says
	name.label.font = Paths.font("COMIC.TTF");
	add(name);

	pronouns = new UITextBox(name.x, name.y+29, identitiesXml.get('${editingSkinType}prns'), 172, 24, false);
	pronouns.cameras = [camUI];
	pronouns.label.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	pronouns.label.textField.antiAliasType = 0; // advanced
	pronouns.label.textField.sharpness = 400; // max i think idk thats what it says
	pronouns.label.font = Paths.font("COMIC.TTF");
	add(pronouns);

	var _isDeleting:Bool = false;

	editButton = new UIButton(pronouns.x + pronouns.bWidth + 5, pronouns.y, 'edit', () -> {
		if (!_isDeleting) {
			currentSkinToEdit = skins[curSelected].get('name');
			FlxG.switchState(new UIState(true, "skins/SkinEditor"));
		} else { // shitty hack
			var _xmlParent:Xml = skins[curSelected].parent;
			if (_xmlParent.exists('default')) return; // ITS NOT THE USER'S XML!!! STOP IT!!!!!
			if (_xmlParent.removeChild(skins[curSelected])) {
				if (_xmlParent.get('selected${editingSkinType}') == skins[curSelected].get('name')) _xmlParent.set('selected${editingSkinType}', 'default');
				xml.removeChild([for (_i in xml.elementsNamed('skins')) _i][0]);
				xml.insertChild(_xmlParent, 0);
				File.saveContent('mods/fnffdcne-data.xml', xml.toString());
				FlxG.sound.play(Paths.sound('sfx/snd_doorslam'), 0.75).persist = true;
				FlxG.switchState(new UIState(true, "skins/SkinSelector"));
			}
		}
	}, FlxG.width/4 + 4, pronouns.bHeight);
	editButton.cameras = [camUI];
	editButton.color = 0xFFFFFF00;
	editButton.field.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	editButton.field.textField.antiAliasType = 0; // advanced
	editButton.field.textField.sharpness = 400; // max i think idk thats what it says
	editButton.field.font = Paths.font("COMIC.TTF");
	add(editButton);

	deleteButton = new UIButton(editButton.x + editButton.bWidth + 5, editButton.y, 'delete', null, FlxG.width/4 + 4, pronouns.bHeight);
	deleteButton.callback = () -> {
		var _xmlParent:Xml = skins[curSelected].parent;
		if (_xmlParent.exists('default')) return; // ITS NOT THE USER'S XML!!! STOP IT!!!!!
		if (!_isDeleting) {
			_isDeleting = !(canScroll = false);
			deleteButton.field.text = 'no';
			acceptButton.field.text = 'you sure?';
			acceptButton.color = 0xFF808080;
			editButton.field.text = 'yes';
			editButton.color = 0xFF00FF00;
			FlxG.sound.play(Paths.sound('gameplay/snd_owch'), 0.75);
		} else {
			_isDeleting = !(canScroll = true);
			deleteButton.field.text = 'delete';
			acceptButton.field.text = 'accept';
			acceptButton.color = 0xFF00FF00;
			editButton.field.text = 'edit';
			editButton.color = 0xFFFFFF00;
		}
	}
	deleteButton.cameras = [camUI];
	deleteButton.color = 0xFFFF0000;
	deleteButton.field.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	deleteButton.field.textField.antiAliasType = 0; // advanced
	deleteButton.field.textField.sharpness = 400; // max i think idk thats what it says
	deleteButton.field.font = Paths.font("COMIC.TTF");
	add(deleteButton);

	acceptButton = new UIButton(name.x + name.bWidth + 5, name.y, 'select', () -> {
		if (!_isDeleting) {
			skinsXml.set('selected${editingSkinType}', skins[curSelected].get('name'));
			File.saveContent('mods/fnffdcne-data.xml', xml.toString());
			FlxG.camera.zoom = 1.05;
			updateSkinName();
			FlxG.sound.play(Paths.sound('gameplay/ayy/${editingSkinType}'));
		}
	}, name.bWidth + 41, name.bHeight);
	acceptButton.cameras = [camUI];
	acceptButton.color = 0xFF00FF00;
	acceptButton.field.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	acceptButton.field.textField.antiAliasType = 0; // advanced
	acceptButton.field.textField.sharpness = 400; // max i think idk thats what it says
	acceptButton.field.font = Paths.font("COMIC.TTF");
	add(acceptButton);

	skinName = new UIText(0, 5, FlxG.width, '');
	skinName.cameras = [camUI];
	skinName.alignment = 'center';
	skinName.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	skinName.textField.antiAliasType = 0; // advanced
	skinName.textField.sharpness = 400; // max i think idk thats what it says
	skinName.font = Paths.font("COMIC.TTF");
	add(skinName);

	for (_index => _data in skins)
		if (_data.get("name") == skinsXml.get('selected${editingSkinType}'))
			select(_index);
}

var _timer:Float = 0.0;
function update(e:Float) {
	_timer += e;

	if (!name.focused && !pronouns.focused) {
		if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(fromGame ? new PlayState() : new ModState("MainMenu"));

		if ((controls.LEFT_P || controls.RIGHT_P) && canScroll) {
			var _val:Int = (controls.LEFT_P ? -1 : 1);
			FlxG.camera.scroll.x = _val * -10;
			select(FlxMath.wrap(curSelected + _val, 0, skins.length-1));
		}
	}

	icon.y = 115 + (Math.sin(_timer * 7) + 1) * 2; // tank you wizard 🙏
	skinName.y = 5 + (Math.sin(_timer * 4) + 1); // tank you wizard 🙏

	FlxG.camera.zoom = lerp(FlxG.camera.zoom, camZoom, 0.12);
	FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, camPos.x, 0.12); FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, camPos.y, 0.12);
}

function destroy() {
	identitiesXml.set('${editingSkinType}name', name.label.text);
	identitiesXml.set('${editingSkinType}prns', pronouns.label.text);
	File.saveContent('mods/fnffdcne-data.xml', xml.toString());
}