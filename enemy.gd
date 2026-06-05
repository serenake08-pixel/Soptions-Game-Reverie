extends CharacterBody2D
const SPEED = 20.0
var speed = SPEED
var direction = Vector2.ZERO
var player
var availableDirections = []
var pastAvailableDirections = []
var atIntersection
const COOLDOWN = 0.4
var time_since_cooldown = 0

func _ready() -> void:
	var ray_up = $RayCastUP
	var ray_down = $RayCastDOWN
	var ray_left = $RayCastLEFT
	var ray_right = $RayCastRIGHT
	player = %Mikazuki_player


func _physics_process(delta: float) -> void:
	time_since_cooldown += delta
	atIntersection = false
	availableDirections = []
	if not $RayCastUP.is_colliding():
		availableDirections.append(Vector2.UP)

	if not $RayCastDOWN.is_colliding():
		availableDirections.append(Vector2.DOWN)

	if not $RayCastRIGHT.is_colliding():
		availableDirections.append(Vector2.RIGHT)
		

	if not $RayCastLEFT.is_colliding():
		availableDirections.append(Vector2.LEFT)
	
	pastAvailableDirections.sort()
	availableDirections.sort()
	
	if pastAvailableDirections.hash() != availableDirections.hash():
		#at intersection
		var must_turn = direction == Vector2.ZERO or not availableDirections.has(direction)
		if must_turn or time_since_cooldown >= COOLDOWN:
			print("at intersection")
			print(pastAvailableDirections)
			print(availableDirections)
			print()
			atIntersection = true
			time_since_cooldown = 0
	
	pastAvailableDirections = availableDirections.duplicate()
		
	if !atIntersection:
		velocity = SPEED*direction
		move_and_slide()
		return
	
	if availableDirections.has(-direction) and availableDirections.size() >=2:
		#try not to go backwards if given choice not to
		availableDirections.erase(-direction)
	
	#at intersection
	var playerDirection = player.position - self.position
	if (playerDirection.length_squared() < 1000 and availableDirections.size() > 0):
		#player detected
		var buffer = 10
		if playerDirection.x > buffer and availableDirections.has(Vector2.RIGHT):
			direction = Vector2.RIGHT
		elif playerDirection.x < -1*buffer and availableDirections.has(Vector2.LEFT):
			direction = Vector2.LEFT
		elif playerDirection.y < -1*buffer and availableDirections.has(Vector2.UP):
			direction = Vector2.UP
		elif playerDirection.y > buffer and availableDirections.has(Vector2.DOWN):
			direction = Vector2.DOWN
		else:
			direction = pick_random_direction()
		speed = SPEED + 10
	else: #player not detected; free roam:
		direction = pick_random_direction()
		speed = SPEED
	
	velocity = speed*direction
	move_and_slide()

func pick_random_direction() -> Vector2:
	var i = randi_range(0, availableDirections.size()-1)
	return availableDirections[i]
