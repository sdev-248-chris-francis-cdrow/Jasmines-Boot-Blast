extends CanvasLayer

@onready var player = get_node("/root/Main/Player")
signal game_over_signal
signal won_signal
var score = 0
var lives = 3

func update_hud() -> void:
	if lives <= 0:
		game_over()
	var formatted_score = str(score).pad_zeros(6)
	$GameDisplay/Lives.text = (str(lives)+"x Lives")
	$GameDisplay/Score.text = (formatted_score)

func game_over() -> void:
	$LoadingLayer.visible = true
	await get_tree().create_timer(0.1).timeout
	$StartMenu.visible = false
	$GameDisplay.visible = false
	$Win.visible = false
	$GameOver.visible = true
	$LoadingLayer.visible = false
	game_over_signal.emit()
	
func win() -> void:
	$LoadingLayer.visible = true
	await get_tree().create_timer(0.1).timeout
	$StartMenu.visible = false
	$GameDisplay.visible = false
	$GameOver.visible = false
	$Win.visible = true
	$Win/Label.text = "Congratulations! You have defeated the Boot Witch and her evil army of Boot Goblins. With their reign of terror brought to an end, the world can finally rest in peace." + " Score: " +str(score) 
	$LoadingLayer.visible = false
	won_signal.emit()
