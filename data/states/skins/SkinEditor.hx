import Xml;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIColorwheel;
import karaoke.game.FreeIcon;
import karaoke.editors.IconButton;
import sys.io.File;

var IconButton = new IconButton();

var camZoom:Float = 1;
var camPos:{x:Float,y:Float} = {x: 102, y: 0};

var char:FunkinSprite;
var icon:FunkinSprite;
var skin:CustomShader = new CustomShader('${editingSkinType}-colorswap');
var fav:CustomShader = new CustomShader('player-icon');

var camUI:FlxCamera;
var topTiles:FlxBackdrop;
var bottomTiles:FlxBackdrop;

var buttons:FlxSpriteGroup;

var colorPicker:UIColorwheel;
var currentlyColoring:String = '';

var colors:Map<String, FlxColor> = [];

var	favButton:FlxSpriteGroup = null;
var name:UITextBox;

var saveButton:UIButton;

// dude
var	hatButton:FlxSpriteGroup;
var	hairButton:FlxSpriteGroup;
var	skinButton:FlxSpriteGroup;

var	shirtButton:FlxSpriteGroup;
var	stripeButton:FlxSpriteGroup;

var	pantsButton:FlxSpriteGroup;
var	shoesButton:FlxSpriteGroup;

function create() {
	var bg:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image("menus/backgrounds/1"));
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
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

	fav.favColor = FlxColorHelper.vec4(applySkin(skin, editingSkinType, currentSkinToEdit));
}

function postCreate() {
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

	buttons = new FlxSpriteGroup(220, 150);
	buttons.cameras = [camUI];
	add(buttons);

	colorPicker = new UIColorwheel(90, 240, 0xFFFFFFFF);
	colorPicker.cameras = [camUI];
	add(colorPicker);

	name = new UITextBox(buttons.x, buttons.y-28, currentSkinToEdit, 172, 24, false);
	name.cameras = [camUI];
	add(name);

	// gender button will be inbetween here when i make the portrait for the thing

	saveButton = new UIButton(name.x, name.y - (name.bHeight) - 5, 'save', () -> {
		var _defXml:Xml = Xml.parse(Assets.getText(Paths.xml('def-skins'))).firstElement();
		var _fullXml:Xml = Xml.parse(File.getContent('mods/fnffdcne-data.xml')).firstElement();
		var _skinsXml:Xml = [for (_i in _fullXml.elementsNamed('skins')) _i][0];
		var _elements:Array<Xml> = [for (_i in _skinsXml.elementsNamed(editingSkinType)) _i];
		for (_skin in [for (_i in _defXml.elementsNamed(editingSkinType)) _i]) if (_skin.get('name') == name.label.text) {name.label.text = 'user-${name.label.text}'; break;}
		for (_elem in _elements) if (_elem.get("name") == name.label.text) _skinsXml.removeChild(_elem);

		var _xml:Xml = Xml.createElement(editingSkinType);
		// I KNEW MAKING COLORS A MAP WOULD COME IN HANDY LATER I AM SO FUCKING COOL AND SMART
		for (_key => _color in colors) _xml.set(_key, '#${FlxColorHelper.toHexString(_color, false, false)}');
		_xml.set("name", name.label.text);

		_skinsXml.addChild(_xml);
		File.saveContent('mods/fnffdcne-data.xml', _fullXml.toString());
	}, name.bWidth, name.bHeight);
	saveButton.cameras = [camUI];
	saveButton.color = 0xFF00FF00;
	add(saveButton);

	switch editingSkinType {
		case 'dude':
			var _xml:Xml = getSkinXml(editingSkinType, currentSkinToEdit);

			var namesArr:Array<String> = ['hat', 'hair', 'skin', 'shirt', 'stripe', 'pants', 'shoes', 'fav'];
			var spriteArr:Array<FlxSpriteGroup> = [hatButton, hairButton, skinButton, shirtButton, stripeButton, pantsButton, shoesButton, favButton];

			for (index => spr in spriteArr) {
				colors.set(namesArr[index], FlxColor.fromString(_xml.get(namesArr[index])));
				spr = IconButton.create(35*FlxMath.wrap(index, 0, 4), 35*Math.floor(index/5), 'editors/skins/icons/${editingSkinType}', namesArr[index], () -> {
					currentlyColoring = namesArr[index];

					var __color = colors.get(namesArr[index]);
					colorPicker.curColor = __color;
					colorPicker.saturation = FlxColorHelper.saturation(__color);
					colorPicker.brightness = FlxColorHelper.brightness(__color);
					colorPicker.hue = FlxColorHelper.hue(__color);
					colorPicker.updateWheel();
				}, 32, 32);
				spr.members[1].shader = skin;
				buttons.add(spr);
			}
	}
}

var _timer:Float = 0.0;
function update(e:Float) {
	_timer += e;
	if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(new UIState(true, "skins/SkinSelector"));

	icon.y = 115 + (Math.sin(_timer * 7) + 1) * 2; // tank you wizard 🙏

	if (colorPicker.hovered && FlxG.mouse.pressed && currentlyColoring != '') {
		var _color:FlxColor = FlxColor.fromString(colorPicker.curColorString);
		colors[currentlyColoring] = _color;
		switch currentlyColoring {
			case 'hat': skin.colorReplaceHat = FlxColorHelper.vec4(_color);
			case 'hair': skin.colorReplaceHair = FlxColorHelper.vec4(_color);
			case 'skin': skin.colorReplaceSkin = FlxColorHelper.vec4(_color);

			case 'shirt': skin.colorReplaceShirt = FlxColorHelper.vec4(_color);
			case 'stripe': skin.colorReplaceStripe = FlxColorHelper.vec4(_color);

			case 'pants': skin.colorReplacePants = FlxColorHelper.vec4(_color);
			case 'shoes': skin.colorReplaceShoes = FlxColorHelper.vec4(_color);

			case 'fav': fav.favColor = FlxColorHelper.vec4(_color);
		}
	}

	FlxG.camera.zoom = lerp(FlxG.camera.zoom, camZoom, 0.12);
	FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, camPos.x, 0.12); FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, camPos.y, 0.12);
}

function destroy() {
	currentSkinToEdit = 'default';
}