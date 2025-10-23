extends Control

@export var slime_label : Label
@export var wood_label : Label
@export var metal_label : Label
@export var road_label : Label
@export var healthbar : ProgressBar

@onready var game_screens: GameScreens = $GameScreens
@onready var pause_menu: Control = $PauseMenu


func _ready() -> void:
	healthbar.max_value = 100
	healthbar.value = 100
	pause_menu.visible = false
	
func _process(_delta):
	healthbar.value = GameManager.health
	
