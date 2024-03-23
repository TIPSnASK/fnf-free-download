// ENTIRELY BASED OFF OF AVERY'S "CREATE A DUDE" CONCEPT ART

import haxe.Json;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UIColorwheel;
import sys.io.File;
import sys.FileSystem;

var STUPIDFUCKINGCAMERA:FlxCamera;
var dude:FunkinSprite;
var colorSwap:CustomShader = new CustomShader("dude-colorswap");
var dumbZoom:Float = 1.4;
var dumbPos:{x:Float, y:Float} = {x: 0, y: 0};
var colorPicker:UIColorwheel;
var dudeName:UITextBox;

var saveButton:UIButton;
var loadButton:UIButton;
var cancelButton:UIButton;

var randomizeButton:UIButton;
var genderButton:UIButton;

var updateColors:Bool = false;

var selectedButton:Int = 0;
// BECAUSE LIFE ISNT GOOD
var buttonArr:Array<UIButton> = [];

// i clicked on obs a full minute ago

var colorData = {
	skin: 0xFF000000,
	hair: 0xFF000000,
	hat: 0xFF000000,
	
	shirt: 0xFF000000,
	stripes: 0xFF000000,
	
	pants: 0xFF000000,
	shoes: 0xFF000000
};

var userSkins = Json.parse(File.getContent("mods/free-download-skins.json"));

function loadSkin(name:String) {
	updateColors = false;
	var path:String = Paths.txt("skins/" + name);

	var dumbData:Array<String> = [];
	var yup:Bool = false;

	if (Assets.exists(path))
		dumbData = CoolUtil.coolTextFile(path);

	for (dumb in userSkins.skins) {
		if (dumb.name == name) {
			dumbData = coolText(dumb.data);
			if (dumb.clickedGenderButton != null)
				whatDoICallThisVariable = dumb.clickedGenderButton;
			break;
		}
	}

	if (dumbData != []) {
		for (index => line in dumbData) {
			var lineData:Array<Float> = [for (ass in line.split(",")) Std.parseFloat(StringTools.trim(ass))/255];
			var theFlxColor:FlxColor = FlxColor.fromRGBFloat(lineData[0], lineData[1], lineData[2], lineData[3]);

			// Invalid Cast
			// because life isnt good
			switch(index) {
				case 0: // hat
					colorSwap.colorReplaceHat = lineData;
					colorData.hat = theFlxColor;
				case 1: // skin
					colorSwap.colorReplaceSkin = lineData;
					colorData.skin = theFlxColor;
				case 2: // hair
					colorSwap.colorReplaceHair = lineData;
					colorData.hair = theFlxColor;

				case 3: // shirt
					colorSwap.colorReplaceShirt = lineData;
					colorData.shirt = theFlxColor;
				case 4: // stripe
					colorSwap.colorReplaceStripe = lineData;
					colorData.stripes = theFlxColor;

				case 5: // pants
					colorSwap.colorReplacePants = lineData;
					colorData.pants = theFlxColor;
				case 6: // shoes
					colorSwap.colorReplaceShoes = lineData;
					colorData.shoes = theFlxColor;
			}
		}

		if (whatDoICallThisVariable == true) {
			dude.loadGraphic(Paths.image("editors/make-a-dude/" + (whatDoICallThisVariable ? "player-f" : "dude")));
			dude.screenCenter();
		}
	} else {
		dudeName.label.text = "that skin doesnt exist!";
		loadSkin("default");
	}
}

function create() {
	playMenuMusic();
	
	var bg:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image("menus/backgrounds/1"));
	bg.zoomFactor = 0;
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
	bg.scrollFactor.set(0, 0.5);
	add(bg);

	dude = new FunkinSprite().loadGraphic(Paths.image("editors/make-a-dude/dude"));
	dude.screenCenter();
	dude.shader = colorSwap;
	add(dude);

	loadSkin(userSkins.selected);
}

