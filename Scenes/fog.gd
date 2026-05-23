extends TileMapLayer
@export var drift_speed: Vector2 = Vector2(5.0, 0.0)
var direction = -1
var timePassed = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timePassed += delta
	position.x = sin(timePassed*0.3)*20
	pass
