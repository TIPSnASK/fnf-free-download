## [karaoke.backend.util.FlxColorHelper](../source/karaoke/backend/util/FlxColorHelper.hx)
convenience class pretty much only here because hscript is allergic to abstracts
<br><br>
like all of this is ripped from [`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)

### RGB
`red(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Int` - returns the red value of a color, limited to 0 - 255
<br><br>
`green(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Int` - returns the green value of a color, limited to 0 - 255
<br><br>
`blue(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Int` - returns the blue value of a color, limited to 0 - 255
<br><br>
`alpha(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Int` - returns the alpha value of a color, limited to 0 - 255


---
`redFloat(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the red value of a color as a float, limited to 0 - 1
<br><br>
`greenFloat(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the green value of a color as a float, limited to 0 - 1

`blueFloat(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the blue value of a color as a float, limited to 0 - 1
<br><br>
`alphaFloat(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the alpha value of a color as a float, limited to 0 - 1

---
`rgb(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html) - i have no clue what this one does

### HSB
`hue(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the hue of a color (in degrees) as a float, limited to 0 - 359
<br><br>
`saturation(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the saturation of a color as a float, limited to 0 - 1
<br><br>
`brightness(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the brightness of a color as a float, limited to 0 - 1

### lightness
`lightness(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the lightness of a color as a float, limited to 0 - 1

### CMYK
`cyan(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the cyan value of a color as a float, i don't know what it's limited to and will check later
<br><br>
`magenta(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the magenta value of a color as a float, i don't know what it's limited to and will check later
<br><br>
`yellow(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the yellow value of a color as a float, i don't know what it's limited to and will check later
<br><br>
`black(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Float` - returns the black value of a color as a float, i don't know what it's limited to and will check later

### the rest

`toHexString(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`, a:Bool = true, p:Bool = true):String` - returns `color` as a hex string
<br><br>
`a` is if it will include the color's alpha or not
<br><br>
`p` is if it will include the `0x` prefix or not
<br><br>
`vec3(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Array<Float>` - convenience function for help with shaders, returns an `Array<Float>` with the `color`'s `redFloat`, `greenFloat` and `blueFloat` values
<br><br>
`vec4(color:`[`FlxColor`](https://api.haxeflixel.com/flixel/util/FlxColor.html)`):Array<Float>` - convenience function for help with shaders, it's the same as the `vec3` function but with the `color`'s `alphaFloat` value included

## [karaoke.editors.IconButton](../source/karaoke/editors/IconButton.hx)
a convenience class that just returns an [`FlxSpriteGroup`](https://api.haxeflixel.com/flixel/group/FlxSpriteGroup.html) because i felt like it

---
`create(x:Float, y:Float, sheet:String, ico:String, callback:Void->Void, w:Int = 32, h:Int = 32)` - the only function in this class
<br><br>
`sheet` should be the path to a spritesheet/image file
<br><br>
`ico` should be the name of the icon to use if it's a spritesheet
<br><br>
`callback` should be the function to call if the button is clicked
<br><br>
`w` is the width of the button
<br><br>
`h` is the height of the button

## [karaoke.game.FreeIcon](../source/karaoke/game/FreeIcon.hx)
convenience class that is literally just [`HealthIcon`](https://fnf-cne-devs.github.io/docs/funkin/game/HealthIcon.html) but slightly modified

## [karaoke.menus.MenuData](../source/karaoke/menus/MenuData.hx)
workaround class used for the options menu, it just holds information and stuff pretty much
<br><br>
`data` - an [`Xml`](https://api.haxeflixel.com/Xml.html) that holds the menu data
<br><br>
`parent` - another [`MenuData`](#karaokemenusmenudata) instance that this instance is the child to
<br><br>
is only null if it is the first menu

---
`new(xml:`[`Xml`](https://api.haxeflixel.com/Xml.html)`)` - the constructor for the class, literally all it does is just set `data` to `xml`

## [karaoke.menus.MenuOption](../source/karaoke/menus/MenuOption.hx)
workaround class used for the options menu, it extends [`FunkinText`](https://fnf-cne-devs.github.io/docs/funkin/backend/FunkinText.html) and also just holds information and stuff pretty 
<br><br>
`data` - an [`Xml`](https://api.haxeflixel.com/Xml.html) that holds the option node
<br><br>
`parent` - the [`MenuData`](#karaokemenusmenudata) instance that this option is the child to

will never be `null` unless something is wrong
<br><br>
`value` - a `Dynamic` that is `null` by default, normally used to hold the option's current value
<br><br>
`extra` - a `Map<String, Dynamic>` that's just for holding extra stuff
<br><br>
`optionParent` - a `Dynamic` that is also null by default
<br><br>
should be set to either [`Options`](https://fnf-cne-devs.github.io/docs/funkin/options/Options.html) or [`FlxG.save.data`](https://api.haxeflixel.com/flixel/util/FlxSave.html#data)

---
`new(xPos:Float = 0, yPos:Float = 0, fwidth:Float = 0, ?txt:String, sizeVal:Int = 16, bord:Bool = true, xml:Xml, _optionParent:Dynamic, _value:Dynamic)` - the constructor for the class, pretty much the exact same as [`FunkinText`](https://fnf-cne-devs.github.io/docs/funkin/backend/FunkinText.html) but with some extra stuff at the end
<br><br>
`xml` just sets `data` to it
<br><br>
`_optionParent` just sets `optionParent` to it
<br><br>
`_value` just sets `value` to it