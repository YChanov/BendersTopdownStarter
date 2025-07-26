extends Node

@export var tile_config: Array[Dictionary] = [
	{ "coords": Vector2i(6, 3), "weight": 10 },
	{ "coords": Vector2i(7, 3), "weight": 1 },
	{ "coords": Vector2i(8, 3), "weight": 10 },
	{ "coords": Vector2i(6, 4), "weight": 10 },
	{ "coords": Vector2i(7, 4), "weight": 1 },
	{ "coords": Vector2i(8, 4), "weight": 1 },
	{ "coords": Vector2i(6, 5), "weight": 10 },
	{ "coords": Vector2i(7, 5), "weight": 1 },
	{ "coords": Vector2i(8, 5), "weight": 10 },
	{ "coords": Vector2i(15, 3), "weight": 10 },
	{ "coords": Vector2i(16, 3), "weight": 10 },
	{ "coords": Vector2i(17, 3), "weight": 10 },
	{ "coords": Vector2i(15, 4), "weight": 10 },
	{ "coords": Vector2i(16, 4), "weight": 10 },
	{ "coords": Vector2i(17, 4), "weight": 10 },
	{ "coords": Vector2i(15, 5), "weight": 10 },
	{ "coords": Vector2i(16, 5), "weight": 10 },
	{ "coords": Vector2i(17, 5), "weight": 10 }
]

const TILE_SET_SOURCE_ID = 1

@export var tile_area_size := Vector2i(100, 100)
@onready var tilemap: TileMapLayer = $"../Scene/TileMap"

var weighted_tile_pool: Array[Vector2i] = []

func _ready():
	if tilemap:
		_build_weighted_tile_pool()
		generate_random_environment()
		var new_scene := PackedScene.new()
		new_scene.pack(tilemap)
		ResourceSaver.save(new_scene, "res://generated_level.tscn")
	else:
		push_error("TileMapLayer not found!")

func _build_weighted_tile_pool():
	weighted_tile_pool.clear()
	for tile_info in tile_config:
		var weight = tile_info.get("weight", 1)
		var coords = tile_info.get("coords", Vector2i.ZERO)
		for i in range(weight):
			weighted_tile_pool.append(coords)

func _get_random_tile_coords() -> Vector2i:
	if weighted_tile_pool.is_empty():
		return Vector2i.ZERO
	return weighted_tile_pool[randi() % weighted_tile_pool.size()]

func generate_random_environment():
	tilemap.clear()

	var area_half := tile_area_size / 2

	for x in range(-area_half.x, area_half.x):
		for y in range(-area_half.y, area_half.y):
			var pos := Vector2i(x, y)
			var atlas_coords := _get_random_tile_coords()
			tilemap.set_cell(pos, TILE_SET_SOURCE_ID, atlas_coords)

	tilemap.update_internals()
