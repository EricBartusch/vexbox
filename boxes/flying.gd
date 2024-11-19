extends Box

var flyingBoxScene = preload("res://vfx/vfxFlyingBoxImitator.tscn")

func on_other_box_destroyed(box: Box) -> void:
	if open and !destroyed:
		modStat("timesActivated", 1)
		var replacement = flyingBoxScene.instantiate()
		replacement.loadFromBox(box)
		main.addVfx(replacement)
