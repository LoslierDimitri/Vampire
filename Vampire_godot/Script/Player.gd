extends KinematicBody

##########################################################################
#load node of the instance
onready var CAMERA_PIVOT = get_node("Camera_pivot")
onready var CAMERA = get_node("Camera_pivot/Camera")

onready var POSITION_CAMERA_STAND = get_node("Player_stand/Position_camera_stand")
onready var POSITION_CAMERA_CROUCH = get_node("Player_crouch/Position_camera_crouch")
onready var POSITION_CAMERA_SLIDE = get_node("Player_slide/Position_camera_slide")

onready var COLLISION_STAND = get_node("Collision_stand")
onready var COLLISION_CROUCH = get_node("Collision_crouch")
onready var COLLISION_SLIDE = get_node("Collision_slide")

onready var TIMER_CLIMB = get_node("Player_stand/Timer_climb")
onready var TIMER_SLIDE = get_node("Player_slide/Timer_slide")

##########################################################################
#input variable
var input_z = false
var input_q = false
var input_s = false
var input_d = false
var input_space = false
var input_shift = false
var input_space_just = false
var input_c = false
var input_c_just = false

##########################################################################
#parameters
export var mouse_sensitivity = 0.05

##########################################################################
#variables
var direction = Vector3()
var movement = Vector3()
var climb_movement = Vector3()
var slide_movement = Vector3()

var gravity_vector = Vector3()
var gravity = 30
var snap_vector = Vector3()

var speed_actual = 0
export var speed_walk = 10
export var speed_run = 30
export var speed_crouch = 5
export var speed_slide = 15

export var jump = 20
var jump_stop = false

var is_climb_up = false
var is_climb_down = false
var climb_timer = false
var timer_climb_value_actual = 0
export var timer_climb_normal = 1
export var timer_climb_normal_value = 2
export var timer_climb_fast = 0.5
export var timer_climb_fast_value = 4

var is_crouch = false

var is_slide = false
var slide_timer = false
export var timer_slide_normal = 1
export var timer_slide_long = 2

##########################################################################
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	CAMERA_PIVOT.global_transform.origin = POSITION_CAMERA_STAND.global_transform.origin
	
	COLLISION_STAND.disabled = false
	COLLISION_CROUCH.disabled = true
	COLLISION_SLIDE.disabled = true
	
#	TIMER_CLIMB.wait_time = timer_climb_normal
#	timer_climb_value_actual = timer_climb_normal_value
	TIMER_CLIMB.wait_time = timer_climb_fast
	timer_climb_value_actual = timer_climb_fast_value
	
	TIMER_SLIDE.wait_time = timer_slide_normal
#	TIMER_SLIDE.wait_time = timer_slide_long

##########################################################################
func input():
	if (Input.is_action_pressed("z")):
		input_z = true
	if (Input.is_action_pressed("q")):
		input_q = true
	if (Input.is_action_pressed("s")):
		input_s = true
	if (Input.is_action_pressed("d")):
		input_d = true
	
	if (Input.is_action_pressed("shift")):
		input_shift = true
	
	if (Input.is_action_pressed("space")):
		input_space = true
	if (Input.is_action_just_pressed("space")):
		input_space_just = true
	
	if (Input.is_action_pressed("c")):
		input_c = true
	if (Input.is_action_just_pressed("c")):
		input_c_just = true

##########################################################################
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		CAMERA_PIVOT.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		CAMERA_PIVOT.rotation.x = clamp(CAMERA_PIVOT.rotation.x, deg2rad(-89), deg2rad(89))

