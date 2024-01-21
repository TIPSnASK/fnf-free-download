// shut up vsc

function onEvent(e)
	if (e.event.name == "ayy") {
		if (Std.parseInt(e.event.params[1]) == -1)
			for (character in strumLines.members[e.event.params[0]].characters)
				character.playAnim("ayy", true);
		else
			strumLines.members[e.event.params[0]].characters[Std.parseInt(e.event.params[1])].playAnim("ayy", true);
	}