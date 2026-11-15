extends RigidBody2D

# The launch force of the ball (I'd say edit this in the ball scene instead of in the code)
@export var launch_force = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func _input(event):
	if event.is_action_pressed("click"):
		# Get the position from the mouse (simple enhough)
		var mouse_pos = get_global_mouse_position()
		# Launch the ball in a direction based off the mouse position and launch force
		apply_central_impulse((position - mouse_pos) * launch_force)
