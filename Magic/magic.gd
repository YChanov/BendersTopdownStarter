extends Node

@export var keywords : Array[Keyword]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for keyword in keywords:
		keyword.ready(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for keyword in keywords:
		keyword.process(self)
		
func _exit_tree() -> void:
	for keyword in keywords:
		keyword.exit(self)
	
