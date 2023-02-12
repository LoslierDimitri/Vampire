extends KinematicBody

onready var CAMERA_PIVOT = get_node("Camera_pivot")
onready var CAMERA = get_node("Camera_pivot/Camera")

onready var POSITION_CAMERA_STAND = get_node("Player_stand/Position_camera_stand")
onready var POSITION_CAMERA_CROUCH = get_node("Player_crouch/Position_camera_crouch")
onready var POSITION_CAMERA_SLIDE = get_node("Player_slide/Position_camera_slide")

onready var COLLISION_STAND = get_node("Collision_stand")
onready var COLLISION_CROUCH = get_node("Collision_crouch")
onready var COLLISION_SLIDE = get_node("Collision_slide")

var input_z = false
var input_q = false
var input_s = false
var input_d = false
var input_space = false
var input_shift = false
var input_c = false

export var mouse_sensitivity = 0.05

var direction = Vector3()
var movement = Vector3()
var gravity_vector = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	CAMERA_PIVOT.global_transform.origin = POSITION_CAMERA_STAND.global_transform.origin
	
	COLLISION_STAND.disabled = false
	COLLISION_CROUCH.disabled = true
	COLLISION_SLIDE.disabled = true

func input():
	if (Input.is_action_pressed("z")):
		input_z = true
	if (Input.is_action_pressed("q")):
		input_q = true
	if (Input.is_action_pressed("s")):
		input_s = true
	if (Input.is_action_pressed("d")):
		input_d = true

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		CAMERA_PIVOT.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		CAMERA_PIVOT.rotation.x = clamp(CAMERA_PIVOT.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	input()
	
	process_movement()
	
	reset()

func process_movement():
	if (input_z == true):
		direction -= transform.basis.z
	if (input_s == true):
		direction += transform.basis.z
	if (input_q == true):
		direction -= transform.basis.x
	if (input_d == true):
		direction += transform.basis.x
	
	direction = direction.normalized()
	movement.x = direction.x * 10
	movement.y = 0
	movement.z = direction.z * 10
	
	move_and_slide_with_snap(movement, Vector3.DOWN, Vector3.UP)

func _physics_process(delta):
	pass

func reset():
	input_z = false
	input_q = false
	input_s = false
	input_d = false
	input_space = false
	input_shift = false
	input_c = false
	
	direction = Vector3()
	movement = Vector3()
