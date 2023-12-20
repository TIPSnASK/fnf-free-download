function create() {
	transitionTween.cancel();

	remove(blackSpr);
	remove(transitionSprite);

	transitionCamera.fade(0xFF000000, 0.25, newState == null, () -> {finish();}, true);
}