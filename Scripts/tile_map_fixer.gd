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
	process_mode = Node.PROCESS_MODE_ALWAYS
	fixStuff()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = !get_tree().paused

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


func saveGame():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
	# Now, we can call our save function on each node.
