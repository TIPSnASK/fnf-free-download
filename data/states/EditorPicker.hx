import flixel.effects.FlxFlicker;
import funkin.editors.ui.UIState;
import funkin.backend.scripting.Script;

var editors:Array<String> = [];

function create() {
    for (i in Paths.getFolderDirectories('data/states/editors')) {
        editors.push(i);

        var data = {
            name: i,
            iconID: 0,
            state: UIState
        };

        options.push(data);
    }
}

function postCreate() {
    for (i in editors) {
        var dumbIndex = options.length-editors.length + editors.indexOf(i);
        var stupidShit:FlxSprite = sprites[dumbIndex].members[1];
        
        sprites[dumbIndex].remove(stupidShit);
    
        stupidShit = new FlxSprite();
        stupidShit.loadGraphic(Paths.file('data/states/editors/' + i + '/icon.png'), true, 128, 128);
		stupidShit.antialiasing = true;

        var frames = [];
        var stupidFrame:Int = 0;

        for (i in 0...(stupidShit.graphic.width / 128)) {
            frames.push(stupidFrame);
            stupidFrame ++;
        }

        stupidShit.animation.add('icon', frames, 24, true);
        stupidShit.animation.play('icon', true);

        stupidShit.antialiasing = true;
        if (sprites[dumbIndex].height < 150) {
			stupidShit.scale.set(sprites[dumbIndex].height / 150, sprites[dumbIndex].height / 150);
			stupidShit.updateHitbox();
		}
        stupidShit.x = 25 + ((sprites[dumbIndex].height - stupidShit.width) / 2);
        stupidShit.y = (sprites[dumbIndex].height - stupidShit.height) / 2;
    
        sprites[dumbIndex].insert(1, stupidShit);
    }
}

var overrodeFlicker = false;
function update() {
	if (overrodeFlicker) return;

    for (i in sprites) {
        i.members[1].x = i.members[2].x - 25 - i.members[1].width;
		i.members[1].angle = Math.sin(i.iconRotationCycle * 0.5) * 5;
    }

    for (i in editors) {
        var dumbIndex = options.length-editors.length + editors.indexOf(i);

        if (curSelected == dumbIndex && selected && FlxFlicker.isFlickering(sprites[dumbIndex].label)) {
            FlxFlicker._boundObjects[sprites[dumbIndex].label].completionCallback = function(flick) {
                subCam.fade(0xFF000000, 0.25, false, function() {
                    Script.staticVariables.set('currentEditor', i);
                    FlxG.switchState(new UIState(true, 'editors/' + i + '/state'));
                });
            }
            overrodeFlicker = true;
        }
    }
}