quick info - i'm gonna put variables here under links to what script they come from

you don't need to use these variables in *only* those scripts, it's just there for if you're looking for where they came from

### [songs/ui_camera.hx](../../songs/ui_camera.hx)

the camera positions are no longer tied to your character, but are instead tied to the stage

i'm going to make it so you can just do this in the xml eventually, but for now you have to change the camera positions by making a stage script

### how to mess with the camera stuff:
you can access the camera by using the `camera` variable in your scripts

the `camera` variable is a table, so it has multiple things you can do with it

`camera.pos[index:Int]` - camera positions are on a strumline by strumline basis (starting from index 0), if you had 4 strumlines you would type `camera.pos[3]` to access the 4th camera position

this lets you do `camera.pos[index].x` and `camera.pos[index].y` respectively to get the `x` and `y` positions

(SONG/STAGE SCRIPT ONLY) `camera.lock(x:Float, y:Float)` - will lock the camera to the `x` and `y` position given (you will need to unlock the camera to have it move normally again!)

(SONG/STAGE SCRIPT ONLY) `camera.unlock()` - unlocks the camera

(SONG/STAGE SCRIPT ONLY) `camera.snap()` - will instantly snap the camera to it's target position

(SONG/STAGE SCRIPT ONLY) `_locked` - a `Bool` that is just if the camera is locked or not

(SONG/STAGE SCRIPT ONLY) `_lockPos` - a table that lets you do `_lockPos.x` and `_lockPos.y` to get the current `x` and `y` positions of the locked camera

## hud
### [songs/ui_hud.hx](../../songs/ui_hud.hx)
(SONG/STAGE SCRIPT ONLY) `uiskin` - a `String` that's pretty much only there for a [switch statement in the hud script](https://github.com/TIPSnASK/fnf-free-download/blob/26e9a8eaef432c5febc7302ba0ead928452d23c4/songs/ui_hud.hx#L147)

if you change this in your scripts, you'll need to add a new case to the switch statement and change ui stuff there

(SONG/STAGE SCRIPT ONLY) `flowBar` - an `FlxBar` that represents the `flow` variable

(SONG/STAGE SCRIPT ONLY) `flow` - a `Float` that is limited to 0 - 1

the ***higher*** this number is, the more health the player ***gains*** when hitting a note

the ***lower*** this number is, the more health the player ***loses*** when missing a note

(SONG/STAGE SCRIPT ONLY) `scoreTxtShadow` - a `FunkinText` that is exactly what it sounds like, there's pretty much no need to mess with this but it's public if you want it

(SONG/STAGE SCRIPT ONLY) `playerIcon` - a `FreeIcon` that replaces `iconP1`. **you should use this instead of `iconP1` if you're trying to grab the player icon!!!**

(SONG/STAGE SCRIPT ONLY) `opponentIcon` - a `FreeIcon` that replaces `iconP2`. **you should use this instead of `iconP2` if you're trying to grab the player icon!!!**

(SONG/STAGE SCRIPT ONLY) `playerIconShadow` & `opponentIconShadow` - exactly what they sound like

## lady variables
(SONG/STAGE SCRIPT ONLY) `ladySpeaker` - a `FunkinSprite` that shows the speaker. i do not know what i'm supposed to put here

(SONG/STAGE SCRIPT ONLY) `speakerLightSpr` - a `FunkinSprite` that just shows what the speaker's screen is showing

helpful for making the speaker's screen look bright in the dark

(SONG/STAGE SCRIPT ONLY) `speakerAuto` - a `Bool` that changes if the speaker's screen will automatically change colors or not

(SONG/STAGE SCRIPT ONLY) `speakerInterval` - an `Int` that changes how many beats the speaker's screen will wait before changing color

(SONG/STAGE SCRIPT ONLY) `speakerLight` - a `Bool` that changes if `speakerLightSpr` is visible or not

## global variables ([data/global.hx](../../data/global.hx))
i'm only going to go over variables here that aren't mentioned in other pages

`FlxColorHelper` - a variable that's just there to give easy access to the class

`initialized` - a `Bool`, used for taking you to the "Made In Codename" splash screen and the title screen

it's `false` by default but set to `true` after you load into the port

`fromGame` - a `Bool`, normally used for menus and such

it's `false` by default but will be `true` if you are playing a song

`currentEditor` - a `String`

debug menu stuff, you shouldn't need to worry about it

`gamepad` - an `FlxGamepad` variable that tracks the player's controller. it can and will probably be `null` at some points

`redirectStates` - a `Map<FlxState, String>` that helps the port automatically redirect you from the base game's main menu to the port's main menu for example

`flash(cam:FlxCamera, data:{color:FlxColor, time:Float, force:Bool}, onComplete:Void->Void)` - convenience function that checks the player's flashing lights option before flashing or not

`changeWindowIcon(name:String)` - changes the window icon

default window icon file path is at [images/window-icons/](images/window-icons/)

`convertTime(steps:Float, beats:Float, sections:Float):Float` - convenience function that will take the sum of the provided steps, beats, and sections all together and convert it to seconds

`gradientText(text:FlxText, colors:Array<FlxColor>)` - convenience function that will color `text` like a gradient, using the `colors` provided

`rainbow(amount:Int, s:Float, b:Float, a:Float):Array<FlxColor>` - convenience function (written by [Katie](https://github.com/RafGamign)) that returns an `Array<FlxColor>` of the rainbow limited to `amount`

`s` is saturation, `b` is brightness, and `a` is alpha

`getInnerData(xml:Xml)` - convenience function i stole from `haxe.xml.Access` because hscript HATES abstracts and wouldn't let me use it

if you have an xml node formatted like this:
```xml
<node>
	boobies
</node>
```
it'll let you grab the part that says "boobies"

`coolText(text:String):Array<String>` - convenience function that splits a `String` into an `Array<String>` via line breaks

the `Array<String>` will not include lines that start with #

`playMenuMusic()` - convenience function for menus, just plays the menu music if it's not already playing

`updateGamepadBinds(?binds:Map<String, String>)` - if you need documentation on this function you're probably already reading the code yourself. please tell me you are i don't wanna write the documentation for this please

`fullscreenSound` - an `FlxSound` that only plays if you try to fullscreen if you have the fullscreen easter egg enabled in your settings

`volumeCam` - an `FlxCamera` that's for the custom volume tray stuff

`volumeTray` - a `FunkinSprite` that's the background for `volumeBar`

`volumeBar` - an `FlxBar` that represents your game's master volume

`volumeGroup` an `FlxSpriteGroup` that holds `volumeTray` and `volumeBar`