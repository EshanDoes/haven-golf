extends RigidBody2D

# The launch force of the ball (I'd say edit this in the ball scene instead of in the code)
@export var launch_force = 1.0
# Other variables
var launch_preview
var mouse_preview
var mouse_pos = Vector2(0, 0)
var is_on_screen = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the nodes for the launch preview and mouse preview, which can be seen in the ball scene
	launch_preview = $"Launch Preview"
	mouse_preview = $"Mouse Preview"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get the position from the mouse (simple enhough)
	mouse_pos = get_global_mouse_position()
	launch_preview.set_point_position(1, (position - mouse_pos) * 1.25)
	mouse_preview.set_point_position(1, mouse_pos - position)
	launch_preview.rotation = -rotation
	mouse_preview.rotation = -rotation

func _input(event):
	if event.is_action_pressed("click") and is_on_screen:
		# Launch the ball in a direction based off the mouse position and launch force
		apply_central_impulse((position - mouse_pos) * launch_force * Vector2(1, 1.5))


func _on_2d_screen_entered() -> void:
	mouse_preview.visible = true
	is_on_screen = true


func _on_2d_screen_exited() -> void:
	mouse_preview.visible = false
	is_on_screen = false
