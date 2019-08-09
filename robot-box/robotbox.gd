extends Node2D


const MOVE_SPEED = 280
const GRAVITY_FORCE = 50
const STEPS = [
	{"position": -25, "time": 0.05},
	{"position": 5, "time": 0.05},
	{"position": -50, "time": 0.10},
	{"position": 0, "time": 0.10},
	{"position": -90, "time": 0.15},
	{"position": -20, "time": 0.10},
	{"position": -170, "time": 0.15},
	{"position": -70, "time": 0.15},
	{"position": -290, "time": 0.15},
	{"position": -150, "time": 0.15},
	{"position": -450, "time": 0.15},
]

onready var base_position = position
var step = 0
var ready = true


func _ready():
	set_physics_process(false)


func start():
	set_physics_process(true)
	$AnimatedSprite.playing = true


# warning-ignore:unused_argument
func _physics_process(delta):
	if step == len(STEPS):
		ready = false
	if ready:
		if Input.is_action_pressed("move_left") and step % 2 == 0:
			step += 1
			ready = false
			_start_tween()
		elif Input.is_action_pressed("move_right") and step % 2 == 1:
			step += 1
			ready = false
			_start_tween()


func _start_tween():
	$Tween.interpolate_property(
		self,
		"position:x",
		position.x,
		base_position.x + STEPS[step - 1]["position"],
		STEPS[step - 1]["time"],
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	$Tween.start()


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	ready = true
