extends Node2D
class_name Magic

@export var keywords : Array[PackedScene]
@export var intensity: int = 500
@export var power: int = 10
@export var caster: CharacterBase
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func cast(newCaster: CharacterBase):
	caster = newCaster
	global_position = caster.global_position
	print('casting')
	for child in get_children():
		remove_child(child)
		child.queue_free()
	for keyword in keywords:
		var instance : Keyword = keyword.instantiate()
		instance.create(self)
		add_child(instance)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !caster:
		return
	if global_position.distance_to(caster.global_position) > power * 100:
		queue_free()
	
