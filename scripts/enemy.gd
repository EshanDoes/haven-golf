extends CharacterBody2D

@export var move_speed = 10.0

func _physics_process(delta: float) -> void:
	var collider = move_and_collide(($"../Ball".position - position).normalized() * move_speed)
