extends KinematicBody

onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")
var player_node

##########################################################################
onready var NAVIGATION_AGENT = get_node("Navigation_follow")
onready var STATE_MACHINE = get_node("State_machine_npc_neutral")
onready var BLOOD_LINK = get_node("Blood_link")
onready var DEAD = load("res://Npc/Npc_neutral/Npc_neutral_01_dead.tscn")
onready var PATHFINDING_FLEE = map_node.get_node("Pathfinding_flee")

##########################################################################
var direction = Vector3()

export var speed_walk = 5
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

export var pathfinding_neutral = "Pathfinding_00"
var pathfinding_neutral_list = []
var pathfinding_neutral_target
var is_pathfinding_neutral_close = false
var max_rage_pathfinding_neutral_close = 5
var index = 0
var index_max

export var npc_stame_machine_can_attack = false

##########################################################################
func _ready():
	if (map_node.get_node("Pathfinding_neutral").get_node(pathfinding_neutral).get_child_count() > 0):
		pathfinding_neutral_list = map_node.get_node("Pathfinding_neutral").get_node(pathfinding_neutral).get_children()
		pathfinding_neutral_target = pathfinding_neutral_list[0]
		index_max = pathfinding_neutral_list.size()

##########################################################################
func _physics_process(delta):
	STATE_MACHINE.calcul()
	if (map_node.get_node("Pathfinding_neutral").get_node(pathfinding_neutral).get_child_count() > 0):
		pathfinding_neutral_list = map_node.get_node("Pathfinding_neutral").get_node(pathfinding_neutral).get_children()
	
	if (STATE_MACHINE.state != "neutral"):
		direction = NAVIGATION_AGENT.pathfinding(target_pathfinding, delta)
	if (STATE_MACHINE.state == "neutral" and pathfinding_neutral != "Pathfinding_00"):
		target_pathfinding = pathfinding_neutral_target
		if (pathfinding_neutral_target.global_transform.origin.distance_to(self.global_transform.origin) <= max_rage_pathfinding_neutral_close):
			pathfinding_neutral_target = pathfinding_neutral_list[index]
			index = index + 1
			if (index == index_max):
				index = 0
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
	direction = direction.normalized()
	if (is_hypnosis == true):
		speed_actual = speed_stop
	else:
		speed_actual = speed_walk
	
	direction = direction * speed_actual
	if (direction != null):
		if (target_reachable == true and target_close == false):
#			move_and_collide(direction)
			move_and_slide(direction, Vector3.UP)

##########################################################################
func reset():
	direction = Vector3()
	
	is_take_damage = false
	
	player_node = main_node.get_node("Player_actual")
	blood_link_node = player_node.get_node("Ability").get_node("blood_link")
	blood_link_list = player_node.get_node("Ability").get_node("blood_link").blood_link_list

##########################################################################
func take_damage(damage, type):
	if (is_blood_link == true):
		for node in blood_link_list:
			if (type == "damage"):
				is_take_damage = true
				node.life_point -= damage
				if (node.life_point <= 0):
					var dead_instance = node.DEAD.instance()
					dead_instance.global_transform.origin = node.global_transform.origin
					map_node.get_node("Dead").add_child(dead_instance)
					node.queue_free()
				
			if (type == "stun"):
				node.stun_point -= damage
				if (node.stun_point <= 0):
					print("stun")
	else:
		if (type == "damage"):
			is_take_damage = true
			life_point -= damage
			if (life_point <= 0):
				var blood_lance = get_node("blood_lance")
				if (blood_lance != null):
					player_node.get_node("Ability").can_teleport = false
				var dead_instance = DEAD.instance()
				dead_instance.global_transform.origin = self.global_transform.origin
				map_node.get_node("Dead").add_child(dead_instance)
				queue_free()
		if (type == "stun"):
			stun_point -= damage
			if (stun_point <= 0):
				print("stun")

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
