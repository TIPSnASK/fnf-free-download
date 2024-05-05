import Xml;
import karaoke.menus.MenuData;

class MenuOption extends funkin.backend.FunkinText {
	public var data:Xml = null;
	public var parent:MenuData = null;
	public var value:Dynamic = null;
	public var extra:Map<String, Dynamic> = [];
	public var optionParent:Dynamic = null;
	public function new(xPos:Float = 0, yPos:Float = 0, fwidth:Float = 0, ?txt:String, sizeVal:Int = 16, bord:Bool = true, xml:Xml, _optionParent:Dynamic, _value:Dynamic) {
		data = xml;
		value = _value;
	}
}