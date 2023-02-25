extends Actor
class_name Player

###################### ENUMS AND STUFF ################################################################################

const FLOOR_DETECT_DISTANCE = 20.0

###################### NODES VARIABLES ################################################################################

onready var platform_detector = $PlatformDetector
onready var collsion_shape = $CollisionShape2D

###################### ACTIONS VARIABLES ################################################################################

var is_jumping = false
var is_gravity_active = true

var is_dead = false
var is_attacking = false

###################### CALLBACK FUNCTIONS ################################################################################


func _ready():
	pass
	

func _physics_process(_delta):
	apply_gravity()
	motion()
	
###################################### MOVEMENT #################################################################################33

func motion():
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		#sound_jump.play()
		is_jumping = true

	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("Jump") and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.ZERO
	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	check_flip(direction)
	
	get_attack()

func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y *= 0.6
	return velocity
	
############################ GET INPUT AND DIRECTION ###############################################################################

func get_direction():
	return Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		-1 if is_grounded() and Input.is_action_just_pressed("Jump") else 0
	)

func get_attack():
	if Input.is_action_just_pressed("Attack"):
		is_attacking = true
	

############################# DAMAGE ##############################################################



############################ OTHER FUNCTIONS ###############################################################################
	
func set_sprite_color(r,g,b,a):
	animated_sprite.modulate = Color(r,g,b,a)

func apply_gravity():
	if is_gravity_active:
		_velocity.y += gravity
	else: _velocity.y = 0

func check_flip(direction):
	if direction.x != 0:
		if direction.x < 0:
			flip(true)
		else:
			flip(false)
	
func flip(fliped):
	animated_sprite.flip_h = fliped
	
func is_grounded():
	return is_on_floor()
