extends CharacterBody2D
class_name Interactable

var rng = RandomNumberGenerator.new()
var cooldown = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func interact() -> void:
	var possiblePath = "res://Assets/Dialogic Files/" + str(remove_num(self.name)) + ".dtl"
	if ResourceLoader.exists(possiblePath):
		startDialogue(possiblePath)

func startDialogue(path: String) -> void:
	Dialogic.start(path)
	await Dialogic.timeline_ended

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
	
func remove_num(input: String) -> String:
	var result = ""
	for character in input:
		if not character.is_valid_int():
			result += character
			
	return result
