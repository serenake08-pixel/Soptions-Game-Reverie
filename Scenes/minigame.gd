extends CanvasLayer
signal game
var level = 1
var numEnemies
var atDeath = false
var playerTiles = [Vector2i(2,2), Vector2i(2,20), Vector2i(35,2), Vector2i(35,20)]
var isPlaying = false
@onready var music_player = $AudioStreamPlayer2D

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
	
func _next_level() -> void:
	%Mikazuki_player.disabled = true
	var blinking_things = [%Mikazuki_player, %Maze, %HealthBar, %HealthLabel, %LevelLabel, %QUIT, %Star] 
	var enemies = get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		blinking_things.append(e)
		e.disabled = true
	for i in range(1,3):
		for o in blinking_things:
			o.hide()
		await get_tree().create_timer(0.7).timeout
		for o in blinking_things:
			o.show()
		await get_tree().create_timer(0.7).timeout
	level += 1
	%Mikazuki_player.disabled = false
	_load_level()
	
func _on_button_pressed() -> void:
	$Instructions.queue_free()
	game.emit(true)

func _on_game(argument) -> void:
	if argument:
		music(true)
		_load_level()
	else:
		music(false)
	quit_button.disabled = false

func _load_level() -> void:
	%Maze.clear()
	var pattern = %Maze.tile_set.get_pattern((level-1)%3)
	var grid_pos = Vector2i(1, 1)
	%Maze.set_pattern(grid_pos, pattern)

	%LevelLabel.text = "Lv. " + str(level)
	
	for old_enemy in get_tree().get_nodes_in_group("enemies"):
		old_enemy.remove_from_group("enemies")
		old_enemy.queue_free()
	numEnemies = level
	
	var pos = playerTiles[randi_range(0,playerTiles.size()-1)]
	%Mikazuki_player.global_position = %Maze.to_global(%Maze.map_to_local(pos))
	
	var emptyEnemyTiles = _get_enemy_tiles()
	for i in range(0, numEnemies):
		spawn_enemy(emptyEnemyTiles[randi_range(0,emptyEnemyTiles.size()-1)])
	
	var emptyStarTiles = _get_star_tiles()
	var starPos = emptyStarTiles[randi_range(0,emptyStarTiles.size()-1)]
	%Star.global_position = %Maze.to_global(%Maze.map_to_local(starPos))
	
func _on_death() -> void:
	%Mikazuki_player.disabled = true
	var blinking_things = [%Mikazuki_player, %Maze, %GAMEOVER, %Star] 
	var enemies = get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		blinking_things.append(e)
		e.disabled = true
	for i in range(1,4):
		for o in blinking_things:
			o.show()
		await get_tree().create_timer(1.0).timeout
		for o in blinking_things:
			if (o != null):
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
				ret.append(Vector2i(i,j))
	return ret

func _get_enemy_tiles() -> Array[Vector2i]:
	var tiles = _get_empty_tiles()
	var ret: Array[Vector2i] = []
	for c in tiles:
		if %Mikazuki_player.global_position.distance_to(%Maze.to_global(%Maze.map_to_local(c))) > 50:
			ret.append(c)
	return ret

func _get_star_tiles() -> Array[Vector2i]:
	var tiles = _get_empty_tiles()
	var ret: Array[Vector2i] = []
	for c in tiles:
		if %Mikazuki_player.global_position.distance_to(%Maze.to_global(%Maze.map_to_local(c))) > 100:
			ret.append(c)
	return ret
