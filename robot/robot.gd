extends KinematicBody2D


const WALK_SPEED = 125
const RUN_SPEED = 250
const GRAVITY_FORCE = 10
const JUMP_FORCE = 280
const AIR_CONTROL = 200

var velocity = Vector2.ZERO
var old_velocity = Vector2.ZERO
var speed = 0
var direction = 0
var jumping = false
var running = false


func _physics_process(delta):
	var inputs = _get_inputs()
	
	if is_on_floor():
		_ground_stategy(delta, inputs)
	else:
		_air_strategy(delta, inputs)
	
	_move()
	_animation()


func _get_inputs():
	return {
		"direction": int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")), # -1 OR 0 OR 1
		"jumping": Input.is_action_pressed("jump"),
		"running": Input.is_action_pressed("run")
	}


# warning-ignore:unused_argument
func _ground_stategy(delta, inputs):
	jumping = inputs["jumping"]
	running = inputs["running"]
	direction = inputs["direction"]
	
	speed = RUN_SPEED if running else WALK_SPEED


func _air_strategy(delta, inputs):
	if not jumping: jumping = true
	
	if direction != inputs["direction"]:
		speed = clamp(speed - AIR_CONTROL * delta, 0, speed)


func _move():
	velocity = old_velocity
	velocity.x /= 2
	velocity.y += GRAVITY_FORCE
	velocity.x += speed * direction
	velocity.x = clamp(velocity.x, -speed, speed)
	
	if jumping and is_on_floor():
		velocity.y += -JUMP_FORCE
	
	old_velocity = move_and_slide(velocity, Vector2.UP)


func _animation():
	if direction != 0: $AnimatedSprite.flip_h = true if direction == -1 else false
	
	if jumping:
		if old_velocity.y > 0.1:
			$AnimatedSprite.animation = "jump_end"
		else:
			$AnimatedSprite.animation = "jump"
	else:
		if direction == 0 or (old_velocity.x > velocity.x + 0.1 or old_velocity.x < velocity.x - 0.1):
			$AnimatedSprite.animation = "idle"
		else:
			$AnimatedSprite.animation = "run" if running else "walk"
