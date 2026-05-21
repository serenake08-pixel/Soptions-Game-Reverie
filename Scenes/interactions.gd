extends StaticBody2D
class_name Interactable

var overlapping = false
var rng = RandomNumberGenerator.new()
var cooldown = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	pass # Replace with function body.
	
func _on_body_entered(body: Node2D) -> void:
	overlapping = true
	print("entered")
	
func _on_body_exited(body: Node2D) -> void:
	overlapping = false
	print("exited")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
