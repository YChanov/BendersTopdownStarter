extends StaticBody2D

@onready var dialog: Label = $Dialog
var playerInside = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog.visible = false

var last_time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !playerInside :
		return
		
	if !dialog.visible :
		say_something() 
		
	last_time += delta
	if last_time > 10 :
		last_time = 0
		dialog.visible = false

var dialogs := [
	"Are we there yet honey?",
	"Oh my leg's killing me :(",
	"Did you turned off the lights again honey?",
	"We would not be in this problem if you listen to me",
	"Did you hear about the weather?",
]

func say_something() :
	dialog.text = dialogs[randi() % dialogs.size()]
	dialog.visible = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') :
		playerInside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player') :
		dialog.visible = false
		last_time = 0
		playerInside = false
