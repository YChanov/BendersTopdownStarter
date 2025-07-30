extends CharacterBase
class_name PlayerMain

@onready var fsm = $FSM as FiniteStateMachine
@onready var enemy_spawn_points := $"../SpawnPoints"
@export var enemy_scene:= preload("res://Scenes/NPC's/Enemy/Enemy.tscn")
@onready var collision_shape_2d: CollisionShape2D = $AnimatedSprite2D/Hitboxes/Kick_Hitbox/CollisionShape2D

@export var tilemap_layers : Array[TileMapLayer] = []

const BREATHABLE_SOURCE_ID = 2
const ROADS_SOURCE_ID = 4

@onready var tile_overlay: Node2D = $TileOverlay
@onready var tile_map_roads: TileMapLayer = $"../Scene/TileMapRoads"

var triggered_tiles := {}
var toggleRoadPlacement : bool = false
var last_direction : Vector2 = Vector2(1, 0)
#All of our logic is either in the CharacterBase class
#or spread out over our states in the finite-state-manager, this class is almost empty 
func _ready() -> void:
	super._ready()
	if GameManager.t_group :
		var tele = get_tree().get_first_node_in_group(GameManager.t_group)
		position = tele.position if tele else position
	
func _process(delta: float) -> void:
	super._process(delta)
	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	if input_dir != Vector2.ZERO && (abs(input_dir.x + input_dir.y) == 1) :
		last_direction = input_dir
	RoadOverlay()
	toggleRoadPlacement && PutRoad()
	TileHandle(delta)
	
const BREATH_INTERVAL = 0.5
var breath_time: float = BREATH_INTERVAL
var target_position : Vector2i = Vector2i.ZERO

func RoadOverlay() :
	if GameManager.road <= 0:
		tile_overlay.visible = false
		toggleRoadPlacement = false
		return
		
	if Input.is_action_just_pressed("Restart") :
		toggleRoadPlacement = !toggleRoadPlacement
		
	if !toggleRoadPlacement :
		tile_overlay.visible = false
		return
	var tile_map = getParentTileMap()
	var current_position = tile_map.local_to_map(position)
	target_position = Vector2i(current_position.x + last_direction.x, current_position.y + last_direction.y)
	var tile_source_id = tile_map.get_cell_source_id(target_position)
	tile_overlay.visible = true if tile_source_id != 4 else false
	var real_target_position = tile_map.map_to_local(target_position)
	tile_overlay.global_position = real_target_position
	
	
func TileHandle(delta: float):
	fixCollisions()
	breath_time -= delta
	if breath_time > 0:
		return
	var tile_source_id = GetCurrentTileSourceId()
		
	if tile_source_id != 2:
		if self.health > 0:
			self._take_damage(1)#todo back to 5
	else: 
		if self.health > 0:	
			self._take_damage(-15)
	breath_time = BREATH_INTERVAL
	
	if GetCurrentTileSourceId(true) == 4 :
		GameManager.set_movement_speed(2)
	else :
		GameManager.reset_movement_speed()
	
func fixCollisions():
	var disable_colision = false
	var my_coors = tile_map_roads.local_to_map(position)
	for tilemap_layer in tilemap_layers:
		if !tilemap_layer : 
			continue
		var tile_source_id = tilemap_layer.get_cell_source_id(my_coors)
		if tile_source_id == -1:
			continue
		if disable_colision :
			tilemap_layer.get_cell_tile_data(my_coors).set_collision_polygon_points(0, 0, [])
		if tile_source_id != -1:
			disable_colision = true
func GetCurrentTileSourceId(is_road : bool = false):
	var tile_map = getParentTileMap(is_road)
	var current_position = tile_map.local_to_map(position)
	var tile_source_id = tile_map.get_cell_source_id(current_position)
	return tile_source_id

func getParentTileMap(is_road : bool = false) -> TileMapLayer :
	var basic_tile_map = get_parent().get_node("Scene/grass")
	return basic_tile_map if !is_road else get_parent().get_node("Scene/TileMapRoads")
	
func PutRoad():
	if Input.is_action_pressed("Enter") :
		var road_amount = GameManager.road
		if !road_amount:
			return
			
		var tile_map_base : TileMapLayer = get_parent().get_node("Scene/TileMapBase")
		var tile_map : TileMapLayer = get_parent().get_node("Scene/TileMapRoads")
		if tile_map.get_cell_source_id(target_position) == ROADS_SOURCE_ID:
			return
			
		var data : TileData = tile_map_base.get_cell_tile_data(target_position)
		var is_water = data.get_custom_data('is_water')
		if is_water :
			data.set_collision_polygon_points(0, 0, [])
		tile_map.set_cell(target_position, ROADS_SOURCE_ID, Vector2i(0,0))
		GameManager.add_road(-1)
	return
	
func _die():
	super() #calls _die() on base-class CharacterBase
	
	fsm.force_change_state("Die")
	GameManager.load_next_level(load("res://Scenes/Misc/end_game_screen.tscn"))
	#add_child(death_scene)
