extends Keyword
class_name Explode
#fix to actually be an explosion
var _original_color
var magic: Magic

func create(newMagic: Magic):
	magic = newMagic
	
func get_keyword_name():
	return "Explode"
	
var exploded = false

func _process(delta: float) -> void:
	var target_distance = magic.global_position.distance_to(magic.target)
	if target_distance < 10 && !exploded:
		explode()

func _on_detection_body_entered(body: Node2D) -> void:
	if exploded:
		return
		
	if !body.has_method('_take_damage') || body.name == magic.caster.name :
		return
	explode()

func explode():
	magic.intensity = 0
	magic.power = 30
	exploded = true
	get_tree().create_timer(magic.duration / 30).timeout.connect(_on_timeout)

func _on_timeout():
	magic.queue_free()
