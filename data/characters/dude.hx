var skin:CustomShader;
function postCreate() {
	shader = skin = new CustomShader("dude-colorswap");
	applyPlayerSkin(skin, 'dude');
}