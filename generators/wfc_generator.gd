#@tool 
extends Node2D

const INVISIBLE_BARRIER = preload("res://GeneratedEnvironment/InvisibleBarrier.tscn")
@export var frequency : float = 0.06 :
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
	setBorders()
	
func setBorders():
	if !tilemap:
		return
	var tile_size = tilemap.tile_set.tile_size
	tile_size = Vector2(tile_size.x, tile_size.y)
	var origin = Vector2.ZERO
	var end = Vector2(map_size.x, map_size.y) * tile_size
	
	var left_border = INVISIBLE_BARRIER.instantiate()
	left_border.A = origin
	left_border.position = origin
	left_border.B = Vector2(origin.x, end.y)
	add_child(left_border)
	
	var top_border = INVISIBLE_BARRIER.instantiate()
	top_border.A = origin
	top_border.position = origin
	top_border.B = Vector2(end.x, origin.y)
	add_child(top_border)
	
	var right_border = INVISIBLE_BARRIER.instantiate()
	right_border.A = Vector2(end.x, origin.y)
	right_border.position = end
	right_border.B = end
	add_child(right_border)
	
	var bottom_border = INVISIBLE_BARRIER.instantiate()
	bottom_border.A = Vector2(origin.x, end.y)
	bottom_border.position = end
	bottom_border.B = end
	add_child(bottom_border)

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
	setBorders()
	notify_property_list_changed()
