function postUpdate(elapsed:Float) {
	for (sl in strumLines.members) {
		for (note in sl.notes.members)
			if (note.isSustainNote)
				note.y -= 24;

		for (character in sl.characters) {
			var fpsDivideVal:Float = switch(character.getAnimName()) {
				default:
					if (["SING", "MISS", "DANCE"].contains(character.lastAnimContext))
						character.lastAnimContext == "DANCE" ? 150 : 125;
					else
						-1;
				case "ayy": -1;
			}

			if (fpsDivideVal != -1)
				character.animation.curAnim.frameRate = character.animDatas[character.getAnimName()].fps*(Conductor.bpm/fpsDivideVal);
		}
	}
}

function beatHit() {
	for (sl in strumLines)
		for (character in sl.characters) {
			if (character.isGF) return;
			if (character.danceOnBeat) character.danceOnBeat = false;
			if (["SING", "MISS"].contains(character.lastAnimContext) && character.lastHit + (Conductor.stepCrochet * character.holdTime) < Conductor.songPosition)
				character.playAnim('idle', true, 'DANCE');
			else if (character.lastAnimContext == "DANCE")
				character.playAnim('idle', true, 'DANCE');
		}
}