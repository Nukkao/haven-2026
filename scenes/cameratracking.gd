extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#var posy = $"../Player".position.y
	#position.y = posy - 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	'''
	var posy = $"../Player".position.y
	var difference = abs(posy - position.y)
	if difference >= 30:
		position.y = -abs(difference -1)
	'''
