extends CanvasLayer

class_name GameScreens

const MAIN_AREA = "res://Scenes/Levels/MainArea.tscn"

func _ready() -> void:
	pass
	
func _on_play_button_pressed() -> void:
	GameManager.load_next_level(load(MAIN_AREA))
