extends Node

#code for activating computer
const minigame = preload("res://Scenes/minigame.tscn")
const mikazuki = preload("res://Scenes/Mikazuki.tscn")
var minigameInstance: Node
var isPlaying = false
@onready var music_player = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Monster.hide()
	$Computer.connect("comp_minigame", _on_computer_minigame)
	if Global.coming_from_house:
		$Player.global_position = Vector2(-360, -311)
		Global.coming_from_house = false
	music(true)
	
func music(play: bool) -> void:
	if play:
		if isPlaying:
			return
		isPlaying = true
		while isPlaying:
			music_player.volume_db = -15
			music_player.play()
			isPlaying = true
			await music_player.finished
			await get_tree().create_timer(randi_range(5, 10)).timeout
	else:
		var old_tweens = get_tree().get_processed_tweens()
		for t in old_tweens:
			if t.is_valid():
				t.kill()
		isPlaying = false
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, 3)
		await tween.finished
		music_player.stop()

func _on_computer_minigame() -> void:
	if minigameInstance == null:
		minigameInstance = minigame.instantiate()
		get_tree().root.add_child(minigameInstance)
		print("Instantiated node name: ", minigameInstance.name)
		$Player.disabled = true
		minigameInstance.game.connect(_on_game)
		music(false)
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
		music(false)
		return
	if !argument:
		music(true)
		minigameInstance.hide()
		minigameInstance.get_node("CanvasLayer").visible = false
		minigameInstance.set_process(false)
		minigameInstance.set_physics_process(false)
		minigameInstance.process_mode = PROCESS_MODE_DISABLED

		$Computer.interact_quit()
		await Dialogic.timeline_ended
		$Player.disabled = false
	else:
		music(false)

func _inMinigame() -> bool:
	if minigameInstance == null:
		return false
	return minigameInstance.process_mode != PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _cutscene() -> void:
	$Player.disabled = true
	$Monster.global_position = $Player.global_position - Vector2(50,50)
	$Monster.show()
	$Computer.computer_death()
	await Dialogic.timeline_ended
	minigameInstance.queue_free()
	await get_tree().create_timer(1).timeout
	$Computer.monster_cutscene()
	await Dialogic.timeline_ended
	$Player.disabled = true
	
	var tween = create_tween()
	$Player.disabled = true
	tween.tween_property($Monster, "global_position", $Player.global_position - Vector2(30,20), 2)
	tween.tween_property($Monster, "global_position", $Player.global_position - Vector2(20,20), 2)
	$Player.disabled = true
	await get_tree().create_timer(4).timeout
	
	var mikazuki_instance = mikazuki.instantiate()
	mikazuki_instance.position = $Player.position - Vector2(6,7)
	add_child(mikazuki_instance)
	mikazuki_instance.show()
	
	#TODO COOL EXPLOSION ANIMATION
	await get_tree().create_timer(2).timeout
	
	$Monster.hide()
	
	mikazuki_instance.interact()
	music(true)
	await Dialogic.timeline_ended
	mikazuki_instance.queue_free()
	$Computer.disabled = false
	$Player.disabled = false
	
	
