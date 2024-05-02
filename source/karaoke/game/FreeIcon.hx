// shut up vsc

class FreeIcon extends funkin.backend.FunkinSprite {
	public var healthSteps:Map<Int, Int> = [
		20 => 0, // normal icon
	];

	public var debug:Bool = false;

	public function new(char:String = "dude", debug:Bool = false) {
		super();
		this.debug = debug;
		if (!debug) health = 0.5;
		var path = Paths.image("game/icons/" + char);
		if (!Assets.exists(path)) path = Paths.image("game/icons/dude");

		loadGraphic(path, 64, 64);

		animation.add(char, [for(i in 0...frames.frames.length) i], 0, false, false);
		antialiasing = false;
		playAnim(char);

		if (frames.frames.length >= 2)
			healthSteps[0] = 1; // losing icon
		if (frames.frames.length >= 3)
			healthSteps[80] = 2; // winning icon

		if (!debug) scrollFactor.set();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (animation.curAnim != null && !debug) {
			var i:Int = -1;
			var oldKey:Int = -1;
			for(k=>icon in healthSteps) {
				if (k > oldKey && k < health * 100) {
					oldKey = k;
					i = icon;
				}
			}
			if (i >= 0) animation.curAnim.curFrame = i;
		}
	}
}