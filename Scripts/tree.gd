extends StaticBody2D

@onready var label: Label = $Label
@export var drop : PackedScene

var playerInside : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = true
		label.visible = playerInside


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = false
		label.visible = playerInside

var chance_of_ouch = 0.1
func _take_damage(damage : int):
	if randf() < chance_of_ouch:
		label.text = "OUCH! That hurts you prick!"
	else:
		label.text = "Punch the tree (LMB)\nto get wood"
	if drop == null :
		return
	var new_drop = drop.instantiate()
	new_drop.initial_position = position;
	var rand_drop_position_x = randi_range(0, 64) * randi_range(-1,1)
	var rand_drop_position_y = randi_range(0, 64) * randi_range(-1,1)
	var relative_y = position.y - rand_drop_position_y
	if relative_y > 300 && relative_y < 400 :
		rand_drop_position_y = rand_drop_position_y + 128
	new_drop.position = position + Vector2(rand_drop_position_x, rand_drop_position_y);
	get_parent().get_parent().add_child(new_drop)
