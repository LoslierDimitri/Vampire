extends KinematicBody

onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")
var player_node

##########################################################################
onready var NAVIGATION_AGENT = get_node("Navigation_follow")
onready var STATE_MACHINE = get_node("State_machine_npc_neutral")
onready var BLOOD_LINK = get_node("Blood_link")
onready var DEAD = load("res://Npc/Npc_neutral/Npc_neutral_01_dead.tscn")

##########################################################################
var direction = Vector3()

export var wpeed_walk = 5
export var speed_run = 10
export var speed_stop = 0
var speed_actual = 5

var target_pathfinding
var target_reachable = false
var target_close = false

var target_look_at

export var life_point = 100
export var stun_point = 2
var is_take_damage = false

var is_player_in_area_attack_zone = false
export var damage = 10
export var type = "damage"
var can_attack_timer = true

var is_hypnosis = false

var is_blood_link = false
var blood_link_list = []
var blood_link_node

var player_list = []
var dead_list = []
var npc_list = []
var sound_list = []

##########################################################################
func _ready():
	pass

##########################################################################
func _physics_process(delta):
	STATE_MACHINE.calcul()
	direction = NAVIGATION_AGENT.pathfinding(target_pathfinding, delta)
	
	process_action()
	
	movement()
	
	reset()

##########################################################################
func process_action():
	if (target_pathfinding != null):
		var look_at_vector = target_pathfinding.global_transform.origin - direction
		look_at_vector.y = global_transform.origin.y
		look_at(look_at_vector, Vector3.UP)
	if (target_look_at != null):
		var look_at_vector = target_look_at.global_transform.origin - direction
		look_at_vector.y = global_transform.origin.y
		look_at(look_at_vector, Vector3.UP)
	
	if (is_blood_link == true):
		BLOOD_LINK.visible = true
	else:
		BLOOD_LINK.visible = false

##########################################################################
func movement():
	if (is_hypnosis == true):
		speed_actual = speed_stop
	
	direction = direction * speed_actual
	if (direction != null):
		if (target_reachable == true and target_close == false):
			move_and_collide(direction)

##########################################################################
func reset():
	direction = Vector3()
	
	is_take_damage = false
	
	player_node = main_node.get_node("Player_actual")
	blood_link_node = player_node.get_node("Ability").get_node("blood_link")
	blood_link_list = player_node.get_node("Ability").get_node("blood_link").blood_link_list

##########################################################################
func take_damage(damage, type):
	pass

##########################################################################
func take_hypnose():
	is_hypnosis = true
func reset_hypnosis():
	is_hypnosis = false

##########################################################################
func _on_Area_detection_body_entered(body):
	if (body.is_in_group("Player")):
		player_list.append(body)
	if (body.is_in_group("Dead")):
		dead_list.append(body)
	if (body.is_in_group("Npc")):
		npc_list.append(body)
func _on_Area_detection_body_exited(body):
	if (body.is_in_group("Player")):
		player_list.erase(body)
	if (body.is_in_group("Dead")):
		dead_list.erase(body)
	if (body.is_in_group("Npc")):
		npc_list.erase(body)
