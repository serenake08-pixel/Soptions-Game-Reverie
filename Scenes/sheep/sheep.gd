extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(str(position.y) + "sleep")
	#make sure happens every cooldown time
	cooldown -= delta
	if cooldown > 0:
		return
	else:
		_graze()
		cooldown = rng.randf_range(2.5, 5.5)
	pass
	
func _graze() -> void:
	var r = rng.randi_range(1, 5)
	if r >= 5:
		return
		
	if $AnimatedSprite2D.animation == "graze" || $AnimatedSprite2D.animation == "bend down":
		if r >= 2:
			$AnimatedSprite2D.play("graze")
			print("grazed")
		else:
			$AnimatedSprite2D.play("bend up")
			print("up")
	
	else:
		if r == 1:
			$AnimatedSprite2D.play("bend down")
			print("down")
	
	
