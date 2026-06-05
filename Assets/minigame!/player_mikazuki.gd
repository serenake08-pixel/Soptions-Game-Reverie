extends CharacterBody2D

const defaultSpeed = 40
var speed = defaultSpeed
var disabled = true
var health = 3


func _ready() -> void:
	get_parent().game.connect(_on_game)
	$Hurtbox.area_entered.connect(_on_hurtbox_entered)
	$Hitbox.area_entered.connect(_on_hitbox_entered)

func _on_game(argument) -> void:
	disabled = !argument
	pass
	
func _on_hurtbox_entered(area: Node2D) -> void:
	health -= 1
	print("health lost! " + str(health))
	%HealthBar.value = health
	if health == 0:
		pass
	
func _on_hitbox_entered(area: Node2D) -> void:
	pass
	


func _physics_process(delta: float) -> void:
	if disabled:
		return
		#TODO: there are two ending siganls being claled and player only moves after hte second late one.
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("walkLeft", "walkRight")
	direction.y = Input.get_axis("walkUp", "walkDown")
	direction = direction.normalized()
	
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
	move_and_slide()
