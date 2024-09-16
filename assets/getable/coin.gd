extends Area2D

@onready var player: CharacterBody2D = %Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(player) -> void:
	animation_player.play("CoinPickupAnim")
