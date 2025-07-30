extends Node2D

@onready var label: Label = $Label

@export var target_level : String

var playerInside = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !playerInside :
		label.visible = false
		return
	else:
		label.visible = true
	if target_level && Input.is_action_just_pressed("Enter") :
		GameManager.t_group = get_groups()[0]
		GameManager.load_next_level(load(target_level))
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = false
