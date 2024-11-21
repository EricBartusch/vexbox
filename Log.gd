extends ScrollContainer

var itemAdded = false
var secondItemAdded = false

func _process(delta):
	if itemAdded:
		itemAdded = false
		secondItemAdded = true
		scroll_vertical = get_v_scroll_bar().max_value
	elif secondItemAdded:
		secondItemAdded = false
		scroll_vertical = get_v_scroll_bar().max_value
