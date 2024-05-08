var skin:CustomShader;
function postCreate() {
	shader = skin = new CustomShader("lady-colorswap");
	applyPlayerSkin(skin, 'lady');
}