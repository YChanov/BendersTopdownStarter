@tool
extends Node

@export_group("Translator configuration")
@export var noise_map : TileMapLayer :
	set(v):
		noise_map = v
		notify_property_list_changed()

@export var target_map_layers : Array[TileMapLayer] :
	set(v):
		target_map_layers = v
		notify_property_list_changed()

@export var terrain_set : int = 0:
	set(v):
		terrain_set = v
		notify_property_list_changed()
@export var terrain_index_layers : Array[int] :
	set(v):
		terrain_index_layers = v
		notify_property_list_changed()

func _ready() -> void:
	translate()
	
func translate() -> void:
	if !noise_map or !target_map_layers.size():
		return
	var rect := noise_map.get_used_rect()
	var start := rect.position
	var end := rect.position + rect.size

	var terrains = []
	terrains.resize(terrain_index_layers.size())
	for i in terrain_index_layers.size():
		terrains[i] = []
	for x in range(start.x, end.x):
		for y in range(start.y, end.y):
			var noise_cell = noise_map.get_cell_atlas_coords(Vector2i(x,y))
			terrains[noise_cell.x].push_back(Vector2i(x,y))
	
	for map in target_map_layers:
		map.clear()
	for index in range(terrains.size()):
		var terrain_layer = terrains[index]
		if !terrain_layer.size():
			continue
		var tilemap : TileMapLayer = target_map_layers[index]
		var terrain_index : int = terrain_index_layers[index]
		tilemap.set_cells_terrain_connect(terrain_layer, 0, terrain_index)
