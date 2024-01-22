import openfl.geom.ColorTransform;

var youTxt:FunkinText;
var badguyTxt:FunkinText;

var playerDirTxt:FunkinText;
var opponentDirTxt:FunkinText;

function postCreate() {
	youTxt = new FunkinText(243, 135, 0, 'YOU', 36, true);
	youTxt.alignment = 'center';
	youTxt.antialiasing = false;
	youTxt.setFormat(Paths.font("mariones.ttf"), youTxt.size, 0xFF000000, youTxt.alignment, youTxt.borderStyle, 0xFFFFFFFF);
	youTxt.borderSize = 1;
	youTxt.bold = true;
	youTxt.textField.antiAliasType = 0;
	youTxt.textField.sharpness = 400;
	youTxt.alpha = 0;
	add(youTxt);

	badguyTxt = new FunkinText(28, 139, 0, 'BADGUY', 24, true);
	badguyTxt.alignment = 'center';
	badguyTxt.antialiasing = false;
	badguyTxt.setFormat(Paths.font("mariones.ttf"), badguyTxt.size, 0xFF000000, badguyTxt.alignment, badguyTxt.borderStyle, 0xFFFFFFFF);
	badguyTxt.borderSize = 1;
	badguyTxt.bold = true;
	badguyTxt.textField.antiAliasType = 0;
	badguyTxt.textField.sharpness = 400;
	badguyTxt.alpha = 0;
	add(badguyTxt);

	playerDirTxt = new FunkinText(205, 145, 185, 'LEFT', 32, true);
	opponentDirTxt = new FunkinText(0, 145, 185, 'LEFT', 32, true);
	for (index => text in [playerDirTxt, opponentDirTxt]) {
		text.alignment = "center";
		text.antialiasing = false;
		text.setFormat(Paths.font("mariones.ttf"), text.size, 0xFF000000, text.alignment, text.borderStyle, 0xFFFFFFFF);
		text.borderSize = 1;
		text.bold = true;
		text.textField.antiAliasType = 0;
		text.textField.sharpness = 400;
		text.alpha = 0;
		add(text);
	}
}

function beatHit() {
	switch curBeat {
		case 0:
			tweenText(youTxt, true, {time: 0.5});
		case 4:
			tweenText(badguyTxt, true, {time: 0.5});
		case 6:
			tweenText(youTxt, false, {time: 0.5});
			tweenText(badguyTxt, false, {time: 0.5});
		case 40: showDirection = false;
		case 88: showDirection = true;
	}
}

var showDirection:Bool = true;
function onNoteHit(event) {
	if (showDirection) {
		var text:FunkinText = event.note.strumLine.opponentSide ? opponentDirTxt : playerDirTxt;
		text.text = ["LEFT", "DOWN", "UP", "RIGHT"][event.direction];
		text.colorTransform = new ColorTransform();
		tweenText(text, false, {time: 0.25, startDelay: 0.25});
	}
}

function tweenText(text:FunkinText, visible:Bool, data) {
	FlxTween.cancelTweensOf(text);
	FlxTween.cancelTweensOf(text.colorTransform);
	if (visible) {
		text.setColorTransform(0, 0, 0, 1, 255, 255, 255, 0);
		text.alpha = 0;
		FlxTween.tween(text, {alpha: 1}, 0.5, data);
		FlxTween.tween(text.colorTransform, {
			redMultiplier: 1, greenMultiplier: 1, blueMultiplier: 1,
			redOffset: 0, greenOffset: 0, blueOffset: 0
		}, data.time, data);
	} else {
		text.alpha = 1;
		FlxTween.tween(text, {alpha: 0}, 0.5, data);
		FlxTween.tween(text.colorTransform, {
			redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0,
			redOffset: 255, greenOffset: 255, blueOffset: 255
		}, data.time, data);
	}
}