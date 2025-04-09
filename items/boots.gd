extends Area2D

@onready var player = get_node("/root/Main/Player")
var triggered = false


func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body is CharacterBody2D and body.is_in_group("player"):
		triggered = true
		print("player hit boot")
		if player.life == 1:
			player.set_life(2)
		elif player.life == 2:
			player.set_life(3)
		
		$Sprite2D.hide()
		$AudioStreamPlayer.play()
		await get_tree().create_timer(3.0).timeout
		queue_free()
		triggered = false
		
