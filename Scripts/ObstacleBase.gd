extends Node2D
class_name ObstacleBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().create_timer(1).timeout
	#var tilemap : TileMapLayer = get_parent().get_parent().get_node("Generated/TileMap");
	#if !tilemap :
		#return
	#var cell_source_id = tilemap.get_cell_source_id(tilemap.local_to_map(position))
	#if cell_source_id == 5:
		#queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
