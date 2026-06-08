extends Node

#code for activating computer
const minigame = preload("res://Scenes/minigame.tscn")
var minigameInstance: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Computer.connect("comp_minigame", _on_computer_minigame)

func _on_computer_minigame() -> void:
	if minigameInstance == null:
		minigameInstance = minigame.instantiate()
		get_tree().root.add_child(minigameInstance)
		print("Instantiated node name: ", minigameInstance.name)
		$Player.disabled = true
		minigameInstance.game.connect(_on_game)
	else:
		minigameInstance.game.emit(true)
		$Player.disabled = true
		minigameInstance.process_mode = Node.PROCESS_MODE_INHERIT
	minigameInstance.show()
	minigameInstance.get_node("CanvasLayer").visible = true
	minigameInstance.set_process(true)
	minigameInstance.set_physics_process(true)

func _on_game(argument) -> void:
	if !argument:
		minigameInstance.hide()
		minigameInstance.get_node("CanvasLayer").visible = false
		minigameInstance.set_process(false)
		minigameInstance.set_physics_process(false)
		minigameInstance.process_mode = PROCESS_MODE_DISABLED
		$Computer.interact_quit()
		await Dialogic.timeline_ended
		$Player.disabled = false

func _inMinigame() -> bool:
	return minigameInstance.process_mode != PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
