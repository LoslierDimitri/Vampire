extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")
onready var player_node = main_node.get_node("Player_actual")

onready var TIMER = get_node("Timer")

export var timer_time = 5

var player_stand_collision
var player_stand_camera_position
var player_crouch_collision
var player_crouch_camera_position
var player_slide_collision
var player_slide_camera_position
var player_shadow_form_collision
var player_shadow_form_camera_position

var player_actual_position

func _ready():
	player_stand_collision = player_node.get_node("Collision_stand")
	player_stand_camera_position = player_node.get_node("Player_stand").get_node("Position_camera_stand")
	player_crouch_collision = player_node.get_node("Collision_crouch")
	player_crouch_camera_position = player_node.get_node("Player_crouch").get_node("Position_camera_crouch")
	player_slide_collision = player_node.get_node("Collision_slide")
	player_slide_camera_position = player_node.get_node("Player_slide").get_node("Position_camera_slide")
	player_shadow_form_collision = player_node.get_node("Collision_shadow_form")
	player_shadow_form_camera_position = player_node.get_node("Player_shadow_form").get_node("Position_camera_shadow_form")
	
	TIMER.set_wait_time(timer_time)

func shadow_form(form):
	if (form == true):
		TIMER.start()
		player_node.is_shadow_form = true
		get_parent().shadow_form_active = true
	else:
		player_node.is_shadow_form = false
		player_node.is_shadow_form_end = true
		get_parent().shadow_form_active = false

func _on_Timer_timeout():
	shadow_form(false)
	TIMER.stop()
