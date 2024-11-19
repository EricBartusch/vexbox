extends Box

var fNum: float = 0.3
var smileyScene = load("res://vfx/vfxFallingSmiley.tscn")

func on_open() -> void:
	fNum = 0.3

func _process(delta: float) -> void:
	super(delta)
	if !destroyed and open and main.gameRunning:
		fNum -= delta
		if fNum <= 0:
			fNum += 0.3
			var newSmiley = smileyScene.instantiate()
			get_parent().addVfx(newSmiley)