var showPickerButton:UIButton;

var skinButton:UIButton; // what!
var hairButton:UIButton;
var hatButton:UIButton;

var shirtButton:UIButton;
var stripesButton:UIButton;

var pantsButton:UIButton;
var shoesButton:UIButton;

// the things i'll do because abstracts are fucking stupid
function iMightKillYou(picker:UIColorwheel, color:FlxColor) {
	picker.curColor = color;

	picker.hue = FlxColorHelper.hue(color);
	picker.saturation = FlxColorHelper.saturation(color);
	picker.brightness = FlxColorHelper.brightness(color);

	picker.updateWheel();
}

var whatDoICallThisVariable:Bool = false;
function postCreate() {
	STUPIDFUCKINGCAMERA = new FlxCamera();
	STUPIDFUCKINGCAMERA.bgColor = 0;
	FlxG.cameras.add(STUPIDFUCKINGCAMERA, false);
		
	var dumbBar1:FunkinSprite = new FunkinSprite().makeSolid(FlxG.width, FlxG.height/10, 0xFF000000);
	dumbBar1.zoomFactor = 0;
	add(dumbBar1);

	var dumbBar2:FunkinSprite = new FunkinSprite(0, FlxG.height-(FlxG.height/10)).makeSolid(FlxG.width, FlxG.height/10, 0xFF000000);
	dumbBar2.zoomFactor = 0;
	add(dumbBar2);

	var dumbText:UIText = new UIText(5, 0, 390, "SKIN CREATOR", 24, 0xFFFFFFFF, true);
	dumbText.alignment = 'left';
	dumbText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	dumbText.textField.antiAliasType = 0; // advanced
	dumbText.textField.sharpness = 400; // max i think idk thats what it says
	dumbText.font = Paths.font("COMICBD.TTF");
	dumbText.borderSize = 2;
	add(dumbText);

	var dumberText:UIText = new UIText(5, dumbBar2.y, 390, "THIS WAS A PAIN TO CODE", 24, 0xFFFFFFFF, true);
	dumberText.alignment = 'center';
	dumberText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	dumberText.textField.antiAliasType = 0; // advanced
	dumberText.textField.sharpness = 400; // max i think idk thats what it says
	dumberText.font = Paths.font("COMICBD.TTF");
	dumberText.borderSize = 2;
	add(dumberText);

	var creditAvery:UIText = new UIText(5, 5, 190, "ENTIRELY BASED OFF OF AVERY'S \"CREATE A DUDE\" CONCEPT ART", 8, 0xFFFFFFFF, true);
	creditAvery.x = FlxG.width - creditAvery.width - 5;
	creditAvery.alignment = 'right';
	creditAvery.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	creditAvery.textField.antiAliasType = 0; // advanced
	creditAvery.textField.sharpness = 400; // max i think idk thats what it says
	creditAvery.font = Paths.font("COMIC.TTF");
	creditAvery.borderSize = 2;
	add(creditAvery);

	colorPicker = new UIColorwheel(5, 190, 0xFFFFFFFF);
	add(colorPicker);
	colorPicker.visible = false;

	showPickerButton = new UIButton(5, 46, "show color picker", () -> {
		colorPicker.visible = !colorPicker.visible;
		if (colorPicker.visible) {
			dumbZoom = 0.8;
			dumbPos.y += 85;
		} else {
			dumbZoom = 1.4;
			dumbPos.y -= 85;
		}
	}, 128);
	add(showPickerButton);

	genderButton = new UIButton(5, 46 + showPickerButton.bHeight + 7, "the gender button", () -> {
		whatDoICallThisVariable = !whatDoICallThisVariable;
		dude.loadGraphic(Paths.image("editors/make-a-dude/" + (whatDoICallThisVariable ? "player-f" : "dude")));
		dude.screenCenter();
	}, 128);
	add(genderButton);

	randomizeButton = new UIButton(showPickerButton.x + showPickerButton.bWidth + 5, 46, "randomize", () -> {
		// fuck you bitch your fault for using a randomize button

		function randomColor():{r:Float, g:Float, b:Float, color:FlxColor} {
			var color:FlxColor = FlxG.random.color(null, null, 1);
			return {r: FlxColorHelper.redFloat(color), g: FlxColorHelper.greenFloat(color), b: FlxColorHelper.blueFloat(color), color: color};
		}

		var hat = randomColor();
		colorSwap.colorReplaceHat = [hat.r, hat.g, hat.b, 1];
		colorData.hat = hat.color;
		var skin = randomColor();
		colorSwap.colorReplaceSkin = [skin.r, skin.g, skin.b, 1];
		colorData.skin = skin.color;
		var hair = randomColor();
		colorSwap.colorReplaceHair = [hair.r, hair.g, hair.b, 1];
		colorData.hair = hair.color;

		var shirt = randomColor();
		colorSwap.colorReplaceShirt = [shirt.r, shirt.g, shirt.b, 1];
		colorData.shirt = shirt.color;
		var stripe = randomColor();
		colorSwap.colorReplaceStripe = [stripe.r, stripe.g, stripe.b, 1];
		colorData.stripes = stripe.color;

		var pants = randomColor();
		colorSwap.colorReplacePants = [pants.r, pants.g, pants.b, 1];
		colorData.pants = pants.color;
		var shoes = randomColor();
		colorSwap.colorReplaceShoes = [shoes.r, shoes.g, shoes.b, 1];
		colorData.shoes = shoes.color;

		whatDoICallThisVariable = FlxG.random.bool(50);
		dude.loadGraphic(Paths.image("editors/make-a-dude/" + (whatDoICallThisVariable ? "player-f" : "dude")));
		dude.screenCenter();
	}, 180);
	randomizeButton.color = 0xFFFFFF00;
	add(randomizeButton);

	// because life isnt good
	var w = 72;
	skinButton = new UIButton(FlxG.width - (w + 5), 0, "skin", null, w, 32);
	hairButton = new UIButton(FlxG.width - (w + 5), 0, "hair", null, w, 32);
	hatButton = new UIButton(FlxG.width - (w + 5), 0, "hat", null, w, 32);
	add(skinButton);
	add(hairButton);
	add(hatButton);

	shirtButton = new UIButton(FlxG.width - (w + 5), 0, "shirt", null, w, 32);
	stripesButton = new UIButton(FlxG.width - (w + 5), 0, "stripes", null, w, 32);
	add(shirtButton);
	add(stripesButton);

	pantsButton = new UIButton(FlxG.width - (w + 5), 0, "pants", null, w, 32);
	shoesButton = new UIButton(FlxG.width - (w + 5), 0, "shoes", null, w, 32);
	add(pantsButton);
	add(shoesButton);

	buttonArr = [skinButton, hairButton, hatButton, shirtButton, stripesButton, pantsButton, shoesButton];
	for (spr in buttonArr) {
		spr.y = 46 + (39.5 * (buttonArr.indexOf(spr)));
		spr.cameras = [STUPIDFUCKINGCAMERA];
		spr.autoAlpha = false;
		spr.alpha = 0.5;

		spr.callback = () -> {
			selectedButton = buttonArr.indexOf(spr);
			var separateLoopStatementBecauseLifeIsntGoodVarHate = [
				colorData.skin,
				colorData.hair,
				colorData.hat,
		
				colorData.shirt,
				colorData.stripes,
		
				colorData.pants,
				colorData.shoes,
			];
			iMightKillYou(colorPicker, separateLoopStatementBecauseLifeIsntGoodVarHate[buttonArr.indexOf(spr)]);
			updateColors = true;
		};
	}

	saveButton = new UIButton(0, dumbBar2.y-37, "save", null, 72, 32);
	saveButton.x = FlxG.width-saveButton.bWidth-5;
	add(saveButton);
	saveButton.color = 0xFF00FF00;

	loadButton = new UIButton(0, dumbBar2.y-37, "load", null, 72, 32);
	loadButton.x = saveButton.x-saveButton.bWidth-5;
	add(loadButton);
	loadButton.color = 0xFF0000FF;

	cancelButton = new UIButton(0, dumbBar2.y-37, "cancel", () -> {
		FlxG.switchState(new UIState(true, "skin-creator/ChooseASkin"));
	}, 72, 32);
	cancelButton.x = loadButton.x-loadButton.bWidth-5;
	add(cancelButton);
	cancelButton.color = 0xFFFF0000;
	
	dudeName = new UITextBox(5, dumbBar2.y-37, userSkins.selected, FlxG.width-242, 32);
	add(dudeName);

	saveButton.callback = () -> {
		var data:String = "";

		for (color in [colorData.hat, colorData.skin, colorData.hair, colorData.shirt, colorData.stripes, colorData.pants, colorData.shoes]) {
			var arr:Array<Float> = [FlxColorHelper.red(color), FlxColorHelper.green(color), FlxColorHelper.blue(color), 1];
			data += "\n" + arr;
		}
		data = StringTools.replace(StringTools.replace(data, "]", ""), "[", "");

		var stupid = {
			name: dudeName.label.text,
			data: data,
			clickedGenderButton: whatDoICallThisVariable
		};

		if (Assets.exists(Paths.txt("skins/" + stupid.name)))
			stupid.name = "user-" + stupid.name;

		for (dumb in userSkins.skins) {
			if (dumb.name != stupid.name) {
				if (dumb != CoolUtil.last(userSkins.skins))
					continue;
			} else {
				userSkins.skins.remove(dumb);
			}
		}
		userSkins.skins.push(stupid);

		File.saveContent("mods/free-download-skins.json", Json.stringify(userSkins));
	};

	loadButton.callback = () -> {
		loadSkin(dudeName.label.text);
	};

	for (i in [dumbBar1, dumbBar2, dumbText, dumberText, creditAvery, colorPicker, showPickerButton, genderButton, dudeName, saveButton, loadButton, cancelButton, randomizeButton])
		i.cameras = [STUPIDFUCKINGCAMERA];
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.ESCAPE) {
		FlxG.switchState(new UIState(true, "skin-creator/ChooseASkin"));
	}

	for (hate in buttonArr)
		hate.alpha = buttonArr.indexOf(hate) == selectedButton ? 1 : 0.5;

	if (updateColors) {
		var color:FlxColor = FlxColor.fromString(colorPicker.curColorString);
		var shaderArr:Array<Float> = [FlxColorHelper.redFloat(color), FlxColorHelper.greenFloat(color), FlxColorHelper.blueFloat(color), 1];
		
		// SWITCH STATEMENT IN UPDATE FUNCTION BECAUSE LIFE ISNT GOOD.
		switch(selectedButton) {
			case 0: // skin
				colorSwap.colorReplaceSkin = shaderArr;
				colorData.skin = color;
			case 1: // hair
				colorSwap.colorReplaceHair = shaderArr;
				colorData.hair = color;
			case 2: // hat
				colorSwap.colorReplaceHat = shaderArr;
				colorData.hat = color;
				
			case 3: // shirt
				colorSwap.colorReplaceShirt = shaderArr;
				colorData.shirt = color;
			case 4: // stripes
				colorSwap.colorReplaceStripe = shaderArr;
				colorData.stripes = color;
				
			case 5: // pants
				colorSwap.colorReplacePants = shaderArr;
				colorData.pants = color;
			case 6: // shoes
				colorSwap.colorReplaceShoes = shaderArr;
				colorData.shoes = color;
		}
	}

	FlxG.camera.zoom = lerp(FlxG.camera.zoom, dumbZoom, 0.06);
	FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, dumbPos.x, 0.06);
	FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, dumbPos.y, 0.06);
}