extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact() -> void:
	startDialogue("res://Assets/Dialogic Files/dinner_with_Mikazuki.dtl")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
