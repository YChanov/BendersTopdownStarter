extends Node

@onready var tilemap: TileMapLayer = $"../Generated/TileMap"
@export var tile_area_size := Vector2i(100, 100)

@export var river_tile_coords := [Vector2i(0, 1)]  # River tile coordinates in tileset
@export var river_width := 2  # Width of the river
@export var river_fork_chance := 0.15  # Chance of creating a fork
@export var river_direction_change_chance := 0.1  # Chance of changing direction
const TILE_SET_SOURCE_ID = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_river()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('Restart') :
		generate_river()

func generate_river():
	var area_half := tile_area_size / 2
	var rivers: Array[Dictionary] = []
	
	# Start main river from random position on left edge
	#var start_y = randi_range(-area_half.y + 10, area_half.y - 10)
	#print(-area_half.x + 1,' ',start_y)
	rivers.append({
		"x": -area_half.x + 10,
		"y": area_half.y - 10,
		"direction": Vector2i(1, -1),  # Moving right up
		"active": true
	})
	
	while rivers.size() > 0:
		for i in range(rivers.size() - 1, -1, -1):  # Iterate backwards for safe removal
			var river = rivers[i]
			if not river.active:
				rivers.remove_at(i)
				continue
			
			# Draw river segment
			_draw_river_segment(river.x, river.y)
			
			# Move river forward
			river.x += river.direction.x
			river.y += river.direction.y
			
			# Check if river is out of bounds
			if river.x >= area_half.x or river.x <= -area_half.x or river.y >= area_half.y or river.y <= -area_half.y:
				river.active = false
				continue
			
			# Chance to change direction slightly (mostly straight)
			if randf() < river_direction_change_chance:
				var direction_change = randi_range(-1, 1)
				river.direction.y = clamp(river.direction.y + direction_change, -1, 1)
			
			# Chance to create a fork
			if randf() < river_fork_chance and rivers.size() < 4:  # Limit max forks
				var fork_direction = river.direction
				fork_direction.y += randi_range(-1, 1) * 2  # Fork goes up or down
				fork_direction.y = clamp(fork_direction.y, -1, 1)
				
				rivers.append({
					"x": river.x,
					"y": river.y,
					"direction": fork_direction,
					"active": true
				})

func _draw_river_segment(center_x: int, center_y: int):
	var half_width = river_width / 2
	for w in range(-half_width, half_width + 1):
		var pos = Vector2i(center_x, center_y + w)
		tilemap.set_cell(pos, TILE_SET_SOURCE_ID, river_tile_coords[randi() % river_tile_coords.size()])
