extends Node

var tilemap_size = Vector2i(100,100)
@export var tilemaps : Array[TileMapLayer]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fixStuff()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fixStuff():
	for x in range(-tilemap_size.x,tilemap_size.x):
		for y in range(-tilemap_size.y,tilemap_size.y):
			
			fixCollision(Vector2(x,y))

func fixCollision(position : Vector2):
	var disable_colision = false
	for tilemap_layer in tilemaps:
		if !tilemap_layer : 
			continue
		
		var tile_source_id = tilemap_layer.get_cell_source_id(position)
		if tile_source_id == -1:
			continue
		if disable_colision :
			tilemap_layer.get_cell_tile_data(position).set_collision_polygon_points(0, 0, [])
		if tile_source_id != -1:
			disable_colision = true
