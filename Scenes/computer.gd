extends Interactable
signal comp_minigame
var disabled = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	pass # Replace with function body.

func _on_dialogic_signal(argument) -> void:
	if argument is String and argument == "minigame":
		emit_signal("comp_minigame")

func interact() -> void:
	if disabled:
		return
	await startDialogue("res://Assets/Dialogic Files/computer.dtl")

func interact_quit() -> void:
	startDialogue("res://Assets/Dialogic Files/computerquit.dtl")

func computer_death() -> void:
	disabled = true
	startDialogue("res://Assets/Dialogic Files/computerdeath.dtl")

func monster_cutscene() -> void:
	await startDialogue("res://Assets/Dialogic Files/monster_cutscene.dtl")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
