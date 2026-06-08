extends CanvasLayer
signal game
var level = 1
#TODO enemy + player default positions?
var numEnemies

const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")
@onready var quit_button = $CanvasLayer/MarginContainer/ColorRect/QUIT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quit_button.disabled = true
	quit_button.pressed.connect(_save_quit)
	game.emit(false)
	self.game.connect(_on_game)
	$Instructions.show()
	$Instructions/TextureButton.pressed.connect(_on_button_pressed)
	%Mikazuki_player.restartLevel.connect(_on_death)
	pass # Replace with function body.
	
func _on_button_pressed() -> void:
	$Instructions.queue_free()
	game.emit(true)

func _on_game(argument) -> void:
	_load_level()
	quit_button.disabled = false

func _load_level() -> void:
	%Maze.clear()
	var pattern = %Maze.tile_set.get_pattern(level-1)
	var grid_pos = Vector2i(1, 1)
	%Maze.set_pattern(grid_pos, pattern)
	

	%LevelLabel.text = "Lv. " + str(level)
	
	for old_enemy in get_tree().get_nodes_in_group("enemies"):
		old_enemy.queue_free()
	if level == 1:
		pass
		numEnemies = 3
		#spawn enemies at locations
	elif level == 2:
		pass
		numEnemies = 5
	elif level == 3:
		pass
		numEnemies = 17
	
func _on_death() -> void:
	

func spawn_enemy(pos: Vector2):
	var enemy_instance = ENEMY_SCENE.instantiate()
	enemy_instance.global_position = pos
	enemy_instance.add_to_group("enemies")
	add_child(enemy_instance)
	enemy_instance.enemy_killed.connect(_on_enemy_killed)

func _on_enemy_killed() -> void:
	numEnemies -= 1
	if numEnemies <= 10 and level == 3:
		emit_signal("end_minigame")
	elif numEnemies <= 0:
		#TODO some celebration!
		level += 1
		_load_level()
	pass

func _save_quit() -> void:
	game.emit(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
