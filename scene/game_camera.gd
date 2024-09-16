extends Camera2D

# variable that contain vector (x, y)
# zero = (0,0)
var target_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# it will continously get player position
	acquire_target()
	# made the camera position change with lerp calculation
	#COMMMENT FOR NOW
	#global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 500))
	global_position = target_position


# function to get player position from vector
func acquire_target():
	# will return array in Main tree, that grouped as "player"
	var player_nodes = get_tree().get_nodes_in_group("player")
	# if the player is available / not 0
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		# assign the player position to target position
		target_position = player.global_position
