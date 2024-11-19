extends Box

func on_open() -> void:
	for box in main.boxes:
		if !box.open and !box.destroyed and !box.revealed:
			box.get_node("Sprite2D").modulate = Color(main.rng.randf_range(0, 1), main.rng.randf_range(0, 1), main.rng.randf_range(0, 1), 1)
