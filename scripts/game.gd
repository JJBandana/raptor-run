extends Node

@export var world_speed = 300
@export var collectible_pitch_reset_interval = 2000

@onready var moving_environment = $Moving
@onready var collect_sound = $Sound/CollectSound
@onready var score_label = $HUD/UI/Score

var platform = preload("res://scenes/platform.tscn")
var platform_collectible_single = preload("res://scenes/platform_collectible_single.tscn")
var platform_collectible_row = preload("res://scenes/platform_collectible_row.tscn")
var rng = RandomNumberGenerator.new()
var last_platform_position = Vector2.ZERO
var next_spawn_time = 0
var score = 0
var collectible_pitch = 1.0
var reset_collectible_pitch_time = 0

func _ready():
	rng.randomize()

func _process(_delta):
	if Time.get_ticks_msec() > reset_collectible_pitch_time:
		collectible_pitch = 1.0
	
	if Time.get_ticks_msec() > next_spawn_time:
		_spawn_next_platform()
	
	score_label.text = "Score: %s" %score

func _spawn_next_platform():
	var available_platforms = [
		platform,
		platform_collectible_single,
		platform_collectible_row
	]
	var platform_index = rng.randi_range(0, available_platforms.size() - 1)
	var new_platform = available_platforms[platform_index].instantiate()
	
	if last_platform_position == Vector2.ZERO:
		new_platform.position = Vector2(400, 0)
	else:
		var x = last_platform_position.x + rng.randi_range(450, 550)
		var y = clamp(last_platform_position.y + rng.randi_range(-150, 150), 200, 1000)
		new_platform.position = Vector2(x, y)
	moving_environment.add_child(new_platform)
	last_platform_position = new_platform.position
	next_spawn_time += world_speed

func _physics_process(delta):
	moving_environment.position.x -= world_speed * delta

func add_score(value):
	score += value
	collect_sound.set_pitch_scale(collectible_pitch)
	collect_sound.play()
	collectible_pitch += 0.1
	reset_collectible_pitch_time = Time.get_ticks_msec() + collectible_pitch_reset_interval
