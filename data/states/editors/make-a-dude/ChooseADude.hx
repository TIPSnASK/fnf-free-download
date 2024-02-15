import haxe.Json;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UIScrollBar;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UIColorwheel;
import sys.io.File;
import sys.FileSystem;
import flixel.addons.display.FlxBackdrop;

var camUI:FlxCamera;
var userSkins = Json.parse(File.getContent("mods/free-download-skins.json"));
var backButton:UIButton;
var editButton:UIButton;

var scrollBar:UIScrollBar;

function create() {
	var bg:FlxBackdrop = new FlxBackdrop().loadGraphic(Paths.image("menus/backgrounds/1"));
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
	bg.scale.set(1.4, 1.4);
	add(bg);
}

function postCreate() {
	camUI = new FlxCamera();
	camUI.bgColor = 0;
	FlxG.cameras.add(camUI, false);

	var dumbBar1:FunkinSprite = new FunkinSprite().makeSolid(FlxG.width, FlxG.height/10, 0xFF000000);
	dumbBar1.zoomFactor = 0;
	add(dumbBar1);

	var dumbBar2:FunkinSprite = new FunkinSprite(0, FlxG.height-(FlxG.height/10)).makeSolid(FlxG.width, FlxG.height/10, 0xFF000000);
	dumbBar2.zoomFactor = 0;
	add(dumbBar2);

	var dumbText:UIText = new UIText(0, 6, FlxG.width, "choose a dude", 16, 0xFFFFFFFF, true);
	dumbText.alignment = 'center';
	dumbText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	dumbText.textField.antiAliasType = 0; // advanced
	dumbText.textField.sharpness = 400; // max i think idk thats what it says
	dumbText.font = Paths.font("COMICBD.TTF");
	dumbText.borderSize = 2;
	add(dumbText);

	backButton = new UIButton(4, 4, "go back", null, 128, 32);
	add(backButton);

	editButton = new UIButton(FlxG.width - backButton.bWidth - 4, 4, "edit skin", null, backButton.bWidth, 32);
	add(editButton);

	scrollBar = new UIScrollBar(0, dumbBar1.height, 800, 0, 100, 20, 320);
	scrollBar.onChange = (value:Float) -> {
		FlxG.camera.scroll.y = value;
	};
	add(scrollBar);

	for (i in [dumbBar1, dumbBar2, dumbText, backButton, editButton, scrollBar])
		i.cameras = [camUI];
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT)
		FlxG.switchState(new UIState(true, "editors/make-a-dude/ChooseADude"));

	FlxG.camera.scroll.y = FlxMath.bound(FlxG.camera.scroll.y - (FlxG.mouse.wheel * 20), 0, 800);

	scrollBar.start = FlxG.camera.scroll.y - (scrollBar.size/2);
}