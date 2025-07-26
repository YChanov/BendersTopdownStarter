extends Node
# Configuration for tile placement
# Use your tile IDs here (from your tileset)
# These IDs are the atlas coordinates or names defined in the tileset
@export var tile_config := {
	"a": Vector2i(1, 1),
	"s": Vector2i(6, 3),
	"q": Vector2i(7, 3),
	"d": Vector2i(8, 3),
	"e": Vector2i(6, 4),
	"f": Vector2i(7, 4),
	"g": Vector2i(8, 4),
	"h": Vector2i(6, 5),
	"j": Vector2i(7, 5),
	"k": Vector2i(8, 5),
	"z": Vector2i(6, 4),
	"x": Vector2i(6, 4),
	"v": Vector2i(6, 4),
	"b": Vector2i(6, 4),
}

@onready var tilemap: TileMapLayer = $"../Scene/TileMap"

@export var tile_area_size := Vector2i(100, 100) # Area size around the player

func _ready():
	generate_random_environment()
	

func generate_random_environment():
	tilemap.clear()

	var tile_keys := tile_config.keys()
	var area_half := tile_area_size / 2

	for x in range(-area_half.x, area_half.x):
		for y in range(-area_half.y, area_half.y):
			var world_pos = Vector2i(x, y)

			# Pick a random tile type
			var random_key = tile_keys[randi() % tile_keys.size()]
			var tile_atlas_coord = tile_config[random_key]

			tilemap.set_cell(world_pos, 1, tile_atlas_coord)

	tilemap.update_internals()
