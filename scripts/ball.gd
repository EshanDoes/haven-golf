extends RigidBody2D

@export var launch_force = 1.0
@export var launch_affecting_club = 1.0
@onready var launch_preview = $"Launch Preview"
@onready var mouse_preview = $"Mouse Preview"
@onready var spin_timer = $"Spin Timer"
@onready var target_raycasts = $"Target Raycasts"
@onready var left_target_raycast = $"Target Raycasts/Left Ray"
@onready var right_target_raycast = $"Target Raycasts/Right Ray"
@onready var dash_sprite = $"Dash Sprite"
@onready var dash_particles = $"Dash Particles"
@onready var score_text = $UI/Score
@onready var win_text = $UI/Win
@onready var animations = $Animations
@onready var club = $Club
var started = false
var mouse_pos = Vector2(0, 0)
var launch_strength
var is_dashing = false
var child_facing = 0.0
var score = 0.0
var win = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the nodes for the launch preview and mouse preview, which can be seen in the ball scene
	set_inertia(15.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	mouse_pos = get_global_mouse_position()
	child_facing = position.angle_to_point(mouse_pos) - rotation
	launch_strength = abs((position - mouse_pos).x) + abs((position - mouse_pos).y)
	launch_preview.set_point_position(1, (position - mouse_pos))
	mouse_preview.set_point_position(1, mouse_pos - position)
	target_raycasts.rotation = child_facing + (PI / 2)
	dash_particles.rotation = child_facing - (PI / 2)
	launch_preview.rotation = -rotation
	mouse_preview.rotation = -rotation
	club.rotation = child_facing - (PI / 2)
	club.get_node("Sprite").rotation_degrees = -15 + (45 + launch_strength / launch_affecting_club) * (1 - spin_timer.time_left * 2)
	if score != 0 and !win:
		score += delta
		score_text.text = "Score: " + str(round(score*100)/100)

func _input(event):
	if event.is_action_pressed("click") and !is_dashing and !win:
		if left_target_raycast.get_collider() != null:
			set_linear_velocity((left_target_raycast.get_collider().position - position).normalized() * launch_force * launch_strength)
			print(left_target_raycast.get_collider().position.normalized())
		elif right_target_raycast.get_collider() != null:
			set_linear_velocity((right_target_raycast.get_collider().position - position).normalized() * launch_force * launch_strength)
			print(right_target_raycast.get_collider().position.normalized())
		else:
			set_linear_velocity((position - mouse_pos) * launch_force)
		print(linear_velocity, launch_strength)
		apply_torque_impulse(launch_strength)
		gravity_scale = 0.0
		started = true
		if score == 0:
			score = 0.01
		if launch_strength >= 250:
			is_dashing = true
			dash_sprite.visible = true
			dash_particles.emitting = true
		spin_timer.start()

func _on_body_entered(body: Node2D):
	gravity_scale = 1.0
	if body is PhysicsBody2D:
		if body.get_collision_layer_value(4):
			if is_dashing:
				animations.play("green")
				body.queue_free()
				score -= 5
			else:
				animations.play("red")
				score += 2
		elif body.get_collision_layer_value(5):
			win = true
			score_text.visible = false
			win_text.text = "You win!\nFinal score: "+str(round(score*100)/100)
			win_text.visible = true

func _on_spin_timeout() -> void:
	gravity_scale = 1.0
	is_dashing = false
	dash_sprite.visible = false
	dash_particles.emitting = false
