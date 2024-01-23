import Xml;
import funkin.backend.utils.XMLUtil;
import funkin.backend.utils.IniUtil;

var xml:Xml;
var curElements:Array<Xml>;
var dumb:String = isPostCutscene ? "post" : "pre";
var song:String = PlayState.instance.SONG.meta.name;
var curIndex:Int = -1;

var music:FlxSound;
var curSprite:FunkinSprite;
var dialogBox:FunkinSprite;
var cutsceneCam:FlxCamera;

var speakerText:FunkinText;
var dialogText:FunkinText;

var curDialogBox:String = "normal";

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
	dialogText.borderSize = 2;
	dialogText.visible = false;
	add(dialogText);

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
		case "dialogbox":
			makeDialogBoxFromXml(element);
			next();
		case "wait":
			new FlxTimer().start(Std.parseFloat(element.get("time")), (t:FlxTimer) -> {
				next();
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
			music = CoolUtil.playMusic(Paths.music(element.get("path")));
			next();
		case "sprite":
			remove(curSprite);
			curSprite = new FunkinSprite();
			curSprite = CoolUtil.loadAnimatedGraphic(curSprite, Paths.image("cutscenes/" + PlayState.storyWeek.id + "/" + element.get("path")));
			curSprite.cameras = [cutsceneCam];
			add(curSprite);
			next();
		case "talk":
			dialogBox.visible = speakerText.visible = dialogText.visible = true;
			dialogText.text = "";

			speakerData = IniUtil.parseAsset(Paths.ini("dialog/" + element.get("character")));
			speakerText.text = speakerData["DisplayName"];
			speakerText.color = dialogText.color = FlxColor.fromString(speakerData["Color"]);
			dialog = XMLUtil.fixXMLText(getInnerData(element));
			talkSound = FlxG.sound.load(Paths.sound("dialog/" + speakerData["TalkSound"]));
			talkSound.volume = 0.8;

			dialogProgress = 0;
			inDialog = true;
	}
}

var speakerData:Map<String, String> = [];
var dialog:String = "";
var dialogProgress:Int = -1;
var imInTheMiddleOfSomething:Bool = false;
var talkSound:FlxSound;
function updateDialog() {
	dialogText.text = dialog.substring(0, dialogProgress+1);
	
	if (dialogProgress >= dialog.length) {
		dialogProgress = -1;
		return;
	}
	if (!imInTheMiddleOfSomething) {
		imInTheMiddleOfSomething = true;
		new FlxTimer().start((talkSound.length), () -> {
			talkSound.play(false);
			dialogProgress ++;
			imInTheMiddleOfSomething = false;
		});
	}
}

var inDialog:Bool = false;
function update(elapsed:Float) {
	if (dialogProgress != -1)
		updateDialog();

	if (inDialog && controls.ACCEPT)
		next();
	if (inDialog && FlxG.keys.justPressed.SHIFT)
		dialogProgress = dialog.length;
}