@tool 
extends Node2D

@export var frequency : float = 0.15 :
	set(v):
		frequency = v
		afterSet()
@export var noise : bool :
	set(v):
		noise = v
		afterSet()
		
@export var tilemap : TileMapLayer :
	set(v):
		tilemap = v
		afterSet()
		
@export var map_size: Vector2i:
	set(v):
		map_size = v
		afterSet()

@export var map_empty_tile: Vector2i:
	set(v):
		map_empty_tile = v
		afterSet()
		
func _ready() -> void:
	drawBackground()

func drawBackground() -> void:
	if !tilemap or !tilemap.tile_set:
		return
	tilemap.clear()
	var noise_algo = FastNoiseLite.new()
	noise_algo.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_algo.seed = randi()
	noise_algo.frequency = frequency
	noise_algo.offset = Vector3(10,10,10)
	
	var grid_size = tilemap.tile_set.get_source(0).get_atlas_grid_size()
	
	for x in range(map_size.x):
		for y in range(map_size.y):
			var tile_coords = tilemap.to_local(Vector2i(x, y))
			var raw_noise_value = noise_algo.get_noise_2d(x,y)
			var atlas_coords = map_empty_tile if !noise else _get_atlas_coords(raw_noise_value, grid_size)
			tilemap.set_cell(tile_coords, 0, atlas_coords)
	

func _get_atlas_coords(noise_value : float, grid_size: Vector2):
	var total_tiles = grid_size.x * grid_size.y #4
	var chunk_size = float(2 / total_tiles) #0.5
	var value = float(-1 + chunk_size)  #-0.5
	var tile_x = 0
	while (value <= 1) and (tile_x <= (total_tiles - 1)):
		if noise_value <= value:
			break
		value = value + chunk_size
		tile_x = tile_x + 1
	return Vector2i(tile_x, 0)
func afterSet() -> void :
	drawBackground()
	notify_property_list_changed()
