extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	if !Dialogic.VAR.metMikazuki:
		hide()
		set_process(false)
		set_physics_process(false)
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
	else:
		show()
		set_process(true)
		set_physics_process(true)
		$CollisionShape2D.set_deferred("disabled", false)
	
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact() -> void:
	#print(Dialogic.VAR.dinnerDialog)
	await startDialogue("res://Assets/Dialogic Files/MikazukiMeet.dtl")