##########################################################################
func process_movement(delta):
	if (input_z == true):
		direction -= transform.basis.z
	if (input_s == true):
		direction += transform.basis.z
	if (input_q == true):
		direction -= transform.basis.x
	if (input_d == true):
		direction += transform.basis.x
	
	if (input_c_just == true):
		is_crouch = not is_crouch
	
	speed_actual = speed_walk
	if (input_shift == true and input_z == true):
		speed_actual = speed_run
	if (is_crouch == true):
		speed_actual = speed_crouch
	
	if (is_crouch == true and input_z == true and input_shift == true):
		is_crouch = false
	
	if (jump_stop == true):
		gravity_vector = Vector3()
	if (input_space_just == true and is_on_floor() == true):
		gravity_vector = Vector3.UP * jump
		snap_vector = Vector3.ZERO
	elif (is_on_floor() == false):
		gravity_vector += Vector3.DOWN * gravity * delta
		snap_vector = Vector3.DOWN
	else:
		gravity_vector = -get_floor_normal()
		snap_vector = -get_floor_normal()
	
	direction = direction.normalized()
	movement.x = direction.x * speed_actual + gravity_vector.x
	movement.z = direction.z * speed_actual + gravity_vector.z
	movement.y = gravity_vector.y
	
	if (climb_timer == false):
		if (is_crouch == true):
			COLLISION_STAND.disabled = true
			COLLISION_CROUCH.disabled = false
			COLLISION_SLIDE.disabled = true
			CAMERA_PIVOT.global_transform.origin = POSITION_CAMERA_CROUCH.global_transform.origin
		elif (is_slide == true):
			COLLISION_STAND.disabled = true
			COLLISION_CROUCH.disabled = true
			COLLISION_SLIDE.disabled = false
			CAMERA_PIVOT.global_transform.origin = POSITION_CAMERA_SLIDE.global_transform.origin
		else:
			COLLISION_STAND.disabled = false
			COLLISION_CROUCH.disabled = true
			COLLISION_SLIDE.disabled = true
			CAMERA_PIVOT.global_transform.origin = POSITION_CAMERA_STAND.global_transform.origin
	
	if (is_climb_up == false and is_climb_down == true):
		if (input_z == true and input_space == true):
			if (climb_timer == false):
				var climb_movement_x = direction.x * timer_climb_value_actual
				var climb_movement_y = timer_climb_value_actual
				var climb_movement_z = direction.z * timer_climb_value_actual
				climb_movement = Vector3(climb_movement_x, climb_movement_y, climb_movement_z)
				TIMER_CLIMB.start()
				COLLISION_STAND.disabled = true
				COLLISION_CROUCH.disabled = true
				COLLISION_SLIDE.disabled = true
				climb_timer = true
	
	if (input_z == true and input_c_just == true and input_shift == true):
		var slide_movement_x = direction.x
		var slide_movement_y = gravity_vector.y
		var slide_movement_z = direction.z
		slide_movement = Vector3(slide_movement_x, slide_movement_y, slide_movement_z) * speed_slide
		is_slide = true
		TIMER_SLIDE.start()
		slide_timer = true
	
	if (climb_timer == true):
		movement = climb_movement
	elif (slide_timer == true):
		movement = slide_movement
	
	if (slide_timer == true and input_space_just == true):
		slide_timer = false
		TIMER_SLIDE.stop()

##########################################################################
func _physics_process(delta):
	input()
	
	process_movement(delta)
	
	move_and_slide_with_snap(movement, snap_vector, Vector3.UP)
	
	reset()

##########################################################################
func reset():
	input_z = false
	input_q = false
	input_s = false
	input_d = false
	input_space = false
	input_space_just = false
	input_shift = false
	input_c = false
	input_c_just = false
	
	direction = Vector3()
	movement = Vector3()
	
	jump_stop = false

##########################################################################
func _on_Area_stand_top_body_entered(body):
	jump_stop = true
func _on_Area_stand_top_body_exited(body):
	pass

##########################################################################
func _on_Area_stand_climb_up_body_entered(body):
	is_climb_up = true
func _on_Area_stand_climb_up_body_exited(body):
	is_climb_up = false

func _on_Area_stand_climb_down_body_entered(body):
	is_climb_down = true
func _on_Area_stand_climb_down_body_exited(body):
	is_climb_down = false

##########################################################################
func _on_Timer_climb_timeout():
	COLLISION_STAND.disabled = false
	COLLISION_CROUCH.disabled = false
	COLLISION_SLIDE.disabled = false
	climb_timer = false

##########################################################################
func _on_Timer_slide_timeout():
	slide_timer = false
	is_slide = false
