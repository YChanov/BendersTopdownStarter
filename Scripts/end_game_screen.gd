extends Control

const MAIN_AREA = "res://Scenes/Levels/MainArea.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_restart_button_pressed() -> void:
	GameManager.load_next_level(load(MAIN_AREA))
