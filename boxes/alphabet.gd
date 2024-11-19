extends Box

var letters = []
static var alphabet = "abcdefghijklmnopqrstuvwxyz"

func on_open():
	letters.clear()

func on_other_box_opened(box):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	for i in box.nameText.to_lower():
		if regex.search(i):
			letters.append(i)
	var will_win = true
	for letter in alphabet:
		if !letters.has(letter):
			will_win = false
	if will_win:
		lg("The Alphabox is complete!")
		win()

func addText():
	var result = " Letters left: "
	for letter in alphabet:
		if !letters.has(letter):
			result = result + letter
	return result
