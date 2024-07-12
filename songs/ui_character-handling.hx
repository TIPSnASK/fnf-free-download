function postCreate() {
	// for (sL in strumLines.members) {
	// 	for (index => char in sL.characters) {
	// 		if (StringTools.contains(char.curCharacter, "dude") && iKnowWhatYouAre()) {
	// 			sL.characters.remove(char);
	// 			remove(char);
	// 			var charPosName:String = sL.position == null ? (switch(sL.type) {
	// 				case 0: "dad";
	// 				case 1: "boyfriend";
	// 				case 2: "girlfriend";
	// 			}) : sL.position;
	// 			char = new Character(char.x, char.y, StringTools.replace(char.curCharacter, "dude", "player-f"), !stage.isCharFlipped(charPosName, sL.type == 1));
	// 			stage.applyCharStuff(char, charPosName, index);
	// 			sL.characters.push(char);
	// 		}
	// 	}
	// }
}

function onGamePause(event) {
	for (sl in strumLines.members) {
		for (character in sl.characters) {
			var data = {
				anim: character.animation.curAnim,
				context: character.lastAnimContext
			};
			character.playAnim("paused", true);

			new FlxTimer().start(.001, (t:FlxTimer) -> {
				if (FlxG.state == PlayState.instance)
					character.playAnim(data.anim.name, true, data.context, false, data.anim.curFrame);
				if (t != null)
					t.destroy();
			});
		}
	}
}

function postUpdate(elapsed:Float) {
	for (sl in strumLines.members) {
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
				character.animation.curAnim.frameRate = character.animDatas[character.getAnimName()].fps*((Conductor.bpm >= 150 ? Conductor.bpm * 0.8 : Conductor.bpm)/fpsDivideVal);
		}
	}
}

function beatHit() {
	for (sl in strumLines)
		for (character in sl.characters) {
			if (StringTools.contains(character.curCharacter, 'lady')) return;
			if (character.danceOnBeat) character.danceOnBeat = false;
			if (["SING", "MISS"].contains(character.lastAnimContext) && character.lastHit + (Conductor.stepCrochet * character.holdTime) < Conductor.songPosition)
				character.playAnim('idle', true, 'DANCE');
			else if (character.lastAnimContext == "DANCE")
				character.playAnim('idle', true, 'DANCE');
		}
}