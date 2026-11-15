extends RigidBody2D

@export var launch_force = 1.0
@onready var launch_preview = $"Launch Preview"
@onready var mouse_preview = $"Mouse Preview"
@onready var spin_timer = $"Spin Timer"
@onready var target_raycasts = $"Target Raycasts"
@onready var left_target_raycast = $"Target Raycasts/Left Ray"
@onready var right_target_raycast = $"Target Raycasts/Right Ray"
@onready var dash_sprite = $"Dash Sprite"
@onready var dash_particles = $"Dash Particles"
var mouse_pos = Vector2(0, 0)
var is_dashing = false
var child_facing = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the nodes for the launch preview and mouse preview, which can be seen in the ball scene
	set_inertia(15.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get the position from the mouse (simple enough)
	mouse_pos = get_global_mouse_position()
	child_facing = position.angle_to_point(mouse_pos) - rotation
	launch_preview.set_point_position(1, (position - mouse_pos))
	mouse_preview.set_point_position(1, mouse_pos - position)
	target_raycasts.rotation = child_facing + (PI / 2)
	dash_particles.rotation = child_facing - (PI / 2)
	launch_preview.rotation = -rotation
	mouse_preview.rotation = -rotation

func _input(event):
	if event.is_action_pressed("click") and not is_dashing:
		# Launch the ball in a direction based off the mouse position and launch force
		var launch_strength = abs((position - mouse_pos).x) + abs((position - mouse_pos).y)
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
		if launch_strength >= 250:
			is_dashing = true
			dash_sprite.visible = true
			dash_particles.emitting = true
		spin_timer.start()

func _on_body_entered(body: Node2D):
	gravity_scale = 1.0
	if body is PhysicsBody2D and body.get_collision_layer_value(4):
		if is_dashing:
			body.queue_free()
		else:
			print("Dead")

func _on_spin_timeout() -> void:
	gravity_scale = 1.0
	is_dashing = false
	dash_sprite.visible = false
	dash_particles.emitting = false
