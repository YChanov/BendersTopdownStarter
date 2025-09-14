extends Node
class_name Magic

@export var keywords : Array[PackedScene]
@export var intensity: int
@export var power: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for keyword in keywords:
		var instance : Keyword = keyword.instantiate()
		add_child(instance)
		instance.create(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
