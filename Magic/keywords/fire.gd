extends Keyword
class_name fire

const WOOD_RESOURCE = preload("res://Art/wood_resource.png")
var magic: Magic
const COOLDOWN = 1
@onready var timer: Timer = $Timer

func create(newMagic: Magic):
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
		enemy._take_damage(magic.power)
	in_cooldow = true
	timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.has_method('_take_damage') || body.name == magic.caster.name :
		return
	body._take_damage(magic.power)
	#queue_free()
