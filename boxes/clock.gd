extends Box

var fNum: float = 1

func on_open() -> void:
	set_custom_num(20)
	fNum = 1

func _process(delta: float) -> void:
	super(delta)
	if !destroyed and open and main.gameRunning and customNum > 0:
		fNum -= delta
		if fNum <= 0:
			fNum += 1
			set_custom_num(customNum-1)
			if customNum == 0:
				lg("Time's up!")
				lose()
				if main.gameRunning:
					hide_custom_num()

func can_use():
	return customNum > 0

func on_self_clicked() -> void:
	fNum = 0
