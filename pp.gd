extends CharacterBody2D

const SPEED = 150.0
@onready var pull_area = $PullArea
@onready var push_area = $PushArea
@onready var lock_area = $LockArea
@onready var animated_sprite_2d = $AnimatedSprite2D


var current_direction: Vector2
var idle_direction: String = "down"
var flute_input: Array = []


func _physics_process(delta):
	
	# Movement
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED
	
	move_and_slide()

	# Flute logic
	var flute_pull = Input.is_action_pressed("Flute In")
	var flute_push = Input.is_action_pressed("Flute Out")
	var flute_lock = Input.is_action_pressed("Flute Lock")
	var playing_flute = flute_pull or flute_push or flute_lock
	
	if Input.is_action_just_pressed("Flute In"):
		flute_input.append("pull")
	if Input.is_action_just_released("Flute In"):
		var index = flute_input.find("pull")
		if index != -1:
			flute_input.remove_at(index)
	if Input.is_action_just_pressed("Flute Out"):
		flute_input.append("push")
	if Input.is_action_just_released("Flute Out"):
		var index = flute_input.find("push")
		if index != -1:
			flute_input.remove_at(index)
	if Input.is_action_just_pressed("Flute Lock"):
		flute_input.append("lock")
	if Input.is_action_just_released("Flute Lock"):
		var index = flute_input.find("lock")
		if index != -1:
			flute_input.remove_at(index)

	var flute_song = null
	if flute_input.size():
		flute_song = flute_input.back()
	if flute_song == "pull":
		$PullArea/CollisionShape2D.disabled = false
	else:
		$PullArea/CollisionShape2D.disabled = true
	if flute_song == "push":
		$PushArea/CollisionShape2D.disabled = false
	else:
		$PushArea/CollisionShape2D.disabled = true
	if flute_song == "lock":
		$LockArea/CollisionShape2D.disabled = false
	else:
		$LockArea/CollisionShape2D.disabled = true
	
	# Animations
	if playing_flute:
		animated_sprite_2d.animation = "flute"
		animated_sprite_2d.flip_h = false
	if direction.x < 0:
		if not playing_flute:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.animation = "walk_side"
		current_direction.x = -1
		current_direction.y = 0
		idle_direction = "side"
	elif direction.x > 0:
		if not playing_flute:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.animation = "walk_side"
		current_direction.x = 1
		current_direction.y = 0
		idle_direction = "side"
	elif direction.y < 0:
		if not playing_flute:
			animated_sprite_2d.animation = "walk_up"
		current_direction.y = -1
		current_direction.x = 0
		idle_direction = "up"
	elif direction.y > 0:
		if not playing_flute:
			animated_sprite_2d.animation = "walk_down"
		current_direction.y = 1
		current_direction.x = 0
		idle_direction = "down"
	elif direction == Vector2(0, 0):
		if not playing_flute:
			animated_sprite_2d.animation = "facing_" + idle_direction
			if current_direction.x > 0:
				animated_sprite_2d.flip_h = true

