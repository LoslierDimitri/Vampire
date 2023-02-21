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

onready var NODE_OBJET = get_node("Object")
onready var NODE_ABILITY = get_node("Ability")
onready var RAYCAST = get_node("Camera_pivot/Camera/Raycast")

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

var input_mouse_right = false
var input_mouse_left = false
var input_mouse_wheel_up = false
var input_mouse_wheel_down = false
var input_mouse_wheel_middle = false

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

var object_or_ability_dictionary = {
	1 : "None",
	2 : "Grenade_explosive",
	3 : "Grenade_stun",
	4 : "Mine_explosive",
	5 : "Mine_stun",
	6 : "Gun",
	7 : "Crossbow_bolt",
	8 : "Crossbow_stun",
	9 : "Hacking_tool",
	10 : "Blood_lance",
	11 : "Vampire_vision",
	12 : "Hypnosis",
	13 : "Shadow_form",
	14 : "Blood_link",
}
export var max_object_or_ability = 14
var object_or_ability = 1

export var life_point = 100

##########################################################################
func _ready():
#	INTERFACE_USER.visible = false
	
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
	
	if (Input.is_action_pressed("mouse_left")):
		input_mouse_left = true
	if (Input.is_action_just_pressed("mouse_right")):
		input_mouse_right = true
	if (Input.is_action_pressed("mouse_middle")):
		input_mouse_wheel_middle = true
	if (Input.is_action_just_released("mouse_middle_up")):
		input_mouse_wheel_up = true
	if (Input.is_action_just_released("mouse_middle_down")):
		input_mouse_wheel_down = true

##########################################################################
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		CAMERA_PIVOT.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		CAMERA_PIVOT.rotation.x = clamp(CAMERA_PIVOT.rotation.x, deg2rad(-80), deg2rad(80))
		CAMERA_PIVOT.rotation.y = 0
		CAMERA_PIVOT.rotation.z = 0
	
#	if event.is_pressed():
#		if event.button_index == BUTTON_WHEEL_UP:
#			input_mouse_wheel_up = true
#		if event.button_index == BUTTON_WHEEL_DOWN:
#			input_mouse_wheel_down = true

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
	
#	if (slide_timer == true and input_space_just == true):
#		slide_timer = false
#		TIMER_SLIDE.stop()

##########################################################################
func _physics_process(delta):	
	input()
	
	process_movement(delta)
	
	process_action()
	
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
	
	input_mouse_right = false
	input_mouse_left = false
	input_mouse_wheel_up = false
	input_mouse_wheel_down = false
	input_mouse_wheel_middle = false
	
	direction = Vector3()
	movement = Vector3()
	
	jump_stop = false

##########################################################################
func _on_Area_stand_top_body_entered(body):
	if (body.is_in_group("No_collision") == false):
		jump_stop = true
func _on_Area_stand_top_body_exited(body):
	pass

##########################################################################
func _on_Area_stand_climb_up_body_entered(body):
	if (body.is_in_group("No_collision") == false):
		is_climb_up = true
func _on_Area_stand_climb_up_body_exited(body):
	if (body.is_in_group("No_collision") == false):
		is_climb_up = false

func _on_Area_stand_climb_down_body_entered(body):
	if (body.is_in_group("No_collision") == false):
		is_climb_down = true
func _on_Area_stand_climb_down_body_exited(body):
	if (body.is_in_group("No_collision") == false):
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

##########################################################################
func process_action():
	change_object_or_ability()
	
	var acion_name = ""
	
	if (input_mouse_right == true):
		if (object_or_ability == 1): #None
			acion_name = "None"
		if (object_or_ability == 2): #Grenade_explosive
			acion_name = "Grenade_explosive"
		if (object_or_ability == 3): #Grenade_stun
			acion_name = "Grenade_stun"
		if (object_or_ability == 4): #Mine_explosive
			acion_name = "Mine_explosive"
		if (object_or_ability == 5): #Mine_stun
			acion_name = "Mine_stun"
		if (object_or_ability == 6): #Gun
			acion_name = "Gun"
		if (object_or_ability == 7): #Crossbow_bolt
			acion_name = "Crossbow_bolt"
		if (object_or_ability == 8): #Crossbow_stun
			acion_name = "Crossbow_stun"
		if (object_or_ability == 9): #Hacking_tool
			acion_name = "Hacking_tool"
		if (object_or_ability == 10): #Blood_lance
			acion_name = "Blood_lance"
		if (object_or_ability == 11): #Vampire_vision
			acion_name = "Vampire_vision"
		if (object_or_ability == 12): #Hypnosis
			acion_name = "Hypnosis"
		if (object_or_ability == 13): #Shadow_form
			acion_name = "Shadow_form"
		if (object_or_ability == 14): #Blood_link
			acion_name = "Blood_link"
		
		if (object_or_ability >= 1 and object_or_ability <= 9):
			NODE_OBJET.action(acion_name)
		if (object_or_ability >= 10 and object_or_ability <= 14):
			NODE_ABILITY.action(acion_name)

##########################################################################
func change_object_or_ability():
	if (input_mouse_wheel_up == true or input_mouse_wheel_down == true):
		if (input_mouse_wheel_up == true):
			object_or_ability += 1
			if (object_or_ability > max_object_or_ability):
				object_or_ability = 1
		elif(input_mouse_wheel_down == true):
			object_or_ability -= 1
			if (object_or_ability < 1):
				object_or_ability = max_object_or_ability
		
		print(object_or_ability_dictionary.get(object_or_ability))

##########################################################################
func take_damage(damage, type):
#	print(self.get_instance_id(), ": player take damage")
		if (type == "damage"):
			life_point -= damage
		if (life_point <= 0):
			print("dead")
