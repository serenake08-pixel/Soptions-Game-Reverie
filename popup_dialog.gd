extends DialogicLayoutLayer
var showing = false

@export var texture: AtlasTexture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	self.visible = false
	pass # Replace with function body.

func _on_dialogic_signal(argument) -> void:
	if argument is String:
		return
	print("recieved signal!!!")
	if argument.get("memory") != null:
		$TextureRect.texture = load(argument.get("memory"))
		self.visible = true
		self.MOUSE_FILTER_PASS
		showing = true

func _input(event: InputEvent) -> void:
	if not showing:
		return
	if event.is_action_pressed("dialogic_default_action"):
		self.visible = false
		$TextureRect.MOUSE_FILTER_IGNORE
		showing = false
		Dialogic.Inputs.handle_input()
