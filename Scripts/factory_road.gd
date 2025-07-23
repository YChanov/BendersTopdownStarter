extends Node2D

var playerInside : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playerInside && Input.is_action_just_pressed("Enter") && hasEnough() :
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
