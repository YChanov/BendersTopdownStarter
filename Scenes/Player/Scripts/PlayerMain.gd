extends CharacterBase
class_name PlayerMain

@onready var fsm = $FSM as FiniteStateMachine
const DEATH_SCREEN = preload("res://Scenes/Misc/DeathScreen.tscn")
const BREATHABLE_SOURCE_ID = 2

#All of our logic is either in the CharacterBase class
#or spread out over our states in the finite-state-manager, this class is almost empty 

func _process(delta: float) -> void:
	super._process(delta)
	PutTile()
	TileHandle(delta)
	
const BREATH_INTERVAL = 0.5
var breath_time: float = BREATH_INTERVAL
func TileHandle(delta: float):
	breath_time -= delta
	if breath_time > 0:
		return
	var tile_map : TileMapLayer = get_parent().get_node("Scene/TileMap")
	var current_position = tile_map.local_to_map(position)
	var tile_source_id = tile_map.get_cell_source_id(current_position)
	if tile_source_id != 2:
		self._take_damage(5)
		print('breathing')
	else: 
		self._take_damage(-5)
	breath_time = BREATH_INTERVAL
	
func PutTile():
	if Input.is_action_just_pressed("Enter") :
		var slime_amount = GameManager.slime
		if !slime_amount:
			return
			
		var tile_map : TileMapLayer = get_parent().get_node("Scene/TileMap")
		var current_position = tile_map.local_to_map(position)
		if tile_map.get_cell_source_id(current_position) == BREATHABLE_SOURCE_ID:
			return
			
		if !NextToBreathable(tile_map, current_position) :
			return
		var tile_at_position = tile_map.get_cell_atlas_coords(current_position)
		tile_map.set_cell(current_position, BREATHABLE_SOURCE_ID, tile_at_position)
		GameManager.add_slime(-1)
	return
	
func NextToBreathable(tile_map: TileMapLayer, current_position: Vector2i):
	if tile_map.get_cell_source_id(Vector2i(current_position.x - 1, current_position.y)) == BREATHABLE_SOURCE_ID:
		return true
	if tile_map.get_cell_source_id(Vector2i(current_position.x, current_position.y - 1)) == BREATHABLE_SOURCE_ID:
		return true
	if tile_map.get_cell_source_id(Vector2i(current_position.x + 1, current_position.y)) == BREATHABLE_SOURCE_ID:
		return true
	if tile_map.get_cell_source_id(Vector2i(current_position.x, current_position.y + 1)) == BREATHABLE_SOURCE_ID:
		return true
	
	return false
	
func _die():
	super() #calls _die() on base-class CharacterBase
	
	fsm.force_change_state("Die")
	var death_scene = DEATH_SCREEN.instantiate()
	add_child(death_scene)
