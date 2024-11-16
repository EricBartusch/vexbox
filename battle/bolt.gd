extends Node2D

var speed = 800
var lifetime = 5
var velocity = Vector2.DOWN * speed

func _ready() -> void:
	global_position.x = get_parent().rng.randi_range(0, 1500)

func _process(delta):
	position += velocity * delta
	lifetime -= delta
	if lifetime <= 0:
		get_parent().remove_child(self)
		self.queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Protag and (area.get_parent() as Protag).iframes <= 0:
		touch_protag(area)

func touch_protag(area):
	area.get_parent().get_parent().hurtPlayer()
	get_parent().remove_child(self)
	queue_free()
