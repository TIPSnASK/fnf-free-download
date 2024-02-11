import Xml;
import funkin.backend.assets.AssetsLibraryList.AssetSource;

var curMenuText:FunkinText;
var main:FlxSpriteGroup;

function create() {
	var bg:FunkinSprite = new FunkinSprite(-2, -450).loadGraphic(Paths.image("menus/backgrounds/1"));
	bg.zoomFactor = 0;
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
	bg.scrollFactor.set(0, 1);
	bg.scale.set(2, 2);
	bg.updateHitbox();
	add(bg);

	curMenuText = new FunkinText(10, 30, 0, "OPTIONS", 35);
	curMenuText.alignment = 'left';
	curMenuText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	curMenuText.textField.antiAliasType = 0; // advanced
	curMenuText.textField.sharpness = 400; // max i think idk thats what it says
	curMenuText.font = Paths.font("COMICBD.TTF");
	curMenuText.borderSize = 2;
	add(curMenuText);

	main = new FlxSpriteGroup();
	add(main);

	var xmlPath = Paths.xml("config/options");
	for(source in [AssetSource.SOURCE, AssetSource.MODS]) {
		if (Paths.assetsTree.existsSpecific(xmlPath, "TEXT", source)) {
			var xml:Xml = null;
			try {
				xml = Xml.parse(Paths.assetsTree.getSpecificAsset(xmlPath, "TEXT", source));
			} catch(e:Exception) {
				trace('Error while parsing options.xml: ' + Std.string(e));
			}
			
			if (xml != null)
				for(o in parseOptionsFromXML(xml))
					main.add(o);
		}
	}
}

function parseOptionsFromXML(xml:Xml) {
	var options = [];

	var dumbArr:Array<Xml> = [for (dumb in xml.elements()) dumb];
	for(node in dumbArr) {
		if (!node.exists("name")) {
			trace("option nodes require names buddy.");
			continue;
		}
		var name = node.get("name");
		var desc = node.exists("desc") ? node.get("desc") : "no description provided";

		switch(node.nodeName) {
			case "menu":
				var text:FunkinText = new FunkinText(10, 0, 0, name + " >", 16);
				text.y = ((FlxG.height - optionHeight) / 2) + ((dumbArr.indexOf(node) - curSelected) * optionHeight);
				text.alignment = 'left';
				text.antialiasing = false;
				// lunarcleint figured this out thank you lunar holy shit 🙏
				text.textField.antiAliasType = 0; // advanced
				text.textField.sharpness = 400; // max i think idk thats what it says
				text.font = Paths.font("COMICBD.TTF");
				text.borderSize = 2;
				options.push(text);
			case "choice":
				var text:FunkinText = new FunkinText(10, 0, 0, name + ": dummy", 16);
				text.y = ((FlxG.height - optionHeight) / 2) + ((dumbArr.indexOf(node) - curSelected) * optionHeight);
				text.alignment = 'left';
				text.antialiasing = false;
				// lunarcleint figured this out thank you lunar holy shit 🙏
				text.textField.antiAliasType = 0; // advanced
				text.textField.sharpness = 400; // max i think idk thats what it says
				text.font = Paths.font("COMICBD.TTF");
				text.borderSize = 2;
				options.push(text);
			// case "number":
			// 	options.push(new FunkinText(0, 0, 0, name, 16));
		}

	// 	switch(node.name) {
	// 		case "checkbox":
	// 			if (!node.has.id) {
	// 				Logs.trace("A checkbox option requires an \"id\" for option saving.", WARNING);
	// 				continue;
	// 			}
	// 			options.push(new Checkbox(name, desc, node.att.id, FlxG.save.data));

	// 		case "number":
	// 			if (!node.has.id) {
	// 				Logs.trace("A number option requires an \"id\" for option saving.", WARNING);
	// 				continue;
	// 			}
	// 			options.push(new NumOption(name, desc, Std.parseFloat(node.att.min), Std.parseFloat(node.att.max), Std.parseFloat(node.att.change), node.att.id, null, FlxG.save.data));
	// 		case "choice":
	// 			if (!node.has.id) {
	// 				Logs.trace("A choice option requires an \"id\" for option saving.", WARNING);
	// 				continue;
	// 			}
				
	// 			var optionOptions:Array<Dynamic> = [];
	// 			var optionDisplayOptions:Array<String> = [];

	// 			for(choice in node.elements) {
	// 				optionOptions.push(choice.att.value);
	// 				optionDisplayOptions.push(choice.att.name);
	// 			}
				
	// 			if(optionOptions.length > 0)
	// 				options.push(new ArrayOption(name, desc, optionOptions, optionDisplayOptions, node.att.id, null, FlxG.save.data));
				
	// 		case "menu":
	// 			options.push(new TextOption(name + " >", desc, function() {
	// 				optionsTree.add(new OptionsScreen(name, desc, parseOptionsFromXML(node)));
	// 			}));
	// 	}
	}

	return options;
}

var optionHeight:Float = 24;
var curSelected:Int = 0;
function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT)
		FlxG.switchState(new ModState("menus/Settings"));

	if (controls.UP_P) curSelected = FlxMath.wrap(curSelected-1, 0, main.members.length-1);
	if (controls.DOWN_P) curSelected = FlxMath.wrap(curSelected+1, 0, main.members.length-1);

	if (controls.ACCEPT) {
		switch(main.members[curSelected]) {

		}
	}

	for (k=>option in main.members) {
		if(option == null) continue;

		var y:Float = ((FlxG.height - optionHeight) / 2) + ((k - curSelected) * optionHeight);

		option.y = CoolUtil.fpsLerp(option.y, y, 0.06);
		option.alpha = k == curSelected ? 1 : 0.5;
	}
}