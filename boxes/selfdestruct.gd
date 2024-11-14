extends Box

func on_other_box_opened() -> void:
    lg(nameText + " exploded!")
    main.destroy_box(self)