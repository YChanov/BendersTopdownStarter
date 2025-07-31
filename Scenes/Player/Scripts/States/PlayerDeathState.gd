extends State
class_name die_state

@export var animator : AnimationPlayer
@onready var death_message_label: Label = $"../../DeathMessageLabel"
@onready var player: PlayerMain = $"../.."

func Enter():
	animator.play("Death")
	death_message_label.show()
	await animator.animation_finished
	GameManager.load_same_level()
