extends CharacterBase
class_name PlayerMain

@onready var fsm = $FSM as FiniteStateMachine
@export var enemy_scene:= preload("res://Scenes/NPC's/Enemy/Enemy.tscn")

@export var tilemap_layers : Array[TileMapLayer] = []
@onready var river: TileMapLayer = $"../Scene/river"

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
	fixYSorting()
	
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
	breath_time -= delta
	if breath_time > 0:
		return
	var tile_source_id = GetCurrentTileSourceId()
		
	if tile_source_id != 2:
		if self.health > 0:
			self._take_damage(5)
	else: 
		if self.health > 0:	
			self._take_damage(-15)
	breath_time = BREATH_INTERVAL
	
	if GetCurrentTileSourceId(true) == 4 :
		GameManager.set_movement_speed(2.0)
	elif river and river.get_cell_source_id(river.local_to_map(position)) != -1 :
		GameManager.set_movement_speed(0.5)
	else :
		GameManager.reset_movement_speed()

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
			
		var tile_map_base : TileMapLayer = get_parent().get_node("Scene/river")
		var tile_map : TileMapLayer = get_parent().get_node("Scene/TileMapRoads")
		if tile_map.get_cell_source_id(target_position) == ROADS_SOURCE_ID:
			return
			
		var data : TileData = tile_map_base.get_cell_tile_data(target_position)
		var is_water = data and data.get_custom_data('is_water')
		if is_water :
			data.set_collision_polygon_points(0, 0, [])
		var direction_placement = target_position - tile_map.local_to_map(position)
		var road = Vector2i(1, 0)
		if direction_placement == Vector2i.UP or direction_placement == Vector2i.DOWN:
			road = Vector2i(0,2)
		tile_map.set_cell(target_position, ROADS_SOURCE_ID, road)
		GameManager.add_road(-1)
	return
	
func _die():
	super() #calls _die() on base-class CharacterBase
	
	fsm.force_change_state("Die")
	GameManager.load_next_level(load("res://Scenes/Misc/end_game_screen.tscn"))
	#add_child(death_scene)

var bodies : Dictionary
func fixYSorting():
	if !bodies.size():
		return
		
	for index in bodies:
		var y_body = bodies[index]
		y_body.z_index = z_index - 1 if y_body.position.y < position.y else z_index + 1
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		return
	if body is StaticBody2D or body is ObstacleBase :
		bodies[body.get_instance_id()] = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	bodies.erase(body.get_instance_id())
