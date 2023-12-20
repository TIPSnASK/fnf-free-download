import funkin.backend.system.Logs;
import Xml;

class FreeCharacter extends funkin.backend.FunkinSprite {
	public var curCharacter:String = 'dude';
	public var xml:Xml;
	public var globalOffset = {
		x: 0,
		y: 0
	};

	public function new(x:Float, y:Float, character:String = 'dude', flip:Bool = false) {
		curCharacter = character;
		flipX = flip;

		loadSprite(Paths.image('characters/' + curCharacter));
		loadXml();
	}

	public function loadXml() {
		try {
			xml = Xml.parse(Assets.getText(Paths.xml('characters/' + curCharacter))).firstElement();
		} catch(e:Exception) {
			Logs.trace(curCharacter + '.xml: ' + e, 2);
			curCharacter = 'dude';
			xml = Xml.parse(Assets.getText(Paths.xml('characters/' + curCharacter))).firstElement();
		}

		for (anim in xml.elements()) {
			animation.addByPrefix(anim.get('name'), anim.get('anim'), Std.parseFloat(anim.get('fps')), anim.get('loop') == 'true');
			addOffset(anim.get('name'), Std.parseFloat(anim.get('x')), Std.parseFloat(anim.get('y')));
			if (['idle', 'danceLeft', 'danceRight'].contains(anim.get('name')))
				beatAnims.push(anim.get('name'));
		}

		globalOffset = {
			x: xml.exists('x') ? Std.parseFloat(xml.get('x')) : 0,
			y: xml.exists('y') ? Std.parseFloat(xml.get('y')) : 0
		}
		offset.set(globalOffset.x * (!flipX ? 1 : -1), -globalOffset.y);

		playAnim(beatAnims[0]);
	}

	public override function addOffset(name:String, offsetX:Float, offsetY:Float)
		animOffsets[name] = FlxPoint.get(offsetX, offsetY);
}