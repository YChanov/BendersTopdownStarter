extends Node

var tilemap_size = Vector2i(100,100)
@onready var tile_map_roads: TileMapLayer = $"../Scene/TileMapRoads"
@onready var grass: TileMapLayer = $"../Scene/grass"
@onready var ground: TileMapLayer = $"../Scene/ground"
@onready var river: TileMapLayer = $"../Scene/river"
@onready var bottom: TileMapLayer = $"../Scene/bottom"

@export var tilemaps : Array[TileMapLayer] = [
	tile_map_roads,
	grass,
	ground,
	river,
	bottom
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fixStuff()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fixStuff():
	for x in range(-tilemap_size.x,tilemap_size.x):
		for y in range(-tilemap_size.y,tilemap_size.y):
	#for x in range(-2973,-2300):
		#for y in range(460,767):
			fixCollision(Vector2(x,y))

func fixCollision(target_position : Vector2):
	var disable_colision = false
	var remove_under = false
	var data = null
	for tilemap_layer in tilemaps:
		data = null
		#var tile_source_id = tilemap_layer.get_cell_source_id(tilemap_layer.local_to_map(target_position))
		var tile_source_id = tilemap_layer.get_cell_source_id(target_position)
		if tile_source_id == -1:
			continue
		if remove_under and (tile_source_id == 5) :
			tilemap_layer.set_cell(target_position, -1)
			continue
		elif disable_colision :
			tilemap_layer.set_cell(target_position, 1, Vector2i(10,1))
			continue
		disable_colision = true
		remove_under = tile_source_id == 1 or tile_source_id == 2 or tile_source_id == 4
