// ENTIRELY BASED OFF OF AVERY'S "CREATE A DUDE" CONCEPT ART
// i'll work on this later lol

import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UIColorwheel;

var STUPIDFUCKINGCAMERA:FlxCamera;
var dude:FunkinSprite;
var colorSwap:CustomShader = new CustomShader("dude-colorswap");
var dumbZoom:Float = 1.4;
var colorPicker:UIColorwheel;

function loadSkin(name:String) {
	var path:String = Paths.txt("skins/" + name);
	if (Assets.exists(path)) {
		trace("hi " + name);

		var dumbData:Array<String> = CoolUtil.coolTextFile(path);
		for (index => line in dumbData) {
			var lineData:Array<Float> = [for (ass in line.split(",")) Std.parseFloat(StringTools.trim(ass))/255];
			
			// Invalid Cast
			switch(index) {
				case 0: colorSwap.colorReplaceHat = lineData;
				case 1: colorSwap.colorReplaceSkin = lineData;
				case 2: colorSwap.colorReplaceHair = lineData;

				case 3: colorSwap.colorReplaceShirt = lineData;
				case 4: colorSwap.colorReplaceStripe = lineData;

				case 5: colorSwap.colorReplacePants = lineData;
				case 6: colorSwap.colorReplaceShoes = lineData;
			}
		}
	} else {
		trace("fuck off " + name);

		colorSwap.colorReplaceHat = [140.0/255.0, 151.0/255.0, 194.0/255.0, 1.0];
		colorSwap.colorReplaceSkin = [238.0/255.0, 214.0/255.0, 196.0/255.0, 1.0];
		colorSwap.colorReplaceHair = [71.0/255.0, 62.0/255.0, 56.0/255.0, 1.0];
		colorSwap.colorReplaceShirt = [215.0/255.0, 121.0/255.0, 156.0/255.0, 1.0];
		colorSwap.colorReplaceStripe = [101.0/255.0, 54.0/255.0, 98.0/255.0, 1.0];
		colorSwap.colorReplacePants = [97.0/255.0, 87.0/255.0, 146.0/255.0, 1.0];
		colorSwap.colorReplaceShoes = [56.0/255.0, 54.0/255.0, 68.0/255.0, 1.0];
	}
}

function create() {
	var bg:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image("menus/backgrounds/1"));
	bg.zoomFactor = 0;
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
	add(bg);

	dude = new FunkinSprite().loadGraphic(Paths.image("editors/make-a-dude/dude"));
	dude.screenCenter();
	dude.shader = colorSwap;
	add(dude);

	loadSkin("statue");
}

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

	var dumbText:UIText = new UIText(5, 0, 390, "MAKE A DUDE", 24, 0xFFFFFFFF, true);
	dumbText.alignment = 'left';
	dumbText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	dumbText.textField.antiAliasType = 0; // advanced
	dumbText.textField.sharpness = 400; // max i think idk thats what it says
	dumbText.font = Paths.font("COMICBD.TTF");
	dumbText.borderSize = 2;
	add(dumbText);

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

	colorPicker = new UIColorwheel(50, 250, 0xFFFFFFFF);
	add(colorPicker);

	for (i in [dumbBar1, dumbBar2, dumbText, creditAvery, colorPicker])
		i.cameras = [STUPIDFUCKINGCAMERA];
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT)
		FlxG.switchState(new UIState(true, "MakeADude"));

	if (controls.BACK)
		FlxG.switchState(new MainMenuState());

	FlxG.camera.zoom = lerp(FlxG.camera.zoom, dumbZoom, 0.06);
}