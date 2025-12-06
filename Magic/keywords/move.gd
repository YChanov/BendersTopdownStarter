extends Keyword

var magic: Magic
var mouse_pos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func get_keyword_name():
	return "Move"

func create(newMagic: Magic):
	magic = newMagic
	global_position = newMagic.global_position
	mouse_pos = newMagic.get_global_mouse_position()
	magic.target = mouse_pos
	magic.cast_position = global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target = magic.target - magic.cast_position
	target = target.normalized()
	magic.global_position += target * magic.intensity * delta
