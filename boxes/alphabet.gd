extends Box

var letters = []

func on_open():
	letters.clear()

func on_other_box_opened(box):
	for i in box.nameText:
		letters.append(i)
	print(letters)
