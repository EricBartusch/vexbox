extends Box

var fNum: float = 1

func on_open() -> void:
    set_custom_num(20)
    fNum = 1

func _process(delta: float) -> void:
    super(delta)
    if !destroyed and open and main.gameRunning:
        fNum -= delta
        if fNum <= 0:
            fNum += 1
            set_custom_num(customNum-1)
            if customNum == 0:
                lg("Time's up!")
                main.lose()