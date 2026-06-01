extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dist = self.global_position.distance_to(%Player.global_position)
	if dist < 200 and $AnimatedSprite2D.animation == "idle":
		$AnimatedSprite2D.play("open")
	elif dist < 10 and %Player.global_position.y > self.global_position.y:
		emit_signal("elevator2")
