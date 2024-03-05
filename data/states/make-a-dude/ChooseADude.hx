import haxe.Json;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UIColorwheel;
import sys.io.File;
import sys.FileSystem;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

var camUI:FlxCamera;
var userSkins = Json.parse(File.getContent("mods/free-download-skins.json"));
var backButton:UIButton;
var editButton:UIButton;

var skinText:UIText;
var enterText:UIText;
var arrows:UIText;
var dude:FunkinSprite;

var camZoom:Float = 1.4;

var selectedFormat:FlxTextFormat = new FlxTextFormat(0xFF00FF62, true);
var notSelectedFormat:FlxTextFormat = new FlxTextFormat(0xFFFF0055, true);
var markupRules:Array<FlxTextFormatMarkerPair> = [new FlxTextFormatMarkerPair(selectedFormat, "$"), new FlxTextFormatMarkerPair(notSelectedFormat, "%")];

var curSelected:Int = 0;
var skins:Array<{data:String, name:String}> = [];

var dudeColors:CustomShader;
var selectSound:FlxSound;

function create() {
	playMenuMusic();

	for (i in Paths.getFolderContent("data/skins")) {
		skins.push({
			name: StringTools.replace(i, ".txt", ""),
			data: Assets.getText(Paths.txt("skins/" + StringTools.replace(i, ".txt", "")))
		});
	}
	
	for (i in userSkins.skins) {
		skins.push(i);
	}

	for (index => data in skins) {
		if (userSkins.selected == data.name)
			curSelected = index;
	}

	var bg:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image("menus/backgrounds/1"));
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
	bg.scale.set(1, 1);
	bg.zoomFactor = 0.25;
	add(bg);

	dude = new FunkinSprite().loadGraphic(Paths.image("editors/make-a-dude/dude"));
	dude.screenCenter();
	add(dude);

	skinText = new UIText(0, dude.y - 55, FlxG.width, "you shuoldnt be seeing this text.......", 16, 0xFFFFFFFF, true);
	skinText.alignment = 'center';
	skinText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	skinText.textField.antiAliasType = 0; // advanced
	skinText.textField.sharpness = 400; // max i think idk thats what it says
	skinText.font = Paths.font("COMIC.TTF");
	skinText.borderSize = 2;
	add(skinText);

	// :-)
	arrows = new UIText(0, 0, FlxG.width, "<                                >", 16, 0xFFFFFFFF, true);
	arrows.alignment = 'center';
	arrows.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	arrows.textField.antiAliasType = 0; // advanced
	arrows.textField.sharpness = 400; // max i think idk thats what it says
	arrows.font = Paths.font("COMIC.TTF");
	arrows.borderSize = 2;
	arrows.screenCenter(FlxAxes.Y);
	add(arrows);

	enterText = new UIText(0, dude.y + dude.height + 15, FlxG.width, "press enter to select\npress X to delete", 16, 0xFFFFFFFF, true);
	enterText.alignment = 'center';
	enterText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	enterText.textField.antiAliasType = 0; // advanced
	enterText.textField.sharpness = 400; // max i think idk thats what it says
	enterText.font = Paths.font("COMIC.TTF");
	enterText.borderSize = 2;
	add(enterText);

	dude.shader = dudeColors = new CustomShader("dude-colorswap");
	updateSkin();

	selectSound = FlxG.sound.load(Paths.sound("gameplay/ayy/dude"));
}

function updateSkin() {
	loadDudeSkin(dudeColors, skins[curSelected].name);

	skinText.text = skins[curSelected].name + "\n" + (skins[curSelected].name == userSkins.selected ? "$[SELECTED]$" : "%[UNSELECTED]%");
	skinText.applyMarkup(skinText.text, markupRules);
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

	backButton = new UIButton(4, 4, "go back", () -> {
		FlxG.switchState(fromGame ? new PlayState() : new MainMenuState());
	}, 128, 32);
	add(backButton);

	editButton = new UIButton(FlxG.width - backButton.bWidth - 4, 4, "make a dude", () -> {
		FlxG.switchState(new UIState(true, "make-a-dude/MakeADude"));
	}, backButton.bWidth, 32);
	add(editButton);

	for (i in [dumbBar1, dumbBar2, dumbText, backButton, editButton])
		i.cameras = [camUI];
}

var deletingDude:Bool = false;
var canDelete:Bool = true;
var userSkins = Json.parse(File.getContent("mods/free-download-skins.json"));
function update(elapsed:Float) {
	if (controls.BACK && !deletingDude) {
		FlxG.switchState(fromGame ? new PlayState() : new MainMenuState());
	} else if (controls.BACK && deletingDude)  {
		deletingDude = false;
		enterText.text = "press enter to select\npress X to delete";
	}

	if ((controls.LEFT_P || controls.RIGHT_P) && !deletingDude) {
		curSelected = FlxMath.wrap(curSelected + (controls.LEFT_P ? -1 : 1), 0, skins.length-1);
		updateSkin();
		arrows.x += controls.LEFT_P ? -5 : 5;
		dude.x += controls.LEFT_P ? -10 : 10;
	}

	if (controls.ACCEPT && !deletingDude) {
		userSkins.selected = skins[curSelected].name;
		File.saveContent("mods/free-download-skins.json", Json.stringify(userSkins));
		updateSkin();

		dude.scale.set(1.1, 1.1);
		selectSound.play(true);
	}

	if (FlxG.keys.justPressed.X && canDelete) {
		if (!deletingDude) {
			if (userSkins.skins.contains(skins[curSelected])) {
				enterText.text = "press X again to delete this skin\npress BACK to cancel";
				deletingDude = true;
			} else {
				enterText.text = "you can't delete this one silly!"; // it's not a user-created skin
				canDelete = false;
				FlxTween.shake(enterText, 0.01, 0.1);
				new FlxTimer().start(2, (t:FlxTimer) -> {
					enterText.text = "press enter to select\npress X to delete";
					canDelete = true;
				});
			}
		} else {
			for (dumb in userSkins.skins) {
				if (dumb.name == skins[curSelected].name) {
					if (dumb.name == userSkins.selected) {
						userSkins.selected = "default";
					}
					userSkins.skins.remove(dumb);
				}
			}
			File.saveContent("mods/free-download-skins.json", Json.stringify(userSkins));

			FlxG.switchState(new UIState(true, "make-a-dude/ChooseADude"));
		}
	}

	skinText.x = arrows.x = lerp(arrows.x, 0, 0.12);
	skinText.alpha = dude.alpha = lerp(dude.alpha, 1, 0.12);
	dude.x = lerp(dude.x, 146, 0.24);
	dude.scale.x = lerp(dude.scale.x, 1, 0.12);
	dude.scale.y = lerp(dude.scale.y, 1, 0.12);

	FlxG.camera.zoom = lerp(FlxG.camera.zoom, camZoom, 0.06);
}