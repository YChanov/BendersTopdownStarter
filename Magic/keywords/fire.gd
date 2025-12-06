extends Keyword
class_name fire

var magic: Magic
const COOLDOWN = 1
@onready var timer: Timer = $Timer
const EXPLOSION = preload("res://Art/explosion.webp")
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
var sprite : Sprite2D

func create(newMagic: Magic):
	magic = newMagic
	sprite = newMagic.find_child('sprite')
	sprite.texture = EXPLOSION
	
	get_tree().create_timer(magic.duration / 20).timeout.connect(_on_ttl_timeout)
	
var enemies : Dictionary
var in_cooldow := true

func get_keyword_name():
	return "Fire"
	
func _process(delta: float) -> void:
	collision_shape_2d.shape.radius = magic.power * 5
	sprite.scale = Vector2(magic.power / 10, magic.power / 10)
	
	if in_cooldow:
		return
		
	for key in enemies:
		var enemy = enemies[key]
		if !enemy || !enemy.has_method('_take_damage'): 
			continue
		print('damage')
		enemy._take_damage(magic.power)
	in_cooldow = true
	timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.has_method('_take_damage') || body.name == magic.caster.name :
		return
	body._take_damage(magic.power)
	timer.start()
	enemies[body.get_instance_id()] = body
	magic.z_index = magic.caster.z_index - 2

func _on_area_2d_body_exited(body: Node2D) -> void:
	enemies.erase(body.get_instance_id())
	print(enemies.keys().size())

func _on_timer_timeout() -> void:
	print('tick')
	in_cooldow = false

func _on_ttl_timeout() -> void:
	magic.queue_free()
