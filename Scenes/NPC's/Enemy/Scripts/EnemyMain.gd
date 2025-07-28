extends CharacterBase
class_name EnemyMain

@onready var fsm = $FSM as FiniteStateMachine
var player_in_range = false
@onready var timer: Timer = $Timer

@export var chase_node : Node
@export var drop : PackedScene
@export var damage := 25

var enemy_in_range = false
var attack_in_cooldown = true

func _process(delta: float) -> void:
	super._process(delta)
	if enemy_in_range and !attack_in_cooldown :
		var player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
		if player.health > 0:
			player._take_damage(damage)
		attack_in_cooldown = true
		timer.start()
	
#After finishing an attack, we return here to determine our next action based on the players proximity
func finished_attacking():
	pass
#Register player proximity, start chasing if we are idling when the player gets close
func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		#We don't want this to happen from the death state, only from idle
		if fsm.current_state.name == "enemy_idle_state": 
			fsm.force_change_state("enemy_chase_state")

#Return to idle when player leaves our proximity
func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		fsm.change_state(chase_node, "enemy_idle_state")
		
func _die():
	super() #calls _die() on base-class CharacterBase
	if drop == null :
		drop = load("res://Scenes/Interactables/Slime.tscn")
	var new_drop = drop.instantiate()
	new_drop.initial_position = position;
	new_drop.position = position;
	get_parent().get_parent().add_child(new_drop)

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemy_in_range = true
		attack_in_cooldown = true
		if fsm.current_state.name == "enemy_chase_state": 
			fsm.change_state(chase_node, "enemy_idle_state")
		timer.start()

func _on_hit_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemy_in_range = false
		if fsm.current_state.name == "enemy_idle_state": 
			fsm.force_change_state("enemy_chase_state")

func _on_timer_timeout() -> void:
	attack_in_cooldown = false
