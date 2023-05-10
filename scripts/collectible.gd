extends Area2D

@export var value = 10
@onready var game = $"/root/World"
@onready var sprite = $AnimatedSprite2D

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		game.add_score(value)
		sprite.play("collected")
		sprite.animation_finished.connect(on_animation_finished)

func on_animation_finished():
	queue_free()

func _process(_delta):
	pass
