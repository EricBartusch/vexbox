extends Control

var type
var value
var flval = 1
var justApplied = true
var stored

func setup(new_type, amount):
	type = new_type
	value = amount
	load_image()
	setupText()

func load_image():
	match (type):
		StatusTypes.GOLD:
			$Image.texture = load("res://statusImgs/money.png")
		StatusTypes.SAFETY:
			$Image.texture = load("res://statusImgs/safety.png")
		StatusTypes.DEMOLISH:
			$Image.texture = load("res://statusImgs/demolition.png")
		StatusTypes.CLOSENEXT:
			$Image.texture = load("res://statusImgs/closenext.png")
		StatusTypes.INVERSION:
			$Image.texture = load("res://statusImgs/inversion.png")
		StatusTypes.TRANSMOG:
			$Image.texture = load("res://statusImgs/transmog.png")
		StatusTypes.SWAP:
			$Image.texture = load("res://statusImgs/swap.png")

func setupText():
	match (type):
		StatusTypes.GOLD:
			$Description.text = "You have " + str(value) + " gold."
		StatusTypes.SAFETY:
			$Description.text = "Reveal the next " + str(value) + " unrevealed boxes you click instead of opening it."
		StatusTypes.DEMOLISH:
			$Description.text = "Destroy the next " + str(value) + " box you click."
		StatusTypes.CLOSENEXT:
			$Description.text = "Close the next " + str(value) + " open non-Tape box you click."
		StatusTypes.INVERSION:
			$Description.text = "Invert winning and losing! (Applies after other effects.)"
		StatusTypes.TRANSMOG:
			$Description.text = "The next " + str(value) + " times you click a revealed box, transform it into a random box."
		StatusTypes.SWAP:
			$Description.text = "The next " + str(value) + " times you click a box, swap it with the Portal Box."

func on_click():
	if !justApplied:
		pass
	else:
		justApplied = false

func changeValue(mod):
	value += mod
	if value == 0:
		get_parent().get_parent().remove_status(type)
	else:
		setupText()

func lg(text):
	get_parent().get_parent().logToLog($Image.texture, text, null)
