extends Area2D

@onready var player = get_node("/root/Main/Player")


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("player"):
		player.rainbow()
		print("player got rainbow")
