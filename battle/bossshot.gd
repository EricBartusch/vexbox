extends Node2D

var speed = 750
var lifetime = 5
var velocity = Vector2.RIGHT * speed

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
	get_parent().remove_dakka(self)
