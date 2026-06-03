extends Node

#code for activating computer
const minigame = preload("res://Scenes/minigame.tscn")
var minigameInstance: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Computer.connect("comp_minigame", _on_computer_minigame)
	pass # Replace with function body.

func _on_computer_minigame() -> void:
	if minigameInstance == null:
		minigameInstance = minigame.instantiate()
		get_tree().root.add_child(minigameInstance)
		print("Instantiated node name: ", minigameInstance.name)
		minigameInstance.show()
		$Player.disabled = true
	else:
		minigameInstance.queue_free()
		minigameInstance = null
		$Player.disabled = false
	
func _inMinigame() -> bool:
	return !minigameInstance == null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
