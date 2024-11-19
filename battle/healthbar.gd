extends TextureProgressBar

func updateInfo(amount):
	value = amount
	$HealthText.text = str(value) + "/5000"
