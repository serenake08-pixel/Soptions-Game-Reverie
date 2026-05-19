extends CharacterBody2D


var speed = 300.0

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("walkLeft", "walkRight")
	direction.y = Input.get_axis("walkUp", "walkDown")
	direction = direction.normalized()
	
	if Input.is_action_pressed("sprint"):
		speed = 500
	if Input.is_action_just_released("sprint"):
		speed = 300
	
	if direction.length() > 0:
		direction = direction.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if direction.y < 0:
		$AnimatedSprite2D.animation = "walkUp"
	elif direction.y > 0:
		$AnimatedSprite2D.animation = "walkDown"
	elif direction.x > 0:
		$AnimatedSprite2D.animation = "walkRight"
	elif direction.x < 0:
		$AnimatedSprite2D.animation = "walkLeft"
	
	velocity = direction
	
	move_and_slide()
