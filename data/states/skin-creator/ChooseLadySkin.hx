import haxe.Json;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UITextBox;
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
var dudeButton:UIButton;

var yourName:UITextBox;
var theyAddedPronounsToFreeDownload:UITextBox;

var skinText:UIText;
var enterText:UIText;
var arrows:UIText;
var lady:FunkinSprite;

var camZoom:Float = 1;

var selectedFormat:FlxTextFormat = new FlxTextFormat(0xFF00FF62, true);
var notSelectedFormat:FlxTextFormat = new FlxTextFormat(0xFFFF0055, true);
var markupRules:Array<FlxTextFormatMarkerPair> = [new FlxTextFormatMarkerPair(selectedFormat, "$"), new FlxTextFormatMarkerPair(notSelectedFormat, "%")];

var curSelected:Int = 0;
var skins:Array<{data:String, name:String}> = [];

var ladyColors:CustomShader;
var selectSound:FlxSound;

function convert(theThing, lady:Bool) {
	return {clickedGenderButton: theThing.clickedGenderButton, data: theThing.data, name: lady ? !StringTools.startsWith(theThing.name, 'lady-') ? 'lady-${theThing.name}' : theThing.name : StringTools.replace(theThing.name, "lady-", "")};
}

function create() {
	playMenuMusic();

	for (i in Paths.getFolderContent("data/skins")) {
		if (StringTools.startsWith(i, "lady-"))
			skins.push({
				name: StringTools.replace(StringTools.replace(i, "lady-", ""), ".txt", ""),
				data: Assets.getText(Paths.txt('skins/${StringTools.replace(i, ".txt", "")}'))
			});
	}
	
	for (i in userSkins.skins)
		if (StringTools.startsWith(i.name, "lady-")) {
			skins.push(convert(i, false));
		}

	for (index => data in skins) {
		if (userSkins.selectedLady == data.name)
			curSelected = index;
	}

	var bg:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image("menus/backgrounds/1"));
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
	bg.scale.set(1, 1);
	bg.zoomFactor = 0.25;
	add(bg);

	lady = new FunkinSprite().loadGraphic(Paths.image("editors/make-a-lady/lady"));
	lady.screenCenter();
	add(lady);

	skinText = new UIText(0, lady.y - 55, FlxG.width, "you shuoldnt be seeing this text.......", 16, 0xFFFFFFFF, true);
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

	enterText = new UIText(0, lady.y + lady.height + 15, FlxG.width, "press enter to select\npress X to delete", 16, 0xFFFFFFFF, true);
	enterText.alignment = 'center';
	enterText.antialiasing = false;
	// lunarcleint figured this out thank you lunar holy shit 🙏
	enterText.textField.antiAliasType = 0; // advanced
	enterText.textField.sharpness = 400; // max i think idk thats what it says
	enterText.font = Paths.font("COMIC.TTF");
	enterText.borderSize = 2;
	add(enterText);

	lady.shader = ladyColors = new CustomShader("lady-colorswap");
	updateSkin();

	selectSound = FlxG.sound.load(Paths.sound("gameplay/ayy/lady"));
}

function updateSkin() {
	loadLadySkin(ladyColors, skins[curSelected].name);
	skinText.text =  '${skins[curSelected].name}\n${(skins[curSelected].name == userSkins.selectedLady ? "$[SELECTED]$" : "%[UNSELECTED]%")}';
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

	var dumbText:UIText = new UIText(0, 6, FlxG.width, "choose a skin", 16, 0xFFFFFFFF, true);
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

	editButton = new UIButton(FlxG.width - backButton.bWidth - 4, 4, "skin creator", () -> {
		FlxG.switchState(new UIState(true, "skin-creator/LadySkinCreator"));
	}, backButton.bWidth, 32);
	add(editButton);

	dudeButton = new UIButton(5, dumbBar2.y + 4, "dude", () -> {FlxG.switchState(new UIState(true, "skin-creator/ChooseASkin"));}, backButton.bWidth-1.25, 32);
	add(dudeButton);

	yourName = new UITextBox(dudeButton.x + dudeButton.bWidth + 5, dumbBar2.y + 4, (userSkins.name == null || userSkins.name == "") ? "type your name" : userSkins.ladyName, dudeButton.bWidth, 32);
	add(yourName);

	theyAddedPronounsToFreeDownload = new UITextBox(yourName.x + yourName.bWidth + 5, dumbBar2.y + 4, (userSkins.pronouns == null || userSkins.pronouns == "") ? "they/them/theirs" : userSkins.ladyPronouns, dudeButton.bWidth, 32);
	add(theyAddedPronounsToFreeDownload);

	for (i in [dumbBar1, dumbBar2, dumbText, backButton, editButton, dudeButton, yourName, theyAddedPronounsToFreeDownload])
		i.cameras = [camUI];
}

function destroy() {
	userSkins.ladyName = yourName.label.text;
	userSkins.ladyPronouns = theyAddedPronounsToFreeDownload.label.text;
	File.saveContent("mods/free-download-skins.json", Json.stringify(userSkins));
}

var deletingLady:Bool = false;
var canDelete:Bool = true;
var userSkins = Json.parse(File.getContent("mods/free-download-skins.json"));
function update(elapsed:Float) {
	if (!yourName.focused && !theyAddedPronounsToFreeDownload.focused) {
		if (controls.BACK && !deletingLady) {
			FlxG.switchState(fromGame ? new PlayState() : new MainMenuState());
		} else if (controls.BACK && deletingLady)  {
			deletingLady = false;
			enterText.text = "press enter to select\npress X to delete";
		}

		if ((controls.LEFT_P || controls.RIGHT_P) && !deletingLady) {
			curSelected = FlxMath.wrap(curSelected + (controls.LEFT_P ? -1 : 1), 0, skins.length-1);
			updateSkin();
			arrows.x += controls.LEFT_P ? -5 : 5;
			lady.x += controls.LEFT_P ? -10 : 10;
		}

		if (controls.ACCEPT && !deletingLady) {
			userSkins.selectedLady = skins[curSelected].name;
			File.saveContent("mods/free-download-skins.json", Json.stringify(userSkins));
			updateSkin();

			lady.scale.set(1.1, 1.1);
			selectSound.play(true);
		}

		if (FlxG.keys.justPressed.X && canDelete) {
			if (!deletingLady) {
				if (userSkins.skins.contains(convert(skins[curSelected], true))) {
					enterText.text = "press X again to delete this skin\npress BACK to cancel";
					deletingLady = true;
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
					if (dumb.name == skins[curSelected].ladyName) {
						if (dumb.name == userSkins.selectedLady) {
							userSkins.selectedLady = "default";
						}
						userSkins.skins.remove(dumb);
					}
				}
				File.saveContent("mods/free-download-skins.json", Json.stringify(userSkins));

				FlxG.switchState(new UIState(true, "skin-creator/ChooseLadySkin"));
			}
		}
	}

	skinText.x = arrows.x = lerp(arrows.x, 0, 0.12);
	skinText.alpha = lady.alpha = lerp(lady.alpha, 1, 0.12);
	lady.x = lerp(lady.x, 163, 0.24);
	lady.scale.x = lerp(lady.scale.x, 1, 0.12);
	lady.scale.y = lerp(lady.scale.y, 1, 0.12);

	FlxG.camera.zoom = lerp(FlxG.camera.zoom, camZoom, 0.06);
}