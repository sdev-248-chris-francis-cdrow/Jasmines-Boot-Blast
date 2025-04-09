extends Button



func _on_pressed() -> void:
	$"../../LoadingLayer".visible = true
	await get_tree().create_timer(0.5).timeout
	$"..".visible = false
	$"../../GameOver".visible = false
	$"../../GameDisplay".visible = true
	$"../../LoadingLayer".visible = false
