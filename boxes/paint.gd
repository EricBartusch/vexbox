extends Box

func on_open() -> void:
    var result = Color(main.rng.randf_range(0, 1), main.rng.randf_range(0, 1), main.rng.randf_range(0, 1), 1)
    main.get_node("ColorRect").color = result