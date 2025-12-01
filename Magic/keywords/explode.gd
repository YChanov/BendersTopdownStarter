extends Keyword
class_name Explode

var magic: Magic
func create(newMagic: Magic):
	magic = newMagic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var exploded = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	magic.duration -= delta
	var target_distance = magic.global_position.distance_to(magic.target)
	if target_distance < 10 :
		explode()
	if (magic.duration > 0 || !exploded):
		return
	magic.queue_free()


func _on_detection_body_entered(body: Node2D) -> void:
	if exploded:
		return
	if !body.has_method('_take_damage') || body.name == magic.caster.name :
		return
	explode()

func explode():
	magic.intensity = 0
	exploded = true
