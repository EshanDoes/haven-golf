extends CharacterBody2D

@export var move_speed = 10.0
@export var gravity = 1.0
@onready var turn_cooldown = $"Turn Cooldown"
var movement_direction = 1.0

func _physics_process(delta: float) -> void:
	move_and_slide()
	if abs($"../Ball".position - position) <= Vector2(2500, 2500):
		velocity.x = move_speed * movement_direction
	else:
		velocity.x = 0
	if not is_on_floor():
		velocity.y += gravity*delta
	else:
		velocity.y = 0.0
	
	if is_on_wall() and turn_cooldown.is_stopped():
		movement_direction *= -1
		turn_cooldown.start()
