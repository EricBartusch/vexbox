extends Control

var vX
var vY

func _ready() -> void:
	vX = get_parent().rng.randf_range(-10, 10)
	vY = get_parent().rng.randf_range(-20, -6)

func loadFromBox(box):
	global_position = box.global_position
	$Sprite2D.texture = box.get_node("Sprite2D").texture
	$Outline.texture = box.get_node("Outline").texture

func _process(delta: float) -> void:
	global_position.x += vX * delta * 30
	global_position.y += vY * delta * 30
	vY += delta * 25
	if global_position.y > DisplayServer.window_get_size().y or global_position.x < 0 or global_position.x > DisplayServer.window_get_size().x:
		get_parent().removeVfx(self)
		queue_free()
