extends Node2D

var playerInside : bool = false
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(0.1).timeout
	if !playerInside :
		label.visible = false
		return
	label.visible = true
	
	if !hasEnough() :
		label.text = "You need 1 slime and 1 wood\nto build roads!"
	else :
		label.text = "Press 'E' to\nbuild Roads"
	
	if Input.is_action_pressed("Enter") && hasEnough() :
		GameManager.add_road(1)
		GameManager.add_slime(-1)
		GameManager.add_wood(-1)
		return

func hasEnough() -> bool:
	return GameManager.slime > 0 && GameManager.wood > 0
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = false
