extends KinematicBody

var speed = 10
var h_acceleration = speed
var air_acceleration = 1
var normal_acceleration = speed
var gravity = 50
var jump = 30

var mouse_sensitivity = 0.05

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var head = $Camera_pivot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		
func _physics_process(delta):
	direction = Vector3()
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
	
	var snap = true
	if Input.is_action_just_pressed("space") and (is_on_floor()):
		snap = false
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("z"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("s"):
		direction += transform.basis.z
	if Input.is_action_pressed("q"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("d"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
#	move_and_slide(movement, Vector3.UP, true)
	if (snap == true):
		move_and_slide_with_snap(movement, Vector3.DOWN, Vector3.UP)
	else:
		move_and_slide_with_snap(movement, Vector3.ZERO, Vector3.UP)
