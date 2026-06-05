extends CharacterBody2D
const SPEED = 15.0
var speed = SPEED
var direction = Vector2.DOWN
const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var target_position
var player
var maze: TileMapLayer
var TILE_SIZE = 256
var disabled = true

func _ready() -> void:
	get_parent().game.connect(_on_game)
	maze = %Maze
	TILE_SIZE *= maze.scale.x
	#x and y scales should be same
	global_position = get_tile_center(global_position)
	target_position = get_tile_center(global_position + TILE_SIZE * direction)
	player = %Mikazuki_player
	
func _on_game(argument) -> void:
	disabled = !argument
	pass

func _physics_process(delta: float) -> void:
	if disabled:
		return
	
	#haven't reached target yet
	if global_position.distance_to(target_position) > 1.0:
		velocity = global_position.direction_to(target_position) * speed
		move_and_slide()
		return

	#at target
	global_position = target_position
	var availableDirections = []
	for d in DIRECTIONS:
			if !is_maze_tile(d): availableDirections.append(d)
	if availableDirections.has(-direction) and availableDirections.size() >= 2:
		availableDirections.erase(-direction)
	if availableDirections.is_empty():
		print("error in mapping(?), nowhere to go.")
		return
	
	if global_position.distance_to(player.global_position) < 30:
		speed = SPEED + 10
		var playerDirection = player.global_position - global_position
		var buffer = 10
		if playerDirection.x > buffer and availableDirections.has(Vector2.RIGHT):
			direction = Vector2.RIGHT
		elif playerDirection.x < -1*buffer and availableDirections.has(Vector2.LEFT):
			direction = Vector2.LEFT
		elif playerDirection.y < -1*buffer and availableDirections.has(Vector2.UP):
			direction = Vector2.UP
		elif playerDirection.y > buffer and availableDirections.has(Vector2.DOWN):
			direction = Vector2.DOWN
		else:
			direction = random_direction(availableDirections)
	else:
		direction = random_direction(availableDirections)

	target_position = get_tile_center(global_position + TILE_SIZE * direction)
	velocity = speed*direction
	move_and_slide()

func get_tile_center(pos: Vector2) -> Vector2:
	#local global tile coord nightmare holy
	var local_coord = maze.to_local(pos)
	var tile_coord = maze.local_to_map(local_coord)
	var tile_center = maze.map_to_local(tile_coord)
	return maze.to_global(tile_center)

func is_maze_tile(dir: Vector2) -> bool:
	var tile_pos = maze.to_local(TILE_SIZE*dir + self.global_position)
	var tile_coord = maze.local_to_map(tile_pos)
	return maze.get_cell_tile_data(tile_coord) != null

func random_direction(availableDirections: Array) -> Vector2:
	var i = randi_range(0, availableDirections.size()-1)
	return availableDirections[i]
