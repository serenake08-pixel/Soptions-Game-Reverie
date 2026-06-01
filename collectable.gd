extends Sprite2D
@export var itemName: String
const startingHidden = ["RESUME"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if startingHidden.has(itemName):
		disable_object()

func interact() -> void:
	Dialogic.VAR.collectable = itemName.to_upper()
	Dialogic.VAR.Inventory[itemName.to_upper()] = true
	Dialogic.start("collectable_found")
	await Dialogic.timeline_ended
	#SELF DESTRUCTION
	queue_free()

func _on_dialogic_signal(argument) -> void:
	if argument is not String:
		return
	if argument == "fishQuest" && itemName == "RESUME":
		enable_object()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func disable_object() -> void:
	hide()
	set_process(false)
	set_physics_process(false)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)

func enable_object() -> void:
	show()
	set_process(true)
	set_physics_process(true)
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
