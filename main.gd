extends Node2D

@export var level1: PackedScene
@export var player: PackedScene

var level_instance = null  # Declare the variable outside to maintain its reference

	

func load_level() -> void:
	# Create and add the new level instance
	level_instance = level1.instantiate()
	add_child(level_instance)

func reload() -> void:
	# Free the old level if it exists
	if level_instance != null:
		level_instance.queue_free()
	
	# Reload the new level instance
	load_level()
	


func _on_start_button_pressed() -> void:
	load_level()
	$Player.reset(Vector2(398,1952))
	$AudioStreamPlayer.play()


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()


func _on_hud_game_over_signal() -> void:
	$AudioStreamPlayer.stop()
	



func _on_hud_won_signal() -> void:
	$AudioStreamPlayer.stop()
