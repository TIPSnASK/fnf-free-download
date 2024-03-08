import Xml;
import funkin.backend.utils.XMLUtil;
import funkin.backend.utils.IniUtil;
import sys.io.File;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

var xml:Xml;
var curElements:Array<Xml>;
var dumb:String = "pre";
var song:String = PlayState.instance.SONG.meta.name;
var curIndex:Int = -1;

var music:FlxSound;
var curSprite:FunkinSprite;
var dialogBox:FunkinSprite;
var cutsceneCam:FlxCamera;

var speakerText:FunkinText;
var dialogText:FunkinText;

var curDialogBox:String = "normal";

var dudeColors:CustomShader = new CustomShader("dude-colorswap");

var dialogEvents:Array<{name:String, index:Int, value:String}> = [];
var dialogFormats:Array<FlxTextFormatMarkerPair> = [];

var userSkins = Json.parse(File.getContent("mods/free-download-skins.json"));

function create() {
	if (!Assets.exists(Paths.file("songs/" + song + "/cutscene.xml"))) {
		close();
		return;
	}

	xml = Xml.parse(Assets.getText(Paths.file("songs/" + song + "/cutscene.xml")));
	curElements = [for (i in xml.elementsNamed(dumb)) for (k in i.elements()) k];
	for (i in curElements)
		if (i.nodeType == 1)
			curElements.remove(i);

	cutsceneCam = new FlxCamera();
	cutsceneCam.bgColor = 0xFF000000;
	FlxG.cameras.add(cutsceneCam, false);
	
	curSprite = new FunkinSprite().makeSolid();
	curSprite.cameras = [cutsceneCam];
	add(curSprite);

	dialogBox = new FunkinSprite();
	dialogBox = CoolUtil.loadAnimatedGraphic(dialogBox, Paths.image("cutscenes/boxes/" + curDialogBox));
	dialogBox.cameras = [cutsceneCam];
	dialogBox.scale.set(0.5, 0.5);
	dialogBox.updateHitbox();
	dialogBox.screenCenter();
	dialogBox.x = Std.int(dialogBox.x);
	dialogBox.y = FlxG.height - dialogBox.height - 12;
	dialogBox.alpha = 0.5;
	dialogBox.visible = false;
	add(dialogBox);

	speakerText = new FunkinText(dialogBox.x + 10, dialogBox.y - 25, FlxG.width - (dialogBox.x*2) - 20, 'Name', 14, true);
	speakerText.alignment = "left";
	speakerText.antialiasing = false;
	speakerText.cameras = [cutsceneCam];
	speakerText.font = Paths.font("COMICBD.TTF");
	speakerText.textField.antiAliasType = 0;
	speakerText.textField.sharpness = 400;
	speakerText.borderSize = 2;
	speakerText.visible = false;
	add(speakerText);

	// JUST FOUND OUT THAT THERE'S GRADIENTS ON ALL OF THE TEXTS IM NOT FUCKING DOING THAT OH MY GOD IM GONNA KMS
	dialogText = new FunkinText(dialogBox.x + 20, dialogBox.y + 25, dialogBox.width - (dialogBox.x*2) - 20, 'SAMPLE TEXT', 14, true);
	dialogText.alignment = "left";
	dialogText.antialiasing = false;
	dialogText.cameras = [cutsceneCam];
	dialogText.font = Paths.font("COMICBD.TTF");
	dialogText.textField.antiAliasType = 0;
	dialogText.textField.sharpness = 400;
	dialogText.borderStyle = FlxTextBorderStyle.OUTLINE;
	dialogText.borderSize = 2;
	dialogText.visible = false;

	add(dialogText);

	loadDudeSkin(dudeColors, Json.parse(File.getContent("mods/free-download-skins.json")).selected);

	next();
}

function makeDialogBoxFromXml(xml:Xml) {
	curDialogBox = xml.get("name");

	remove(dialogBox);
	dialogBox = new FunkinSprite();
	dialogBox = CoolUtil.loadAnimatedGraphic(dialogBox, Paths.image("cutscenes/boxes/" + curDialogBox));
	dialogBox.cameras = [cutsceneCam];
	var scale:Float = xml.exists("scale") ? Std.parseFloat(xml.get("scale")) : 0.5;
	dialogBox.scale.set(scale, scale);
	dialogBox.updateHitbox();
	dialogBox.screenCenter();
	dialogBox.x = Std.int(dialogBox.x);
	dialogBox.y = FlxG.height - dialogBox.height - 12;
	dialogBox.alpha = xml.exists("alpha") ? Std.parseFloat(xml.get("alpha")) : 0.5;
	dialogBox.visible = false;
	insert(members.indexOf(dialogText), dialogBox);
}

