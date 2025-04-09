extends Button



func _on_pressed() -> void:
	$"../../LoadingLayer".visible = true
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://main.tscn")
