extends CharacterBody2D

const defaultSpeed = 100
const sprintSpeed = 200
var speed = defaultSpeed

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("walkLeft", "walkRight")
	direction.y = Input.get_axis("walkUp", "walkDown")
	direction = direction.normalized()
	
	if Input.is_action_pressed("sprint"):
		speed = sprintSpeed
	if Input.is_action_just_released("sprint"):
		speed = defaultSpeed
	
	if direction.length() > 0:
		direction = direction.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		if $AnimatedSprite2D.animation == "walkRight":
			$AnimatedSprite2D.animation = "idleRight"
		elif $AnimatedSprite2D.animation == "walkLeft":
			$AnimatedSprite2D.animation = "idleLeft"
		elif $AnimatedSprite2D.animation == "walkUp":
			$AnimatedSprite2D.animation = "idleUp"
		elif $AnimatedSprite2D.animation == "walkDown":
			$AnimatedSprite2D.animation = "idleDown"
	
	if direction.y < 0:
		$AnimatedSprite2D.animation = "walkUp"
	elif direction.y > 0:
		$AnimatedSprite2D.animation = "walkDown"
	elif direction.x > 0:
		$AnimatedSprite2D.animation = "walkRight"
	elif direction.x < 0:
		$AnimatedSprite2D.animation = "walkLeft"
	
	
	velocity = direction
	print(str(position.y) + "ply")
	move_and_slide()
