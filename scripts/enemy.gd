extends CharacterBody2D

@export var move_speed = 10.0
@export var distance_until_visible = 2500
@export var eye_distance = 10.0
@onready var eyes = $Sprite/Eyes

func _ready():
	pass

func _physics_process(delta: float) -> void:
	var movement_coordinates = Vector2(0, 0)
	if abs($"../Ball".position - position) <= Vector2(distance_until_visible, 1000):
		movement_coordinates = $"../Ball".position - position
	eyes.position = movement_coordinates.normalized() * eye_distance
	var collider = move_and_collide(movement_coordinates.normalized() * move_speed)
