// workaround stupid but works
import Xml;

class MenuData extends flixel.FlxBasic {
    public var data:Xml = null;
    public var parent:MenuData = null;

    public function new(xml:Xml) {data = xml;}
}