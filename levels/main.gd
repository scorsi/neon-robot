extends Node2D


const SPEED = 200

var step = 0


func _process(delta):
	match step:
		1:
			$TextureButton.hide()
			step += 1
		2:
			$Sprite.translate(Vector2(-SPEED * delta, 0))
			if $Sprite.position.x <= 310:
				step += 1
		3:
			$Sprite/RobotBox.start()
			step += 1

func _on_TextureButton_pressed():
	step = 1
