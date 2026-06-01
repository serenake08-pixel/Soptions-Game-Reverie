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
		self.add_child(minigameInstance)
		print("child added? " + str(minigameInstance))
		$Player.disabled = true
	else:
		minigameInstance.queue_free()
		$Player.disabled = false
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
