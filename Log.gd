extends ScrollContainer

var itemAdded = false

func _process(delta):
	if itemAdded:
		itemAdded = false
		scroll_vertical = get_v_scroll_bar().max_value
