## [karaoke.backend.util.FlxColorHelper](../source/karaoke/backend/util/FlxColorHelper.hx)
convenience class pretty much only here because hscript is allergic to abstracts

like all of this is ripped from `FlxColor` 

### RGB
`red(color:FlxColor):Int` - returns the red value of a color, limited to 0 - 255

`green(color:FlxColor):Int` - returns the green value of a color, limited to 0 - 255

`blue(color:FlxColor):Int` - returns the blue value of a color, limited to 0 - 255

`alpha(color:FlxColor):Int` - returns the alpha value of a color, limited to 0 - 255


---
`redFloat(color:FlxColor):Float` - returns the red value of a color as a float, limited to 0 - 1

`greenFloat(color:FlxColor):Float` - returns the green value of a color as a float, limited to 0 - 1

`blueFloat(color:FlxColor):Float` - returns the blue value of a color as a float, limited to 0 - 1

`alphaFloat(color:FlxColor):Float` - returns the alpha value of a color as a float, limited to 0 - 1

---
`rgb(color:FlxColor):FlxColor` - i have no clue what this one does

### HSB
`hue(color:FlxColor):Float` - returns the hue of a color (in degrees) as a float, limited to 0 - 359

`saturation(color:FlxColor):Float` - returns the saturation of a color as a float, limited to 0 - 1

`brightness(color:FlxColor):Float` - returns the brightness of a color as a float, limited to 0 - 1

### lightness
`lightness(color:FlxColor):Float` - returns the lightness of a color as a float, limited to 0 - 1

### CMYK
`cyan(color:FlxColor):Float` - returns the cyan value of a color as a float, i don't know what it's limited to and will check later

`magenta(color:FlxColor):Float` - returns the magenta value of a color as a float, i don't know what it's limited to and will check later

`yellow(color:FlxColor):Float` - returns the yellow value of a color as a float, i don't know what it's limited to and will check later

`black(color:FlxColor):Float` - returns the black value of a color as a float, i don't know what it's limited to and will check later

### the rest

`toHexString(color:FlxColor, a:Bool = true, p:Bool = true):String` - returns `color` as a hex string

`a` is if it will include the color's alpha or not

`p` is if it will include the `0x` prefix or not

`vec3(color:FlxColor):Array<Float>` - convenience function for help with shaders, returns an `Array<Float>` with the `color`'s `redFloat`, `greenFloat` and `blueFloat` values

`vec4(color:FlxColor):Array<Float>` - convenience function for help with shaders, it's the same as the `vec3` function but with the `color`'s `alphaFloat` value included

## [karaoke.editors.IconButton](../source/karaoke/editors/IconButton.hx)
a convenience class that just returns an `FlxSpriteGroup` because i felt like it

---
`create(x:Float, y:Float, sheet:String, ico:String, callback:Void->Void, w:Int = 32, h:Int = 32)` - the only function in this class

`sheet` should be the path to a spritesheet/image file

`ico` should be the name of the icon to use if it's a spritesheet

`callback` should be the function to call if the button is clicked

`w` is the width of the button

`h` is the height of the button

## [karaoke.game.FreeIcon](../source/karaoke/game/FreeIcon.hx)
convenience class that is literally just `HealthIcon` but for the low resolution this port uses

## [karaoke.menus.MenuData](../source/karaoke/menus/MenuData.hx)
workaround class used for the options menu, it just holds information and stuff pretty much

`data` - an `Xml` that holds the menu data

`parent` - another `MenuData` instance that this instance is the child to

is only null if it is the first menu

---
`new(xml:Xml)` - the constructor for the class, literally all it does is just set `data` to `xml`

## [karaoke.menus.MenuOption](../source/karaoke/menus/MenuOption.hx)
workaround class used for the options menu, it extends `FunkinText` and also just holds information and stuff pretty 

`data` - an `Xml` that holds the option node

`parent` - the `MenuData` instance that this option is the child to

will never be null unless something is wrong

`value` - a `Dynamic` that is `null` by default, normally used to hold the option's current value

`extra` - a `Map<String, Dynamic>` that's just for holding extra stuff

`optionParent` - a `Dynamic` that is also null by default

should be set to either `Options` or `FlxG.save.data`

---
`new(xPos:Float = 0, yPos:Float = 0, fwidth:Float = 0, ?txt:String, sizeVal:Int = 16, bord:Bool = true, xml:Xml, _optionParent:Dynamic, _value:Dynamic)` - the constructor for the class, pretty much the exact same as `FunkinText` but with some extra stuff at the end

`xml` just sets `data` to it

`_optionParent` just sets `optionParent` to it

`_value` just sets `value` to it