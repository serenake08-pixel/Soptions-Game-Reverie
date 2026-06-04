extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	pass # Replace with function body.

func _on_dialogic_signal(argument) -> void:
	if argument is String and argument == "leave_house":
		get_tree().change_scene_to_file("res://Scenes/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
