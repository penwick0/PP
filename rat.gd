class_name Rat
extends CharacterBody2D
@export var player: CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var pull: bool = false
var push: bool = false
var lock: bool = false
var speed: float = 100.0

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity = Vector2.ZERO
	if push:
		direction = -direction
	if pull or push:
		velocity = direction * speed
	if lock:
		velocity = player.velocity
		direction = player.current_direction
	move_and_slide()
		
	# Animations
	if velocity != Vector2.ZERO:
		animated_sprite_2d.flip_h = direction.x < 0
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"

func _on_area_2d_area_entered(area):
	if area == player.pull_area:
		pull = true
	if area == player.push_area:
		push = true
	if area == player.lock_area:
		lock = true

func _on_area_2d_area_exited(area):
	if area == player.pull_area:
		pull = false
	if area == player.push_area:
		push = false
	if area == player.lock_area:
		lock = false
