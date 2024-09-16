extends Area2D

#on ready is to get fixed other node in the same tree
#export let developer to choose which node want to be input to script
@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = %Player

# when player have collision with the killzone
func _on_body_entered(player) -> void:
	print("GAME OVER!!!")
	# slow the time by a half
	Engine.time_scale = 0.5
	# remove node (player) from scene
	player.queue_free()
	# timer given signal to start counting
	timer.start()


# when time waiting duration is over 
func _on_timer_timeout() -> void:
	print("GAME RESET!!!")
	# return time normally
	Engine.time_scale = 1.0
	# reload the scene from beginning
	get_tree().reload_current_scene()
