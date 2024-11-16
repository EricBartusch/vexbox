class_name AbsorbingBoxImitator
extends Control

var speed = 750
var lifetime = 3
var velocity = Vector2.RIGHT * speed
static var LIMIT = 5

func load(box):
	global_position = box.global_position
	$Sprite2D.texture = box.get_node("Sprite2D").texture
	$Sprite2D.modulate = box.get_node("Sprite2D").modulate
	$Outline.texture = box.get_node("Outline").texture

func _process(delta: float) -> void:
	position += velocity * delta
	lifetime -= delta
	if lifetime <= 0 or (position.x >= get_parent().protag.position.x - LIMIT and position.x <= get_parent().protag.position.x + LIMIT and position.y >= get_parent().protag.position.y - LIMIT and position.y <= get_parent().protag.position.y + LIMIT):
		get_parent().remove_child(self)
		self.queue_free()
