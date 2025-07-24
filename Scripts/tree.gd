extends StaticBody2D

@onready var label: Label = $Label
@export var drop : PackedScene

var playerInside : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.visible = playerInside
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = false
		
func _take_damage(damage : int):
	if drop == null :
		return
	var new_drop = drop.instantiate()
	new_drop.initial_position = position;
	var rand_drop_position_x = randi_range(15,50) * randi_range(-1,1)
	var rand_drop_position_y = randi_range(15,50) * randi_range(-1,1)
	var relative_y = position.y - rand_drop_position_y
	if relative_y > 20 && relative_y < 60 :
		rand_drop_position_y = rand_drop_position_y + 20
	new_drop.position = position + Vector2(rand_drop_position_x, rand_drop_position_y);
	get_parent().get_parent().add_child(new_drop)