function next() {
	curIndex++;
	if (curElements[curIndex] == null)
		return;
	var element:Xml = curElements[curIndex];
	switch element.nodeName {
		default:
			trace(element.nodeName + "???????");
		case "close":
			end();
		case "dialogbox":
			makeDialogBoxFromXml(element);
			next();
		case "wait":
			new FlxTimer().start(Std.parseFloat(element.get("time")), (t:FlxTimer) -> {
				next();
				t.destroy();
			});
		case "sound":
			FlxG.sound.play(Paths.sound(element.get("path")));
			next();
		case "music":
			if (music != null) {
				music.stop();
				FlxG.sound.destroySound(music);
				music = null;
			}
			music = FlxG.sound.play(Paths.music(element.get("path")));
			music.looped = true;
			next();
		case "sprite":
			remove(curSprite);
			curSprite = new FunkinSprite();
			curSprite = CoolUtil.loadAnimatedGraphic(curSprite, Paths.image("cutscenes/" + PlayState.storyWeek.id + "/" + element.get("path")));
			curSprite.cameras = [cutsceneCam];
			add(curSprite);
			if (element.exists("dude") && element.get("dude") == "true") {
				curSprite.shader = dudeColors;
			}
			next();
		case "talk":
			dialogEvents = [];
			
			dialogBox.visible = speakerText.visible = dialogText.visible = true;
			dialogText.text = "";

			speakerData = IniUtil.parseAsset(Paths.ini("dialog/" + element.get("character")));
			speakerText.text = StringTools.contains(speakerData["DisplayName"], "Dude") ? Json.parse(File.getContent("mods/free-download-skins.json")).name : speakerData["DisplayName"];
			speakerText.color = dialogText.color = FlxColor.fromString(speakerData["Color"]);
			dialog = XMLUtil.fixXMLText(getInnerData(element));
			talkSound = FlxG.sound.load(Paths.sound("dialog/" + speakerData["TalkSound"]));
			talkSound.volume = 0.8;

			// WORK WITH ME!!!
			if (element.exists("colors")) {
				var arr:Array<String> = element.get("colors").split(",");
				dialogFormats = [for (i in arr) {
					i = StringTools.trim(i);
					color = FlxColor.fromString(i);
					new FlxTextFormatMarkerPair(new FlxTextFormat(color), ["%", "$", "#", "&", "~", "*"][arr.indexOf(i)]);
				}];
			}
			
			if (StringTools.contains(dialog, "[") && StringTools.contains(dialog, "]")) { // parse the damn events you fool!
				var dumb:Array<String> = [
					for (i in dialog.split("[")) {
						var hate:String = i.substring(0, i.indexOf("]"));
						hate;
					}
				];
				var evenDumber:Array<Int> = []; // to keep track of indexes

				// separate for loop statement because life isnt good
				for (hate in dumb) {
					if (hate == "" || StringTools.isSpace(hate)) {
						dumb.remove(hate);
						continue;
					}
				}

				// separate for loop statement because life isnt good
				for (hate in dumb) {
					evenDumber.push(dialog.indexOf("[" + hate + "]"));
					var fuck:Array<String> = hate.split(":");
					var replacer:String = switch fuck[0] {
						default:
							"";
						case "pronoun":
							userSkins.pronouns.split("/")[Std.parseInt(hate.split(":")[1])];
						case "player":
							var theThing:String = switch (Std.parseInt(fuck[1])) {
								case 0: // Normal
									userSkins.name;
								case 1: // lowercase
									userSkins.name.toLowerCase();
								case 2: // UPPERCASE
									userSkins.name.toUpperCase();
							};
							theThing;
					}
					dialog = StringTools.replace(dialog, "[" + hate + "]", replacer);
				}

				for (i in dumb) {
					var awShucks = {
						name: i.split(":")[0],
						index: evenDumber[dumb.indexOf(i)],
						value: i.split(":")[1]
					};
					
					if (awShucks.name != "p") {
						dialogEvents.push(awShucks);
					}
				}
			}

			dialogProgress = 0;
			inDialog = true;
	}
}

var speakerData:Map<String, String> = [];
var dialog:String = "";
var dialogProgress:Int = -1;
var imInTheMiddleOfSomething:Bool = false;
var talkSound:FlxSound;
var canPressEnter:Bool = false;

// events!!
var runningEvent:Bool = false;
var waiting:Bool = false;
function updateDialog() {
	canPressEnter = dialogProgress >= dialog.length;
	if (canPressEnter) {
		dialogProgress = -1;
		return;
	}
	
	dialogText.text = dialog.substring(0, dialogProgress+1);
	dialogText.applyMarkup(dialogText.text, dialogFormats);

	if (!runningEvent) {
		for (dumb in dialogEvents) {
			if (dialogProgress == dumb.index) {
				runningEvent = true;
				switch dumb.name {
					case "wait":
						waiting = true;
						new FlxTimer().start(Std.parseFloat(dumb.value), (t:FlxTimer) -> {
							waiting = false;
							runningEvent = false;
							t.destroy();
							dialogProgress++;
						});
				}
			}
		}
	}

	if (!imInTheMiddleOfSomething && !waiting) {
		imInTheMiddleOfSomething = true;
		new FlxTimer().start((talkSound.length), (t:FlxTimer) -> {
			talkSound.play(false);
			dialogProgress ++;
			t.destroy();
			imInTheMiddleOfSomething = false;
		});
	}
}

var inDialog:Bool = false;
function update(elapsed:Float) {
	if (dialogProgress != -1)
		updateDialog();

	if (inDialog && canPressEnter && controls.ACCEPT)
		next();

	if (controls.BACK) {
		end();
	}
}

function end() {
	cutsceneCam.fade(0xFF000000, 0.25, false, () -> {close();}, true);
}

function destroy() {
	if (music != null) {
		music.stop();
		FlxG.sound.destroySound(music);
		music = null;
	}
	if (FlxG.cameras.list.contains(cutsceneCam)) {
		FlxG.cameras.remove(cutsceneCam, true);
	}
	CoolUtil.last(FlxG.cameras.list).fade(0xFF000000, 0.25, true, null, true);
}