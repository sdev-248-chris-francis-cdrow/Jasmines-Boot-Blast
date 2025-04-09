extends StaticBody2D


@onready var player = get_node("/root/Main/Player")
# Load the scene you want to instantiate
@export var boots_blue: PackedScene
@export var boots_yellow: PackedScene
@export var boots_rainbow: PackedScene
@export var coin: PackedScene
@export var shoe_glue: PackedScene
@export var spawn_offset: Vector2 = Vector2(0,-64)
@export var item = "coin"
func _on_hurtbox_body_entered(body: Node2D) -> void:
	var plife = player.life
	if body is CharacterBody2D and $AnimatedSprite2D.animation == "default":
		$AnimatedSprite2D.play("active")
		if item == "boot":
			if plife == 1 and boots_yellow:
				call_deferred("spawn_item", boots_yellow)

			elif plife == 2 and boots_blue:
				call_deferred("spawn_item", boots_blue)

			elif plife == 3:
				call_deferred("spawn_item", coin)
		elif item == "shoe_glue":
			call_deferred("spawn_item", shoe_glue)
		elif item == "boots_rainbow":
			call_deferred("spawn_item", boots_rainbow)
		else:
			call_deferred("spawn_item", coin)
func spawn_item(item_scene: PackedScene) -> void:
	var item_instance = item_scene.instantiate()
	add_child(item_instance)
	item_instance.position = spawn_offset
