extends Node

var tile_config: Array[Dictionary] = [
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

var obstacles: Array[Dictionary] = [
	{ "scene": "res://Scenes/Obstacles/PurpleGrass.tscn", "weight": 2, "chance": 0.025 },
	{ "scene": "res://Scenes/Obstacles/PurpleGrassLarge1.tscn", "weight": 1, "chance": 0.015 },
	{ "scene": "res://Scenes/Obstacles/PurpleGrassLarge2.tscn", "weight": 1, "chance": 0.01 },
	{ "scene": "res://Scenes/Obstacles/PurpleGrassLarge3.tscn", "weight": 1, "chance": 0.008 },
]

var river_tiles:= [
	Vector2i(0, 1),
	Vector2i(1, 1),
	Vector2i(0, 2),
	Vector2i(1, 2),
]

const TILE_SET_SOURCE_ID = 1
const WATER_TILE_SET_SOURCE_ID = 5

@export var tile_area_size := Vector2i(100, 100)
@onready var generated_container: Node = $"../Generated"
@onready var tilemap: TileMapLayer = $"../Generated/TileMap"
const SPAWNER = preload("res://Scenes/Interactables/Spawner.tscn")
const SPAWNER_CHANCE = 0.01

const TREE = preload("res://Scenes/Interactables/Spawner.tscn")
const TREE_CHANCE = 0.01

var weighted_tile_pool: Array[Vector2i] = []
var weighted_obstacle_pool: Array[String] = []

func _ready():
	generate_level()

func generate_initial_grass():
	const range_grass = 3
	for x in range(-range_grass,range_grass) :
		for y in range(-range_grass,range_grass):
			tilemap.set_cell(Vector2(x,y), 2, Vector2i(randi_range(6,8), randi_range(3,5)))
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('Restart') :
		generate_level()
		
func generate_level():
	for child in generated_container.get_children():
		if child is ObstacleBase or child is Spawner:
			child.queue_free()
		
	weighted_tile_pool.clear()
	weighted_obstacle_pool.clear()
	tilemap.clear()
	_build_weighted_tile_pool()
	_build_weighted_obstacle_pool()
	generate_random_environment()
	generate_initial_grass()
	
func generate_spawner(x, y):
	if abs(x) < 5 && abs(y) < 5 or randf() > SPAWNER_CHANCE:
		return
	
	var is_permanent = abs(x) > 25 and abs(y) > 25
	
	print('bip ',x,' ',y, ' permanent' if is_permanent else ' non-permanent')
	place_spawner(Vector2i(x,y), is_permanent)
	
func place_spawner(position, is_permanent):
	var spawner_instace = SPAWNER.instantiate()
	spawner_instace.one_time = !is_permanent
	spawner_instace.position = tilemap.map_to_local(position)
	generated_container.add_child(spawner_instace)
	
func _build_weighted_tile_pool():
	for tile_info in tile_config:
		var weight = tile_info.get("weight", 1)
		var coords = tile_info.get("coords", Vector2i.ZERO)
		for i in range(weight):
			weighted_tile_pool.append(coords)

func _build_weighted_obstacle_pool():
	weighted_obstacle_pool.clear()
	for obstacle_info in obstacles:
		var weight = obstacle_info.get("weight", 1)
		var scene_path = obstacle_info.get("scene", "")
		for i in range(weight):
			weighted_obstacle_pool.append(scene_path)

func _get_random_tile_coords() -> Vector2i:
	if weighted_tile_pool.is_empty():
		return Vector2i.ZERO
	return weighted_tile_pool[randi() % weighted_tile_pool.size()]

func _get_random_obstacle_scene() -> String:
	if weighted_obstacle_pool.is_empty():
		return ""
	return weighted_obstacle_pool[randi() % weighted_obstacle_pool.size()]

func generate_random_environment():
	var area_half := tile_area_size / 2
	var tile_size := tilemap.tile_set.tile_size
	for x in range(-area_half.x, area_half.x):
		for y in range(-area_half.y, area_half.y):
			var pos := Vector2i(x, y)
			var atlas_coords := _get_random_tile_coords()
			tilemap.set_cell(pos, TILE_SET_SOURCE_ID, atlas_coords)
			place_obstacle_by_chance(x, y, tile_size)
			generate_spawner(x, y)
	tilemap.update_internals()
	
func place_obstacle_by_chance(x,y,tile_size):
	if abs(x) < 5 && abs(y) < 5:
		return
		
	for obstacle_info in obstacles:
		var chance = obstacle_info.get("chance", 0.0)
		if randf() <= chance:
			var scene_path = obstacle_info.get("scene", false)
			if scene_path:
				_place_obstacle_at_position(Vector2i(x, y), scene_path, tile_size)
				break

func _place_obstacle_at_position(tile_pos: Vector2i, scene_path: String, tile_size: Vector2i):
	var obstacle_scene = load(scene_path)
	if obstacle_scene:
		var world_pos = tilemap.map_to_local(tile_pos)
		if tilemap.get_cell_tile_data(tile_pos).get_custom_data('is_water') :
			print('yep')
		var obstacle_instance = obstacle_scene.instantiate()
		obstacle_instance.position = world_pos + Vector2(randi_range(-20,20), randi_range(-20,20))
		obstacle_instance.scale.x = -1 if randi_range(0,1) == 1 else 1
		generated_container.add_child(obstacle_instance)
		obstacle_instance.set_owner(generated_container)
	else:
		push_error("Failed to load obstacle scene: " + scene_path)
