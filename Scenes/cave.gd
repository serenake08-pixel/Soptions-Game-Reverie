extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_house)
	pass # Replace with function body.

func interact() -> void:
	print("interaction started")
	startDialogue("res://Assets/Dialogic Files/cave.dtl")

func _on_house(_argument) -> void:
	get_tree().change_scene_to_file("res://Scenes/house.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
