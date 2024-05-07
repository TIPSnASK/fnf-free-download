import haxe.Exception;
import karaoke.menus.MenuData;
import karaoke.menus.MenuOption;
import Xml;
import funkin.backend.assets.AssetsLibraryList.AssetSource;
import flixel.addons.display.FlxBackdrop;
import Reflect;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import funkin.backend.system.Conductor;
import funkin.options.keybinds.KeybindsOptions;

var titleText:FunkinText; // its like a reference
var descText:FunkinText; // its like a not reference
var curMenu:MenuData;
var sprites:Array<MenuOption> = [];

var curSelected:Int = 0;

var camY:Float = 0;

var trueFormat:FlxTextFormat = new FlxTextFormat(0xFF00FF62, true);
var falseFormat:FlxTextFormat = new FlxTextFormat(0xFFFF0055, true);
var numberFormat:FlxTextFormat = new FlxTextFormat(0xFF0099FF, true);
var choiceFormat:FlxTextFormat = new FlxTextFormat(0xFFFFD900, true);

var markupRules:Array<FlxTextFormatMarkerPair> = [
	new FlxTextFormatMarkerPair(trueFormat, "$"),
	new FlxTextFormatMarkerPair(falseFormat, "%"),
	new FlxTextFormatMarkerPair(numberFormat, "#"),
	new FlxTextFormatMarkerPair(choiceFormat, "&")
];

function create() {
	playMenuMusic();

	var bg:FlxBackdrop = new FlxBackdrop().loadGraphic(Paths.image("menus/backgrounds/4"));
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	// bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
	bg.color = FlxG.random.color(0xFF474747, 0xFFC2C2C2, 1, false);
	// bg.scale.set(1.5, 1.5);
	// bg.updateHitbox();
	bg.scrollFactor.set(0, 0.12);
	bg.setPosition(0, FlxG.random.int(0, -70));
	add(bg);

	titleText = new FunkinText(25, 25, FlxG.width - 50, "Title", 24, true);
	titleText.font = Paths.font("Pixellari.ttf");
	titleText.textField.antiAliasType = 0;
	titleText.textField.sharpness = 400;
	titleText.borderSize = 2;
	titleText.scrollFactor.set();
	add(titleText);
	titleText.onDraw = (spr:MenuOption) -> {
		spr.colorTransform.color = 0xFF000000;
		spr.offset.set(0, -2);
		spr.draw();

		spr.setColorTransform();
		spr.offset.set();
		spr.draw();
	}

	descText = new FunkinText(25, 60, FlxG.width - 60, "Description", 16, true);
	descText.font = Paths.font("Pixellari.ttf");
	descText.textField.antiAliasType = 0;
	descText.textField.sharpness = 400;
	descText.borderSize = 2;
	descText.scrollFactor.set();
	add(descText);
	descText.onDraw = (spr:MenuOption) -> {
		spr.colorTransform.color = 0xFF000000;
		spr.offset.set(0, -2);
		spr.draw();

		spr.setColorTransform();
		spr.offset.set();
		spr.draw();
	}

	var xmlPath = Paths.xml("config/options");
	for(source in [AssetSource.SOURCE, AssetSource.MODS]) {
		if (Paths.assetsTree.existsSpecific(xmlPath, "TEXT", source)) {
			var xml:Xml = null;
			try {
				xml = Xml.parse(Paths.assetsTree.getSpecificAsset(xmlPath, "TEXT", source));
			} catch(e:Exception) {
				trace('Error while parsing options.xml: ${Std.string(e)}');
			}

			if (xml != null) {
				_options.push(xml);
			}
		}
	}
	setupMenu();
}

var _options:Array<Xml> = [];
function setupMenu(?menuData:MenuData = null, ?parent:MenuData = null) {
	if (menuData != null) {
		curMenu = menuData;
		_options = [];
		for (i in sprites) {
			remove(i);
		}
		sprites = [];
	} else {
		var _xml:Xml = Xml.parse(Assets.getText(Paths.xml('config/base-options'))).firstElement();
		for (i in _options) _xml.addChild(i.firstElement());
		curMenu = new MenuData(_xml);
	}

	if (parent != null) curMenu.parent = parent;

	var _baseCheck = (curMenu.data.exists('base') && curMenu.data.get('base') == 'true') ? Options : FlxG.save.data;
	for (index => node in [for (_i in curMenu.data.elements()) _i]) {
		var _value:Dynamic = null;
		if (node.exists('id')) {
			if (Reflect.field(_baseCheck, node.get('id')) == null) Reflect.setField(_baseCheck, node.get('id'), switch node.nodeName {
				case 'checkbox': false;
				case 'number': Std.parseFloat(node.get('min'));
				case 'choice': [for (_g in node.elementsNamed('value')) _g][0].get('value');
			});
			_value = Reflect.field(_baseCheck, node.get('id'));
		}
		var option = new MenuOption(25, 182 + (25 * index), FlxG.width, '${node.get('name')}', 16, true, node, _baseCheck, _value);
		option.font = Paths.font("Pixellari.ttf");
		option.textField.antiAliasType = 0;
		option.textField.sharpness = 400;
		option.borderSize = 2;
		option.alpha = index == curSelected ? 1 : 0.5;
		insert(1, option);
		if (node.nodeName == 'choice') option.extra['choices'] = [for (_g in node.elementsNamed('value')) _g];
		updateOption(option);
		sprites.push(option);

		option.onDraw = (spr:MenuOption) -> {
			if (curSelected == index) {
				option.alpha = 1;

				option.colorTransform.color = 0xFF000000;
				option.offset.set(0, -4);
				option.draw();

				option.setColorTransform();
				option.offset.set();
				option.draw();
			} else {
				option.setColorTransform();
				option.alpha = 0.5;
				option.offset.set();
				option.draw();
			}
		}
	}

	select(0);
}

