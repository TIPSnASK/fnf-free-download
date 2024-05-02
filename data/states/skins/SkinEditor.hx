import Xml;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UIText;
import karaoke.game.FreeIcon;

var camZoom:Float = 1;
var camPos:{x:Float,y:Float} = {x: 85, y: 0};

var xml:Xml;
var char:FunkinSprite;
var icon:FunkinSprite;
var skin:CustomShader = new CustomShader('${editingSkinType}-colorswap');
var favColor:FlxColor = 0xFFFFFFFF;

var camUI:FlxCamera;
var topTiles:FlxBackdrop;
var bottomTiles:FlxBackdrop;

function create() {
	var bg:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image("menus/backgrounds/1"));
	// just accidentally remade the options menu background after i Gave up on the options menu im gonna fucking
	bg.setColorTransform(1.2, 0.8, 0.4, 1, 0, 0, 0, 0);
	bg.scale.set(1, 1);
	bg.zoomFactor = 0.25;
	bg.scrollFactor.set(0, 0.25);
	add(bg);

	char = new FunkinSprite().loadGraphic(Paths.image('editors/skins/portraits/${editingSkinType}'));
	char.screenCenter();
	char.shader = skin;
	char.scale.set(0.75, 0.75);
	add(char);

	icon = new FreeIcon('${editingSkinType}-default', true);
	icon.screenCenter();
	icon.x += 70;
	icon.shader = new CustomShader('player-icon');
	add(icon);

	icon.shader.favColor = FlxColorHelper.vec4(favColor = applySkin(skin, editingSkinType, "statue"));
}

function postCreate() {
	camUI = new FlxCamera();
	camUI.bgColor = 0;
	FlxG.cameras.add(camUI, false);

	topTiles = new FlxBackdrop(Paths.image("menus/cool_tile_pattern_bro"), FlxAxes.X);
	topTiles.cameras = [camUI];
	topTiles.scale.set(0.8, 1);
	topTiles.updateHitbox();
	topTiles.velocity.x = 75;
	add(topTiles);

	bottomTiles = new FlxBackdrop(Paths.image("menus/cool_tile_pattern_bro"), FlxAxes.X);
	bottomTiles.cameras = [camUI];
	bottomTiles.scale.set(0.8, 1);
	bottomTiles.updateHitbox();
	bottomTiles.velocity.x = -75;
	bottomTiles.y = FlxG.height-bottomTiles.height;
	bottomTiles.flipY = true;
	add(bottomTiles);
}

var timer:Float = 0.0;
function update(e:Float) {
	timer += e;
	if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(new ModState("MainMenu"));
	if (FlxG.keys.justPressed.EIGHT) FlxG.switchState(new UIState(true, 'skins/SkinEditor'));

	icon.y = 115 + (Math.sin(timer * 7) + 1) * 2; // tank you wizard 🙏

	FlxG.camera.zoom = lerp(FlxG.camera.zoom, camZoom, 0.12);
	FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, camPos.x, 0.12); FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, camPos.y, 0.12);
}