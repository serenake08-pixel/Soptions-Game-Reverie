extends CharacterBody2D

var overlapping = []
const defaultSpeed = 100
const sprintSpeed = 200
var speed = defaultSpeed
var disabled = false

func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)
	$Area2D.area_exited.connect(_on_area_exited)
	Dialogic.timeline_started.connect(func(): disabled = true)
	Dialogic.timeline_ended.connect(func(): disabled = false)

	
func _on_area_entered(area: Node2D) -> void:
	var body = area.get_parent()
	overlapping.append(body)
	print("entered " + body.name)
	
func _on_area_exited(area: Node2D) -> void:
	var body = area.get_parent()
	if (!overlapping.has(body)):
		push_error("So... a body exited without entering if my calculations are correct.")
	overlapping.erase(body)
	print("exited" + body.name) 

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if closestBody() != null && Dialogic.current_timeline == null:
			closestBody().interact()
		pass
		
func closestBody() -> Node2D:
	if overlapping.is_empty():
		return null
	var closest = overlapping[0]
	var closestDist = self.global_position.distance_to(closest.global_position)
	for body in overlapping:
		var dist = self.global_position.distance_to(body.global_position)
		if dist < closestDist:
			closestDist = dist
			closest = body
	return closest

func _physics_process(delta: float) -> void:
	if  disabled || str(Dialogic.current_timeline) == "[DialogicTimeline:]":
		#TODO: there are two ending siganls being claled and player only moves after hte second late one.
		return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("walkLeft", "walkRight")
	direction.y = Input.get_axis("walkUp", "walkDown")
	direction = direction.normalized()
	
	#
	#if Input.is_action_pressed("sprint"):
	#	speed = sprintSpeed
	#if Input.is_action_just_released("sprint"):
	#	speed = defaultSpeed
	
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
