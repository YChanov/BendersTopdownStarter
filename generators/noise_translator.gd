#@tool
extends Node

@export_group("Translator configuration")
@export var obstacles : Array[PackedScene] :
	set(v):
		obstacles = v 
		notify_property_list_changed()
@export var enemies : Array[PackedScene] :
	set(v):
		enemies = v 
		notify_property_list_changed()
@export var obstacle_layer_indexes : Array[int] = []
@export var enemy_layer_indexes : Array[int] = []
@export var enemies_chance : int = 2 :
	set(v):
		enemies_chance = v
		notify_property_list_changed()
@export var obstacle_chance : int = 2 :
	set(v):
		obstacle_chance = v
		notify_property_list_changed()
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
	
func place_obstacles(position : Vector2) -> void:
	var place = randf() < (obstacle_chance * 0.01)
	if !place:
		return
	var to_place = obstacles[randi_range(0, obstacles.size() - 1)]
	var instance = to_place.instantiate()
	instance.position = position * 64
	get_tree().root.add_child.call_deferred(instance)
	
func place_enemies(position : Vector2) -> void:
	var place = randf() < (enemies_chance * 0.01)
	if !place || !enemies.size():
		return
	var to_place = enemies[randi_range(0, enemies.size() - 1)]
	var instance = to_place.instantiate()
	instance.position = position * 64
	get_tree().root.add_child.call_deferred(instance)
	
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
			var target_place = noise_map.to_global(Vector2(x,y))
			if obstacle_layer_indexes.find(noise_cell.x) != -1:
				place_obstacles(target_place)
			if enemy_layer_indexes.find(noise_cell.x) != -1:
				place_enemies(target_place)
	
	for map in target_map_layers:
		map.clear()
	for index in range(terrains.size()):
		var terrain_layer = terrains[index]
		if !terrain_layer.size():
			continue
			
		var tilemap : TileMapLayer = target_map_layers[index]
		var terrain_index : int = terrain_index_layers[index]
		tilemap.set_cells_terrain_connect(terrain_layer, 0, terrain_index)
