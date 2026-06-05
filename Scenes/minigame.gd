extends CanvasLayer
signal game
var level = 1
@onready var quit_button = $CanvasLayer/MarginContainer/ColorRect/QUIT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quit_button.disabled = true
	quit_button.pressed.connect(_save_quit)
	game.emit(false)
	self.game.connect(_on_game)
	$Instructions.show()
	$Instructions/TextureButton.pressed.connect(_on_button_pressed)
	pass # Replace with function body.
	
func _on_button_pressed() -> void:
	$Instructions.queue_free()
	game.emit(true)

func _on_game(argument) -> void:
	quit_button.disabled = false
	pass

func _save_quit() -> void:
	game.emit(false)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
