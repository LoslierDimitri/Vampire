extends KinematicBody

###########################################################################
#node
onready var CAMERA_PIVOT = get_node("Camera_pivot")
onready var CAMERA_POSITION_UP = get_node("Position_camera_stand")
onready var CAMERA_POSITION_DOWN = get_node("Position_camera_crouch")
onready var COLLISION_STAND = get_node("Collision_stand")
onready var COLLSION_CROUCH = get_node("Collision_crouch")
onready var TIMER_CLIMB = get_node("Timer_climb")

###########################################################################
#parameter
export var mouse_sensitivity = 0.05

###########################################################################
#movement
var direction = Vector3()
var movement = Vector3()

var speed_actual = 0
export var speed_walk = 10
export var speed_run = 30
export var speed_crouch = 5

export var gravity = 50
var gravity_vec = Vector3()
var snap = Vector3()
export var jump = 30
var stop_jump = false

var is_climb_up = false
var is_climb_down = false
var is_climb = false
var climb_direction = Vector3()
var climb_timer = false
var timer_climb_time_value = 0
export var timer_climb_time_normal = 1
export var timer_climb_time_normal_value = 2
export var timer_climb_time_fast = 0.5
export var timer_climb_time_fast_value = 4

var is_crouch = false
var is_crouch_top = false

###########################################################################
#ready
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_parameter()

###########################################################################
#parameter change
func update_parameter():
	TIMER_CLIMB.wait_time = timer_climb_time_normal
	timer_climb_time_value = timer_climb_time_normal_value
#	TIMER_CLIMB.wait_time = timer_climb_time_fast
#	timer_climb_time_value = timer_climb_time_fast_value
	
#	COLLISION_STAND.disabled = false
	COLLSION_CROUCH.disabled = true

###########################################################################
#input
func _input(event):
	###########################################################################
	#input mouse
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		CAMERA_PIVOT.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		CAMERA_PIVOT.rotation.x = clamp(CAMERA_PIVOT.rotation.x, deg2rad(-89), deg2rad(89))

###########################################################################
#input movement
func input_movement():
	###########################################################################
	#jump
	snap = Vector3.DOWN
	if Input.is_action_just_pressed("space") and (is_on_floor()):
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	###########################################################################
	#climb
	if (Input.is_action_pressed("space")):
		is_climb = true
	
	###########################################################################
	#movement
	if Input.is_action_pressed("z"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("s"):
		direction += transform.basis.z
	if Input.is_action_pressed("q"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("d"):
		direction += transform.basis.x
	
	###########################################################################
	#run
	speed_actual = speed_walk
	if (Input.is_action_pressed("shift")):
		speed_actual = speed_run
	if (is_crouch == true):
		speed_actual = speed_crouch
	
	###########################################################################
	#crouch
	if (Input.is_action_just_pressed("c") and is_crouch_top == false):
		is_crouch = not is_crouch
		COLLISION_STAND.disabled = false

###########################################################################
#gravity
func gravity(delta):
	if (is_on_floor() == false):
		if (stop_jump == true):
			gravity_vec = Vector3()
		gravity_vec += Vector3.DOWN * gravity * delta
	else:
		gravity_vec = -get_floor_normal()

###########################################################################
#physic process
func _physics_process(delta):
	direction = Vector3()
	
	###########################################################################
	#movement
	gravity(delta)
	input_movement()
	
	direction = direction.normalized()
	movement.x = direction.x * speed_actual + gravity_vec.x
	movement.z = direction.z * speed_actual + gravity_vec.z
	movement.y = gravity_vec.y
	
	###########################################################################
	#climb
	if (is_climb_up == false and is_climb_down == true and Input.is_action_pressed("z") and climb_timer == false):
		if (is_climb == true):
			climb_direction = Vector3(direction.x * timer_climb_time_value, timer_climb_time_value, direction.z * timer_climb_time_value)
			TIMER_CLIMB.start()
			COLLISION_STAND.disabled = true
			climb_timer = true
	
	###########################################################################
	#movement calcul
	if (climb_timer == true):
		movement = climb_direction
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	
	reset()

###########################################################################
#process
func _process(delta):
	if (is_crouch == true):
		COLLISION_STAND.disabled = true
		COLLSION_CROUCH.disabled = false
		CAMERA_PIVOT.global_transform.origin = CAMERA_POSITION_DOWN.global_transform.origin
	else:
#		COLLISION_STAND.disabled = false
		COLLSION_CROUCH.disabled = true
		CAMERA_PIVOT.global_transform.origin = CAMERA_POSITION_UP.global_transform.origin

###########################################################################
#reset
func reset():
	stop_jump = false

###########################################################################
#top stop jump
func _on_Area_top_body_entered(body):
	stop_jump = true
func _on_Area_top_body_exited(body):
	pass

###########################################################################
#climb
func _on_Area_climb_up_body_entered(body):
	is_climb_up = true
func _on_Area_climb_up_body_exited(body):
	is_climb_up = false

func _on_Area_climb_down_body_entered(body):
	is_climb_down = true
func _on_Area_climb_down_body_exited(body):
	is_climb_down = false

###########################################################################
#timer climb
func _on_Timer_climb_timeout():
	climb_timer = false
	COLLISION_STAND.disabled = false

###########################################################################
#crouch top verification
func _on_Area_crouch_top_body_entered(body):
	is_crouch_top = true
func _on_Area_crouch_top_body_exited(body):
	is_crouch_top = false
