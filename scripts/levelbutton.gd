extends BaseButton

@export_file_path("*.tscn") var scene = "res://scenes/levels/1.tscn"

func _on_button_up():
	get_tree().change_scene_to_file(scene)
