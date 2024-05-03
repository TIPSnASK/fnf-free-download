// i feel like it sorry!!
import funkin.editors.ui.UIButton;
import flixel.group.FlxSpriteGroup;

// basically a convenience class that just returns an FlxSpriteGroup
class IconButton extends flixel.FlxBasic {
	public function new() {}

	public var _group:FlxSpriteGroup;
	public var button:UIButton; // yeah
	public var iconSpr:FunkinSprite; // yeah
	public function create(x:Float, y:Float, sheet:String, ico:String, callback:Void->Void, w:Int = 32, h:Int = 32) {
		_group = new FlxSpriteGroup(x, y);

		button = new UIButton(0, 0, '', callback, w, h);
		iconSpr = new FunkinSprite();
		iconSpr.frames = Paths.getSparrowAtlas(sheet);
		iconSpr.animation.addByPrefix(ico, ico, 0, true);
		iconSpr.playAnim(ico);
		iconSpr.scale.set(0.5, 0.5); iconSpr.updateHitbox();
		_group.add(button);
		_group.add(iconSpr);

		return _group;
	}
}