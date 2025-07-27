extends Node
const LIGHT_BIG = preload("res://Scenes/light_big.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children = get_parent().get_children()
	var light = LIGHT_BIG.instantiate()
	for child in children :
		for child2 in child.get_children() :
			if child2 is not ObstacleBase and child2 is not StaticBody2D and child2 is not Spawner:
				print("Skipping ",child2.get_class())
				continue
			child2.add_child(light)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
