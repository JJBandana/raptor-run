extends CharacterBody2D

@export var movement_speed = 50

@onready var sprite = $AnimatedSprite2D

var active = false
var gravity = 1600

func _physics_process(delta):
	if not active:
		return
	velocity.x = -movement_speed
	velocity.y = gravity * delta
	move_and_slide()

func set_active(value):
	active = value
	if active:
		sprite.play("walk")
