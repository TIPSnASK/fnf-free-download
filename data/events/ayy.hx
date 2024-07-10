// shut up vsc

public var ayySounds:Array<Array<FlxSound>> = [];

function postCreate() {
	for (sl in strumLines.members) {
		var _ayys:Array<FlxSound> = [];
		for (character in sl.characters) {
			if (!StringTools.contains(character.curCharacter, 'lady') && Assets.exists(Paths.sound('gameplay/ayy/${character.curCharacter}'))) {
				_ayys.push(FlxG.sound.load(Paths.sound('gameplay/ayy/${character.curCharacter}'), 0.75));
			}
		}
		ayySounds.push(_ayys);
	}
}

function onEvent(e)
	if (e.event.name == "ayy") {
		var animToPlay:String = strumLines.members[e.event.params[0]].cpu ? "ayy" : (flow <= 0 ? "ayy-bad" : "ayy");
		if (Std.parseInt(e.event.params[1]) == -1)
			for (index => character in strumLines.members[e.event.params[0]].characters) {
				character.playAnim(animToPlay, true, "MISS");
				if (!StringTools.contains(character.curCharacter, 'lady') && Assets.exists(Paths.sound('gameplay/ayy/${character.curCharacter}'))) {
					ayySounds[e.event.params[0]][index].play(true);
				}
			}
		else {
			var character:Character = strumLines.members[e.event.params[0]].characters[Std.parseInt(e.event.params[1])];
			character.playAnim(animToPlay, true, "MISS");
			if (!StringTools.contains(character.curCharacter, 'lady') && Assets.exists(Paths.sound('gameplay/ayy/${character.curCharacter}'))) {
				ayySounds[e.event.params[0]][Std.parseInt(e.event.params[1])].play(true);
			}
		}
	}