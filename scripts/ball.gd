extends RigidBody2D

# The launch force of the ball (I'd say edit this in the ball scene instead of in the code)
@export var launch_force = 1.0
# Get the nodes for the launch preview and mouse preview, which can be seen in the ball scene
@onready var launch_preview = $"Launch Preview"
@onready var mouse_preview = $"Mouse Preview"
var mouse_pos = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get the position from the mouse (simple enhough)
	mouse_pos = get_global_mouse_position()
	launch_preview.set_point_position(1, position - mouse_pos)
	mouse_preview.set_point_position(1, mouse_pos - position)

func _input(event):
	if event.is_action_pressed("click"):
		# Launch the ball in a direction based off the mouse position and launch force
		apply_central_impulse((position - mouse_pos) * launch_force)
