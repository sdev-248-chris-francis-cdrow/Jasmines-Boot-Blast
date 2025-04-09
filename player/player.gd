extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var hud = get_node("/root/Main/Hud")

signal life_changed
signal died


@export var gravity = 800
@export var run_speed = 400
@export var rainbow_speed = 500
@export var jump_speed = -650


enum {IDLE, RUN, JUMP, HURT, DEAD, WIN}
var state = IDLE
var last_floor = false
var jump_count = 1
var reset_life = 1
var life = 1
var last_going_right = true
var is_rainbow = false


func _ready():
	change_state(IDLE)
	set_life(life)

func reset(_position):
	position = _position
	show()
	change_state(IDLE)
	set_life(reset_life)
	is_rainbow = false
	
func hurt() -> void:
	if state != HURT:
		$HurtSound.play()
		change_state(HURT)

func die() -> void:
	if state != DEAD:
		change_state(DEAD)
		
func win() -> void:
	if state not in [HURT, DEAD, WIN]:
		change_state(WIN)

func rainbow() -> void:
	if state not in [HURT, DEAD]:
		is_rainbow = true
		if is_rainbow:
			$AnimatedSprite2D.play("rainbow")
			await get_tree().create_timer(15).timeout
			set_life(life)
func get_input() -> void:
	if state == HURT:
		return  # don't allow movement during hurt state
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	

	# movement occurs in all states
	velocity.x = 0
	if right:
		if is_rainbow:
			velocity.x += rainbow_speed
		else:
			velocity.x += run_speed
		$AnimatedSprite2D.flip_h = true
		last_going_right = true
	if left:
		if is_rainbow:
			velocity.x -= rainbow_speed
		else:
			velocity.x -= run_speed
		$AnimatedSprite2D.flip_h = false
		last_going_right = false
	
	# only allow jumping when on the ground
	if jump and is_on_floor():
		$JumpSound.play()
		change_state(JUMP)
		velocity.y = jump_speed
	# IDLE transitions to RUN when moving
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	# RUN transitions to IDLE when standing still
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	# transition to JUMP when in the air
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	
	
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			pass
		RUN:
			pass
		HURT:
			velocity.y = -200
			if last_going_right:
				velocity.x = -200
			else:
				velocity.x = 200
			set_life(life - 1)
			await get_tree().create_timer(0.5).timeout
			change_state(IDLE)
			if life <= 0:
				change_state(DEAD)
		JUMP:
			jump_count = 1
		DEAD:
			$CollisionShape2d.disabled = true
			died.emit()
			hide()
			await get_tree().create_timer(2).timeout
			reset(Vector2(398,1952))
			hud.lives -= 1
			hud.score = 0
			hud.update_hud()
			main.reload()
			$CollisionShape2d.disabled = false
		WIN:
			$CollisionShape2d.disabled = true
			hide()
			await get_tree().create_timer(2).timeout
			hud.update_hud()
			hud.win()
			$CollisionShape2d.disabled = false
			
			
func _physics_process(delta) -> void:	
	velocity.y += gravity * delta
	get_input()
	print(state)
	move_and_slide()
	if state == HURT:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collision.get_collider().is_in_group("danger"):
			hurt()
		if collision.get_collider().is_in_group("enemies"):
			var height_difference = collider.position.y - position.y
			if is_rainbow:
				collider.take_damage()
				continue
			else:
				if height_difference > 60:
					collider.take_damage()
					velocity.y = -200
				else:
					hurt()
	
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		jump_count = 0
	last_floor = is_on_floor()

func set_life(value):
	life = value
	if life == 1:
		$AnimatedSprite2D.play("default")
	elif life == 2:
		$AnimatedSprite2D.play("yellow")
	elif life == 3:
		$AnimatedSprite2D.play("blue")	
	life_changed.emit(life)
