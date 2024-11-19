class_name Bullet
extends Node2D

var speed = 1500
var lifetime = 5
var velocity = Vector2.RIGHT * speed

func _process(delta):
	position += velocity * delta
	lifetime -= delta
	if lifetime <= 0:
		get_parent().remove_child(self)
		self.queue_free()
