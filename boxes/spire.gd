extends Box

func on_open() -> void:
    var willActivate = true
    for badge in main.get_node("BadgeList").get_children():
        if badge.enabled:
            willActivate = false
    if willActivate:
        for box in main.boxes: 
            if box.id == "empty" and !box.destroyed:
                box.loadType("winner")