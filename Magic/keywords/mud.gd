extends Keyword
class_name mud

var POWER
var magic: Magic
const COOLDOWN = 1
@onready var timer: Timer = $Timer

func create(newMagic: Magic):
	POWER = newMagic.power
	magic = newMagic
	
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
	if !body.has_method('_set_move_speed') || body.name == magic.caster.name :
		return
	body._set_move_speed(body.move_speed - magic.power)
	queue_free()
