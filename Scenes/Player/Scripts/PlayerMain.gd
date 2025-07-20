extends CharacterBase
class_name PlayerMain

@onready var fsm = $FSM as FiniteStateMachine
const DEATH_SCREEN = preload("res://Scenes/Misc/DeathScreen.tscn")
#All of our logic is either in the CharacterBase class
#or spread out over our states in the finite-state-manager, this class is almost empty 

func _process(delta: float) -> void:
	super._process(delta)
	PutTile()
	
func PutTile():
	if Input.is_action_just_pressed("Enter") :
		var tile_map_layer = 0
		var tile_map : TileMapLayer = get_parent().get_node("Scene/TileMap")
		var cell_source = tile_map.get_cell_source_id(Vector2i(0,0))
		var tile_map_cell_eaposition = Vector2i(4,4)
		var current_position = tile_map.local_to_map(position)
		tile_map.set_cell(current_position, cell_source, tile_map_cell_position)
	return
	
func _die():
	super() #calls _die() on base-class CharacterBase
	
	fsm.force_change_state("Die")
	var death_scene = DEATH_SCREEN.instantiate()
	add_child(death_scene)
