extends Keyword
class_name fire

const WOOD_RESOURCE = preload("res://Art/wood_resource.png")
const POWER = 10
const COOLDOWN = 1
@onready var timer: Timer = $Timer

func create(magic: Magic):
	magic.power = POWER
	
var enemies : Dictionary
var in_cooldow := false
	
func _process(delta: float) -> void:
	if in_cooldow:
		return
	for key in enemies:
		var enemy = enemies[key]
		if !enemy || !enemy.has_method('_take_damage'): 
			continue
		enemy._take_damage(POWER)
		print('damage done')
	in_cooldow = true
	timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	enemies[body.unique_name_in_owner] = body
	print(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	enemies.erase(body.unique_name_in_owner)

func _on_timer_timeout() -> void:
	print('not cooldown')
	in_cooldow = false