function updateOption(option:MenuOption) {
	option.text = '${option.data.get('name')}${switch option.data.nodeName {
		default: '';
		case 'menu': ' >';
		case 'checkbox': ': ${(option.value == true ? '$' + '${option.value}$' : '%${option.value}%')}';
		case 'number': ': #${option.value}#';
		case 'choice':
			var _values:Array<String> = [for (i in option.extra['choices']) i.get('value')];
			var _names:Array<String> = [for (i in option.extra['choices']) i.get('name')];
			': &${_names[_values.indexOf(option.value)]}&';
	}}';
	option.applyMarkup(option.text, markupRules);
}

function select(index:Int) {
	curSelected = index;
	camY = sprites[index].y - 182;
	titleText.text = sprites[index].data.get('name');
	descText.text = sprites[index].data.exists('desc') ? sprites[index].data.get('desc') : 'No description provided.';
	// for (_index => option in sprites) option.alpha = _index == index ? 1 : 0.5;
}

var _timer:Float = 0;
function update(e:Float) {
	_timer += e;
	if (controls.UP_P || controls.DOWN_P) select(FlxMath.wrap(controls.UP_P ? curSelected + -1 : curSelected + 1, 0, sprites.length-1));
	if (controls.LEFT_P || controls.RIGHT_P) {
		switch sprites[curSelected].data.nodeName {
			default: trace('you tried to change what???');
			case 'choice':
				var _values:Array<String> = [for (i in sprites[curSelected].extra['choices']) i.get('value')];
				var _names:Array<String> = [for (i in sprites[curSelected].extra['choices']) i.get('name')];
				Reflect.setField(
					sprites[curSelected].optionParent, sprites[curSelected].data.get('id'),
					sprites[curSelected].value = _values[FlxMath.wrap(_values.indexOf(sprites[curSelected].value) + (controls.LEFT_P ? -1 : 1), 0, _values.length-1)]
				);
				updateOption(sprites[curSelected]);
				onOptionChange(sprites[curSelected]);
			case 'number':
				Reflect.setField(sprites[curSelected].optionParent, sprites[curSelected].data.get('id'), sprites[curSelected].value = FlxMath.wrap(sprites[curSelected].value + (controls.LEFT_P ? -Std.parseFloat(sprites[curSelected].data.get('change')) : Std.parseFloat(sprites[curSelected].data.get('change'))), Std.parseFloat(sprites[curSelected].data.get('min')), Std.parseFloat(sprites[curSelected].data.get('max'))));
				updateOption(sprites[curSelected]);
				onOptionChange(sprites[curSelected]);
		}
	}

	if (controls.ACCEPT) {
		switch sprites[curSelected].data.nodeName {
			default: trace('you selected what???');
			case 'menu': setupMenu(sprites[curSelected], curMenu);
			case 'callback': onOptionChange(sprites[curSelected]);
			case 'checkbox':
				Reflect.setField(sprites[curSelected].optionParent, sprites[curSelected].data.get('id'), !sprites[curSelected].value);
				sprites[curSelected].value = !sprites[curSelected].value;
				updateOption(sprites[curSelected]);
				onOptionChange(sprites[curSelected]);
		}
	} if (controls.BACK) {
		if (curMenu.parent != null)
			setupMenu(curMenu.parent);
		else FlxG.switchState(fromGame ? new PlayState() : new ModState('MainMenu'));
	}

	FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, camY, 0.12);
	titleText.y = 25 + (Math.sin(_timer * 4) + 1) * 0.75; // tank you wizard 🙏;
	descText.y = 57 + (Math.sin((_timer * 4) + 1) + 1) * 0.85; // tank you wizard 🙏;
}

function onOptionChange(option:MenuOption) {
	if (option.data.get('id') == 'songOffset' && (option.parent.data.exists('base') && option.parent.data.get('base') == 'true'))
		Conductor.songOffset = option.value;

	if (option.data.get('name') == "Edit Skins") {
		persistentUpdate = !(persistentDraw = true);
		openSubState(new ModSubState('skins/substates/CharacterSelect'));
	} else if (option.data.get('name') == "Controls") {
		persistentUpdate = !(persistentDraw = true);
		openSubState(new ModSubState('substates/options/SetKeybinds'));
	}
}