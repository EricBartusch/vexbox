extends Box

func on_other_box_opened() -> void:
    lg(nameText + " exploded!")
    for box in get_adjacent_boxes(false, false):
        main.destroy_box(box)
    main.destroy_box(self)