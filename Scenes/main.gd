extends Node

#code for activating computer
const minigame = preload("res://Scenes/minigame.tscn")
const mikazuki = preload("res://Scenes/Mikazuki.tscn")
var minigameInstance: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Monster.hide()
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
	if minigameInstance.atDeath:
		_cutscene()
		return
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
	if minigameInstance == null:
		return false
	return minigameInstance.process_mode != PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _cutscene() -> void:
	$Monster.global_position = $Player.global_position - Vector2(50,50)
	$Monster.show()
	$Computer.computer_death()
	await Dialogic.timeline_ended
	minigameInstance.queue_free()
	await get_tree().create_timer(1).timeout
	await $Computer.monster_cutscene()
	
	$Player.disabled = true
	var tween = create_tween()
	tween.tween_property($Monster, "global_position", $Player.global_position - Vector2(30,20), 2)
	tween.tween_property($Monster, "global_position", $Player.global_position - Vector2(20,20), 2)

	await get_tree().create_timer(4).timeout
	
	var mikazuki_instance = mikazuki.instantiate()
	mikazuki_instance.position = $Player.position - Vector2(6,7)
	add_child(mikazuki_instance)
	
	#TODO COOL EXPLOSION ANIMATION
	await get_tree().create_timer(2).timeout
	
	$Monster.hide()
	
	await mikazuki_instance.interact()
	mikazuki_instance.queue_free()
	
