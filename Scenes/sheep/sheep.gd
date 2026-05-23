extends Interactable

var walking = false
var walkTime = 2.0
var direction
var speed: int

func _ready() -> void:
	super()
	speed = rng.randi_range(50, 150)
	$AnimatedSprite2D.flip_h = bool(randi() % 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if walking:
		move_and_collide(direction * delta)
		walkTime -= delta
		if walkTime < 0:
			walkTime = rng.randf_range(1.0,2.3)
			$AnimatedSprite2D.play("bend down")
			walking = false
		pass

	#cooldown
	cooldown -= delta
	if cooldown > 0:
		return
	else:
		_graze()
		cooldown = rng.randf_range(2.5, 5.5)
	pass
	
func _graze() -> void:
	var r = rng.randi_range(1, 10)
	if r >= 7:
		return
		
	if $AnimatedSprite2D.animation == "graze" || $AnimatedSprite2D.animation == "bend down":
		if r >= 4:
			$AnimatedSprite2D.play("graze")
			#print("grazed")
		elif r <= 2:
			$AnimatedSprite2D.play("bend up")
			#print("up")
	
	else:
		_walk()
		walking = true
			

func _walk() -> void:
	$AnimatedSprite2D.play("walk")
	direction = Vector2([1, -1].pick_random(), 0)
	$AnimatedSprite2D.flip_h = direction.x > 0
	walkTime = rng.randf_range(1.0, 2.0)
	
