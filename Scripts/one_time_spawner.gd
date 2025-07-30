extends ObstacleBase
class_name Spawner

@export var enemy_to_spawn : PackedScene
@export var one_time := true
@export var spawn_range := 200
@export var enemies_limit := 3
@export var wait_time := 10
@onready var timer: Timer = $Timer
@onready var enemies: Node = $Enemies

var can_spawn = true

var playerInside := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playerInside :
		spawnEnemy()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = false
		
func spawnEnemy() -> void :
	if !can_spawn :
		return
	
	if enemies.get_child_count() >= enemies_limit :
		can_spawn = false
		if !one_time:
			timer.start()
		return
	
	if !enemy_to_spawn :
		enemy_to_spawn = load("res://Scenes/NPC's/Enemy/Enemy.tscn")
	
	var enemy_instance = enemy_to_spawn.instantiate()
	var target_position = global_position
	target_position = target_position + Vector2(randi_range(-spawn_range,spawn_range), randi_range(-spawn_range,spawn_range))
	
	spawnInPosition(enemy_instance, target_position)
	
	can_spawn = false
	if !one_time:
		timer.start()
	
func spawnInPosition(instance: Node, position : Vector2):
	instance.global_position = position
	enemies.add_child(instance)


func _on_timer_timeout() -> void:
	can_spawn = true
