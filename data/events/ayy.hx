// shut up vsc

function onEvent(e)
	if (e.event.name == "ayy") {
		var animToPlay:String = strumLines.members[e.event.params[0]].cpu ? "ayy" : (flow <= 0 ? "ayy-bad" : "ayy");
		if (Std.parseInt(e.event.params[1]) == -1)
			for (character in strumLines.members[e.event.params[0]].characters) {
				character.playAnim(animToPlay, true, "MISS");
				if (!StringTools.contains(character.curCharacter, 'lady') && Assets.exists(Paths.sound('gameplay/ayy/${character.curCharacter}'))) {
					FlxG.sound.play(Paths.sound('gameplay/ayy/${character.curCharacter}'));
				}
			}
		else {
			var character:Character = strumLines.members[e.event.params[0]].characters[Std.parseInt(e.event.params[1])];
			character.playAnim(animToPlay, true, "MISS");
			if (!StringTools.contains(character.curCharacter, 'lady') && Assets.exists(Paths.sound('gameplay/ayy/${character.curCharacter}'))) {
				FlxG.sound.play(Paths.sound('gameplay/ayy/${character.curCharacter}'));
			}
		}
	}