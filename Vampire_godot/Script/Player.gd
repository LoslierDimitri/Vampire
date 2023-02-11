extends KinematicBody

###########################################################################
#node
onready var head = get_node("Camera_pivot")

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
export var gravity = 50
var gravity_vec = Vector3()
var snap = Vector3()
export var jump = 30

###########################################################################
#ready
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

###########################################################################
#input
func _input(event):
	###########################################################################
	#input mouse
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

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

###########################################################################
#gravity
func gravity(delta):
	if (is_on_floor() == false):
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
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)

###########################################################################
#process
func _process(delta):
	pass
