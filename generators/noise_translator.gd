@tool
extends Node

@export_group("Translator configuration")
@export var noise_map : TileMapLayer :
	set(v):
		noise_map = v
		var grid_size = noise_map.tile_set.get_source(0).get_atlas_grid_size()
		if v:
			translation_atlas_coords.resize(grid_size.x * grid_size.y)
		notify_property_list_changed()

@export var target_map_layers : Array[TileMapLayer] :
	set(v):
		target_map_layers = v
		notify_property_list_changed()

@export var translation_atlas_coords : Array[TileTranslation] :
	set(v):
		translation_atlas_coords = v
		translate()
		notify_property_list_changed()

func _ready() -> void:
	translate()
	
func translate() -> void:
	if !noise_map or !target_map_layers.size():
		return
	
	#var noise_tile_size = noise_map.tile_set.tile_size
	#var target_tile_size = target_map.tile_set.tile_size
	#print(noise_tile_size, ' ', target_tile_size)
	var begin_noise = noise_map.get_used_rect().position
	var noise_size = noise_map.get_used_rect().size
	for map in target_map_layers:
		map.clear()
	for x in range(begin_noise.x, noise_size.x):
		for y in range(begin_noise.y, noise_size.y):
			for layer_index in range(target_map_layers.size()):
				var target_map = target_map_layers[layer_index]
				var noise_cell = noise_map.get_cell_atlas_coords(Vector2i(x,y))
				var target_global_position = noise_map.to_global(Vector2i(x,y))
				var target_local_position = target_map.to_local(target_global_position)
				var cell_translation : TileTranslation = translation_atlas_coords[noise_cell.x]#noise_cell.x]
				if !cell_translation:
					continue
				var source_id = cell_translation.source_id
				var tile_set : TileTranslationTileSet = cell_translation.tile_set
				if !tile_set:
					continue
				if cell_translation.layer_index != -1 and cell_translation.layer_index != layer_index:
					continue
				target_map.set_cell(target_local_position, source_id, tile_set.center)
