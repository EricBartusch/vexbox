extends TextureRect

var vX
var vY

func _ready() -> void:
	global_position.x = get_parent().rng.randi_range(20, 1900)
	global_position.y = get_parent().rng.randi_range(-100, -50)
	vX = get_parent().rng.randf_range(-8, 8)
	vY = get_parent().rng.randf_range(20, 50)

func _process(delta: float) -> void:
	global_position.x += vX * delta * 15
	global_position.y += vY * delta * 15
	vY += delta * 2
	if global_position.y > DisplayServer.window_get_size().y:
		get_parent().removeVfx(self)
		queue_free()
