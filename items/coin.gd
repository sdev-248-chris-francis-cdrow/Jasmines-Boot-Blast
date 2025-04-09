extends Area2D

@onready var player = get_node("/root/Main/Player")
@onready var hud = get_node("/root/Main/Hud")

var triggered = false
func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body is CharacterBody2D and body.is_in_group("player"):
		triggered = true
		hud.score += 1000
		hud.update_hud()
		$Sprite2D.hide()
		$AudioStreamPlayer.play()
		await get_tree().create_timer(3.0).timeout
		queue_free()
		triggered = false
