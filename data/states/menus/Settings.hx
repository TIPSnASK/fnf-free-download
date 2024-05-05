import haxe.Exception;
import karaoke.menus.MenuData;
import karaoke.menus.MenuOption;
import Xml;
import funkin.backend.assets.AssetsLibraryList.AssetSource;
import flixel.addons.display.FlxBackdrop;
import Reflect;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

var titleText:FunkinText; // its like a reference
var curMenu:MenuData;
var sprites:Array<MenuOption> = [];

var curSelected:Int = 0;

var camY:Float = 0;

var trueFormat:FlxTextFormat = new FlxTextFormat(0xFF00FF00, true);
var falseFormat:FlxTextFormat = new FlxTextFormat(0xFFFF0000, true);
var numberFormat:FlxTextFormat = new FlxTextFormat(0xFF0000BB, true);
var choiceFormat:FlxTextFormat = new FlxTextFormat(0xFFFFFF00, true);

var markupRules:Array<FlxTextFormatMarkerPair> = [
	new FlxTextFormatMarkerPair(trueFormat, "$"),
	new FlxTextFormatMarkerPair(falseFormat, "%"),
	new FlxTextFormatMarkerPair(numberFormat, "#"),
	new FlxTextFormatMarkerPair(choiceFormat, "&")
];

function create() {
	playMenuMusic();

	var bg:FlxBackdrop = new FlxBackdrop().loadGraphic(Paths.image("menus/backgrounds/1"));
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
	bg.scale.set(2, 2);
	bg.scrollFactor.set(0, 0.12);
	bg.y += -50;
	add(bg);

	titleText = new FunkinText(25, 25, FlxG.width, "Options", 24, true);
	titleText.font = Paths.font("COMIC.TTF");
	titleText.textField.antiAliasType = 0;
	titleText.textField.sharpness = 400;
	titleText.borderSize = 2;
	titleText.scrollFactor.set();
	add(titleText);

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
		camY = curSelected = 0;
	} else {
		var _xml:Xml = Xml.parse('<menu name="Options"></menu>').firstElement();
		for (i in _options) _xml.addChild(i.firstElement());
		curMenu = new MenuData(_xml);
	}

	if (parent != null) curMenu.parent = parent;

	titleText.text = curMenu.data.get('name');

	for (index => node in [for (_i in curMenu.data.elements()) _i]) {
		var _value:Dynamic = null;
		if (node.exists('id')) {
			if (Reflect.field(FlxG.save.data, node.get('id')) == null) Reflect.setField(FlxG.save.data, node.get('id'), switch node.nodeName {
				case 'checkbox': false;
				case 'number': Std.parseFloat(node.get('min'));
				case 'choice': [for (_g in node.elementsNamed('value')) _g][0].get('value');
			});
			_value = Reflect.field(FlxG.save.data, node.get('id'));
		}
		var option = new MenuOption(25, 182 + (25 * index), FlxG.width, '${node.get('name')}', 18, true, node, _value);
		option.font = Paths.font("COMIC.TTF");
		option.textField.antiAliasType = 0;
		option.textField.sharpness = 400;
		option.borderSize = 2;
		option.alpha = index == curSelected ? 1 : 0.5;
		insert(1, option);
		if (node.nodeName == 'choice') option.extra['choices'] = [for (_g in node.elementsNamed('value')) _g];
		updateOption(option);
		sprites.push(option);
	}
}

function updateOption(option:MenuOption) {
	option.text = '${option.data.get('name')}${switch option.data.nodeName {
		default: '';
		case 'menu': ' >';
		case 'checkbox': ': ${(option.value == true ? '$' + '${option.value}$' : '%${option.value}%')}';
		case 'number': ': #${Std.parseFloat(option.value)}#';
		case 'choice':
			var _values:Array<String> = [for (i in option.extra['choices']) i.get('value')];
			var _names:Array<String> = [for (i in option.extra['choices']) i.get('name')];
			': &${_names[_values.indexOf(option.value)]}&';
	}}';
	option.applyMarkup(option.text, markupRules);
}

function select(index:Int) {
	curSelected = index;
	camY =  sprites[index].y - 182;
	for (_index => option in sprites) option.alpha = _index == index ? 1 : 0.5;
}

function update(e:Float) {
	if (FlxG.keys.justPressed.EIGHT) FlxG.switchState(new ModState('menus/Settings'));

	if (controls.UP_P || controls.DOWN_P) select(FlxMath.wrap(controls.UP_P ? curSelected + -1 : curSelected + 1, 0, sprites.length-1));
	if (controls.LEFT_P || controls.RIGHT_P) {
		switch sprites[curSelected].data.nodeName {
			// default: trace('you tried to change what???');
			case 'choice':
				var _values:Array<String> = [for (i in sprites[curSelected].extra['choices']) i.get('value')];
				var _names:Array<String> = [for (i in sprites[curSelected].extra['choices']) i.get('name')];
				Reflect.setField(
					FlxG.save.data, sprites[curSelected].data.get('id'),
					sprites[curSelected].value = _values[FlxMath.wrap(_values.indexOf(sprites[curSelected].value) + (controls.LEFT_P ? -1 : 1), 0, _values.length-1)]
				);
				updateOption(sprites[curSelected]);
			case 'number':
				Reflect.setField(FlxG.save.data, sprites[curSelected].data.get('id'), sprites[curSelected].value = FlxMath.wrap(sprites[curSelected].value + (controls.LEFT_P ? -Std.parseFloat(sprites[curSelected].data.get('change')) : Std.parseFloat(sprites[curSelected].data.get('change'))), Std.parseFloat(sprites[curSelected].data.get('min')), Std.parseFloat(sprites[curSelected].data.get('max'))));
				updateOption(sprites[curSelected]);
		}
	}

	if (controls.ACCEPT) {
		switch sprites[curSelected].data.nodeName {
			// default: trace('you selected what???');
			case 'menu': setupMenu(sprites[curSelected], curMenu);
			case 'checkbox':
				Reflect.setField(FlxG.save.data, sprites[curSelected].data.get('id'), !sprites[curSelected].value);
				sprites[curSelected].value = !sprites[curSelected].value;
				updateOption(sprites[curSelected]);
		}
	} if (controls.BACK) {
		if (curMenu.parent != null)
			setupMenu(curMenu.parent);
		else FlxG.switchState(new ModState('MainMenu'));
	}

	FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, camY, 0.12);
}