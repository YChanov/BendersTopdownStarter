extends Keyword

var target: Vector2
var magic: Magic
var mouse_pos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func create(newMagic: Magic):
	magic = newMagic
	global_position = newMagic.global_position
	mouse_pos = newMagic.get_global_mouse_position()
	print(mouse_pos)
	target = mouse_pos - global_position
	target = target.normalized()
	print(target)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	magic.global_position += target * magic.intensity * delta
