extends Control

var type
var value
var flval = 1
var justApplied = false

func setup(new_type, amount):
	type = new_type
	value = amount
	load_image()
	setupText()
	if type != StatusTypes.ECLIPSE:
		justApplied = true
	else:
		justApplied = false

func load_image():
	match (type):
		StatusTypes.POISON:
			$Image.texture = load("res://statusImgs/poison.png")
		StatusTypes.GOLD:
			$Image.texture = load("res://statusImgs/money.png")
		StatusTypes.SAFETY:
			$Image.texture = load("res://statusImgs/safety.png")
		StatusTypes.CURSE:
			$Image.texture = load("res://statusImgs/curse.png")
		StatusTypes.HEART:
			$Image.texture = load("res://statusImgs/heart.png")
		StatusTypes.DEMOLISH:
			$Image.texture = load("res://statusImgs/demolition.png")
		StatusTypes.CLOSENEXT:
			$Image.texture = load("res://statusImgs/closenext.png")
		StatusTypes.ECLIPSE:
			$Image.texture = load("res://statusImgs/eclipse.png")
		StatusTypes.INVERSION:
			$Image.texture = load("res://statusImgs/inversion.png")
		StatusTypes.KEY:
			$Image.texture = load("res://statusImgs/key.png")
		StatusTypes.TERRITORY:
			$Image.texture = load("res://statusImgs/territory.png")
		StatusTypes.TRANSMOG:
			$Image.texture = load("res://statusImgs/transmog.png")

func setupText():
	match (type):
		StatusTypes.POISON:
			$Description.text = "You are poisoned and will lose in " + str(value) + " opens."
		StatusTypes.GOLD:
			$Description.text = "You have " + str(value) + " gold."
		StatusTypes.SAFETY:
			$Description.text = "Reveal the next " + str(value) + " unrevealed boxes you click instead of opening it."
		StatusTypes.CURSE:
			$Description.text = "You're cursed, preventing the next " + str(value) + " times you win."
		StatusTypes.HEART:
			$Description.text = "You can't lose for " + str(value) + " opens!"
		StatusTypes.DEMOLISH:
			$Description.text = "Destroy the next " + str(value) + " box you click."
		StatusTypes.CLOSENEXT:
			$Description.text = "Close the next " + str(value) + " open non-Tape box you click."
		StatusTypes.ECLIPSE:
			$Description.text = "In " + str(value) + " opens, close all boxes."
		StatusTypes.INVERSION:
			$Description.text = "Invert winning and losing! (Applies after other effects.)"
		StatusTypes.KEY:
			$Description.text = "If the next " + str(value) + " box you open is a Lock Box, win."
		StatusTypes.TERRITORY:
			$Description.text = "For the next " + str(value) + " opens, you can only open boxes adjacent to an open box."
		StatusTypes.TRANSMOG:
			$Description.text = "The next " + str(value) + " times you click a revealed box, transform it into a random box."

func on_click():
	if !justApplied:
		match (type):
			StatusTypes.POISON:
				if value == 1:
					lg("Your Poison has become lethal!")
					get_parent().get_parent().lose()
				changeValue(-1)
			StatusTypes.HEART:
				changeValue(-1)
			StatusTypes.ECLIPSE:
				if value == 1:
					lg("Eclipse closes all boxes!")
					for box in get_parent().get_parent().boxes:
						if box.open:
							box.closeBox()
				changeValue(-1)
			StatusTypes.KEY:
				changeValue(-1)
			StatusTypes.TERRITORY:
				changeValue(-1)
	else:
		justApplied = false

func changeValue(mod):
	value += mod
	if value == 0:
		get_parent().get_parent().remove_status(type)
	else:
		setupText()

func lg(text):
	get_parent().get_parent().logToLog($Image.texture, text)
