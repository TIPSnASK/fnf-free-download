import flixel.addons.display.FlxBackdrop;

public var busSpeed:Float = 1; // there is literally no reason for this i just think its fun

var sky:FunkinSprite;
var backbustrees:FlxBackdrop;
var backbus:FlxBackdrop;

function create() {
	backbus = new FlxBackdrop().loadGraphic(Paths.image('game/stages/bus/backbus'));
	backbus.repeatAxes = 0x01;
	backbus.y = 90;
	insert(0, backbus);
	backbus.velocity.x = -75*busSpeed;

	backbustrees = new FlxBackdrop().loadGraphic(Paths.image('game/stages/bus/backbustrees'));
	backbustrees.repeatAxes = 0x01;
	backbustrees.y = 82;
	insert(0, backbustrees);
	backbustrees.velocity.x = (backbus.velocity.x*0.25)*busSpeed;

	insert(0, sky = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFC0C0C0));
	sky.scrollFactor.set();
	sky.zoomFactor = 0;
}

function postCreate() {
	camera.pos[0].x += 93;
	camera.pos[1].x -= 64;
	camera.pos[1].y += 5;
	// camera.pos[]
}