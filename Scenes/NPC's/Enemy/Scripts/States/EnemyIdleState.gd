extends State
class_name enemy_idle_state

@onready var body = $"../.."
@export var move_speed := float(30)

var chase_direction
func Enter():
	chase_direction = Vector2(randi_range(-100,100), randi_range(-100,100)) - body.position as Vector2
	var tree = get_tree()
	if !tree :
		return
	while true:
		chase_direction = chase_direction.rotated(45)
		await tree.create_timer(3).timeout
	pass

func Update(_delta):
	body.velocity = chase_direction.normalized() * move_speed
	body.move_and_slide()
	await get_tree().create_timer(2).timeout
