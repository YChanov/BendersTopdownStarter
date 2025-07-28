extends CanvasLayer

class_name GameScreens

#signal game_started

@onready var end_of_game_screen = $EndGameScreen
@onready var start_game_screen = $StartGameScreen

func _ready() -> void:
	pass

#func _process(delta: float) -> void:
	#pass


func on_game_over():
	end_of_game_screen.visible = true

func on_game_start():
	print('on_game_start')
	start_game_screen.visible = true

func _on_restart_button_pressed():
	restart()
	
	
func restart():
	print('restart')
	GameManager.reset_money()
	GameManager.load_same_level()


func _on_play_button_pressed() -> void:
	start_game_screen.hide()
