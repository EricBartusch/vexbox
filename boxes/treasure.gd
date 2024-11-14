extends Box

func on_open() -> void:
    var willWin = false
    var seen = []
    var stack = []
    stack.push_front(self)
    while stack.size() > 0:
        var cur = stack.pop_front()
        if !seen.has(cur):
            seen.append(cur)
            for box in cur.get_adjacent_boxes(false, false):
                if !box.destroyed and box.open:
                    if box.id == "map":
                        willWin = true
                        break
                    else:
                        stack.push_front(box)
    if willWin:
        main.win()