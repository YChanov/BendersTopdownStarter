extends PointLight2D

var time_passed = 0
var initial_position := Vector2.ZERO
var amplitude
var frequency
var f_x
var reset_factor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = position
	frequency = randi_range(3, 4)
	f_x = randi_range(3, 4)
	amplitude = randi_range(1, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	var new_y = initial_position.y + amplitude * sin(frequency * time_passed)
	var new_x = initial_position.x + amplitude * sin(f_x * time_passed)
	position.y = new_y
	position.x = new_x
