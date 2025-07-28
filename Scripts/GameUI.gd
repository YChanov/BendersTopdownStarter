extends Control

@export var slime_label : Label
@export var wood_label : Label
@export var metal_label : Label
@export var road_label : Label
@export var healthbar : ProgressBar

@onready var game_screens: GameScreens = $GameScreens


func _ready() -> void:
	
	healthbar.max_value = 200
	healthbar.value = 200
	
func _process(_delta):
	

	slime_label.text = "Slime: " + "%d" % GameManager.slime
	wood_label.text = "Wood: " + "%d" % GameManager.wood
	metal_label.text = "Metal: " + "%d" % GameManager.metal
	road_label.text = "Road: " + "%d" % GameManager.road
	healthbar.value = GameManager.health
	
