extends Node2D
class_name Magic

@export var keywords : Array[PackedScene]
@export var intensity: int = 500
@export var power: int = 10
@export var duration : int = 200
@export var caster: CharacterBase
@export var target: Vector2
@export var cast_position: Vector2

@onready var keywords_container: Node2D = $keywords

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func cast(newCaster: CharacterBase):
	caster = newCaster
	global_position = caster.global_position
	
	for child in keywords_container.get_children():
		keywords_container.remove_child(child)
		child.queue_free()
		
	for keyword in keywords:
		var instance : Keyword = keyword.instantiate()
		keywords_container.add_child(instance)
		instance.create(self)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !caster:
		return
	if global_position.distance_to(caster.global_position) > power * 100:
		queue_free()
	
func remove_keyword(keyword : int):
	keywords.remove_at(keyword)
	
func add_keyword(keyword: PackedScene):
	keywords.push_back(keyword)
