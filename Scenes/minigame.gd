extends CanvasLayer
signal game
var level = 1
var numEnemies
var atDeath = false

const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")
@onready var quit_button = %QUIT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quit_button.disabled = true
	quit_button.pressed.connect(_save_quit)
	game.emit(false)
	self.game.connect(_on_game)
	$Instructions.show()
	$Instructions/TextureButton.pressed.connect(_on_button_pressed)
	%Mikazuki_player.died.connect(_on_death)
	%Mikazuki_player.finishedLevel.connect(_next_level)
	pass # Replace with function body.
	
func _next_level() -> void:
	%Mikazuki_player.disabled = true
	var blinking_things = [%Mikazuki_player, %Maze, %HealthBar, %HealthLabel, %LevelLabel, %QUIT] 
	var enemies = get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		blinking_things.append(e)
		e.disabled = true
	for i in range(1,4):
		for o in blinking_things:
			o.hide()
		await get_tree().create_timer(1.0).timeout
		for o in blinking_things:
			o.show()
		await get_tree().create_timer(1.0).timeout
	level += 1
	%Mikazuki_player.disabled = false
	_load_level()
	
func _on_button_pressed() -> void:
	$Instructions.queue_free()
	game.emit(true)

func _on_game(argument) -> void:
	if argument:
		_load_level()
	quit_button.disabled = false

func _load_level() -> void:
	%Maze.clear()
	var pattern = %Maze.tile_set.get_pattern(level-1)
	var grid_pos = Vector2i(1, 1)
	%Maze.set_pattern(grid_pos, pattern)

	%LevelLabel.text = "Lv. " + str(level)
	
	for old_enemy in get_tree().get_nodes_in_group("enemies"):
		old_enemy.remove_from_group("enemies")
		old_enemy.queue_free()
	numEnemies = (level-1)*2+1
	
	var emptyTiles = _get_empty_tiles()
	for i in range(0, numEnemies):
		spawn_enemy(emptyTiles[randi_range(0,emptyTiles.size())])
	
func _on_death() -> void:
	%Mikazuki_player.disabled = true
	var blinking_things = [%Mikazuki_player, %Maze, %GAMEOVER] 
	var enemies = get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		blinking_things.append(e)
		e.disabled = true
	for i in range(1,4):
		for o in blinking_things:
			o.show()
		await get_tree().create_timer(1.0).timeout
		for o in blinking_things:
			o.hide()
		%GAMEOVER.show()
		await get_tree().create_timer(1.0).timeout
	atDeath = true
	game.emit(false)
	
	

func spawn_enemy(pos: Vector2i):
	var enemy_instance = ENEMY_SCENE.instantiate()
	enemy_instance.global_position = %Maze.to_global(%Maze.map_to_local(pos))
	enemy_instance.add_to_group("enemies")
	add_child(enemy_instance)
	enemy_instance.disabled = false

func _save_quit() -> void:
	game.emit(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_empty_tiles() -> Array[Vector2i]:
	var ret: Array[Vector2i] = []
	for i in range(1,36):
		for j in range(1,21):
			var c = Vector2i(i,j)
			if %Maze.get_cell_tile_data(c) == null:
				if (%Mikazuki_player.global_position - %Maze.to_global(%Maze.map_to_local(c))).length() > 50:
					ret.append(Vector2i(i,j))
	return ret
