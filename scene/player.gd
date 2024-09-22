extends CharacterBody2D


#define the speed & jump velocity
#modify this if want to change movement feel
const SPEED = 120.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 1000
const FALL_GRAVITY = 1350

@onready var player: CharacterBody2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var buffer_jump_timer: Timer = $BufferJumpTimer
@onready var cayote_timer: Timer = $CayoteTimer

var can_buffer_jump = false
var can_cayote_time = false


func process_gravity(velocity: Vector2):
	if velocity.y < 0:
		# going up / jump pressed use normal gravity
		return GRAVITY
	# going down /fall use fall gravity
	return FALL_GRAVITY

# wait until buffer timeout end reset buffer status
func _on_buffer_jump_timer_timeout() -> void:
	can_buffer_jump = false

# wait unitl cayote timout end reset cayote time status
func _on_cayote_timer_timeout() -> void:
	can_cayote_time = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	# check the player is not in floor, and effect player w/ gravity
	# if it on the floor & player dont have status of cayote time it not effected
	if not is_on_floor() && (can_cayote_time == false):
		velocity.y += process_gravity(velocity) * delta
		

	# Handle jump.
	# is action release is when key not pressed again
	# check velocity is 1/3 max jump velocity, set point for more bigger fall velocity
	if Input.is_action_just_released("ui_up") and velocity.y < JUMP_VELOCITY / 3:
		# set velocity bigger to drag player down
		#print("is floor " + str(velocity.y))
		velocity.y = JUMP_VELOCITY / 3
		
	if Input.is_action_just_pressed("ui_up"): 
		#called jump function
		jump()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# check the direction for flipping characters direction
		# right is > 0
	if direction > 0:
		animated_sprite_2d.flip_h = false
		# left is <1
	if direction < 0:
		animated_sprite_2d.flip_h = true
	
	# if direction is 0 / player not moving play idle animation
	# if direction is not zero / player moving play running animation
	# jumping and fall animation depend on the velocity
	if direction != 0 && velocity.y == 0:
		animated_sprite_2d.play("running")
	else:
		animated_sprite_2d.play("idle")
	if velocity.y < 0:
		animated_sprite_2d.play("jump")
	if velocity.y > 0:
		animated_sprite_2d.play("fall")
		#print("current velocity = " +  str(velocity.y))
		
	#Input pushed to right/left, character will start move
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# stored player ground staus before move and slode
	var was_on_floor = is_on_floor()
	
	#start to move body with velocity
	move_and_slide()
	
	# when before is on floor, current not floor and velocity y is positive (down) 
	if was_on_floor && !is_on_floor() && velocity.y >= 0:
		# turn the cayote on when this situation acheived
		if !can_cayote_time:
			#print("Cayote time")
			can_cayote_time = true
			# start timer to reset cayote time status
			cayote_timer.start()
	
	# when the before status is not grounded and current status is grounded
	if !was_on_floor && is_on_floor():
		# if buffer true (0.1s timer waiting)
		# return the buffer to false again
		# execute jump immidate
		if can_buffer_jump:
			#print("Buffered Jump")
			can_buffer_jump = false
			jump()


func jump():
	# check if charcater is grond 
	# cayote time status true = player can jumpt again
	if is_on_floor() || can_cayote_time:
		#print("Player Jumping")
		velocity.y = JUMP_VELOCITY
		# after jump, reset the cayote status again
		if can_cayote_time:
			can_cayote_time = false
	
	# when not ground
	else:
		# check if buffer value is false
		# change to true and start timer unit it reach timout (buffer is false)
		if !can_buffer_jump:
			can_buffer_jump = true
			buffer_jump_timer.start()
