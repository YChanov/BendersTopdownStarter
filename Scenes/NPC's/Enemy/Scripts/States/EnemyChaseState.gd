extends State
class_name enemy_chase_state

var move_speed := float(60)

@onready var body = $"../.."

func Enter():
	pass
	
func Update(_delta):
	var player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	var chase_direction = player.position - body.position as Vector2

	body.velocity = chase_direction.normalized() * move_speed
	body.move_and_slide()
	
