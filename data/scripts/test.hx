function create() {
	new FlxTimer().start(1, () -> {
		close();
	});
}