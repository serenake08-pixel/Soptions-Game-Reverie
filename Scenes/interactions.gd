extends StaticBody2D
class_name Interactable

var rng = RandomNumberGenerator.new()
var cooldown = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func interact() -> void:
	pass

func startDialouge(path: String) -> void:
	Dialogic.start(path)
	await Dialogic.timeline_ended
	print("Dialogue finished!" + self.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
