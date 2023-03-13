extends Spatial

##########################################################################
onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")
onready var player_node = main_node.get_node("Player_actual")
onready var player_node_last_position = map_node.get_node("Player_last_position")
onready var parent_node = get_parent()

onready var NEUTRAL_STATE = get_node("Neutral")
onready var INVESTIGATION_1_STATE = get_node("Investigation_1")
onready var COMBAT_STATE = get_node("Combat")
onready var FLEE_STATE = get_node("Flee")

##########################################################################
"""
state machine

all states:
	neutral
	investigation_1
	investigation_2
	investigation_area
	combat

all conditions:
	player visible for short time
	player visible
	player not visible for short time
	player not visible for long time
	body detection
	sound detection
	another ai without neutral state
	
	no alarm and close
	no alaem and distant
	alarm
	no alarm and distant but movement possible

actions:
	fight
	use alarm
	distant fight
	movement to player
"""

##########################################################################
var state = "neutral"

var player_list = []
var dead_list = []
var npc_list = []
var sound_list = []

var dead_list_from_map

var target_pathfinding
var target_look_at

var target_player
var target_dead
var target_npc
var target_player_last_position

export var max_range_target_dead = 50

##########################################################################
func change_state(new_state):
	state = new_state

func get_data():
	player_node = main_node.get_node("Player_actual")
	player_node_last_position = map_node.player_node_last_position
	
	player_list = parent_node.player_list
	dead_list = parent_node.dead_list
	npc_list = parent_node.npc_list
	sound_list = parent_node.sound_list
	
	dead_list_from_map = map_node.get_node("Dead")

func set_data():
	if (target_pathfinding != null):
		parent_node.target_pathfinding = target_pathfinding
	if (target_look_at != null):
		parent_node.target_look_at = target_look_at

##########################################################################
func calcul():
	get_data()
	
	if (state == "neutral"):
		NEUTRAL_STATE.calcul()
	if (state == "investigation_1"):
		INVESTIGATION_1_STATE.calcul()
	if (state == "combat"):
		COMBAT_STATE.calcul()
	if (state == "flee"):
		FLEE_STATE.calcul()
	
	if (parent_node.is_take_damage == true):
		if (parent_node.npc_stame_machine_can_attack == true):
			state = "combat"
		else:
			state = "flee"
			#flee node
			"""
			select a node randomly from pathfindinf_flee from parent_node
			set pathfinding_target_node to path_flee_node
			set look_at_target_node to path_flee_node
			"""
			var map_node_flee = parent_node.PATHFINDING_FLEE
			var nb_map_node_flee = map_node_flee.get_child_count()
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var index_pathfinding_node = rng.randf_range(0, nb_map_node_flee)
			target_pathfinding = map_node_flee.get_child(index_pathfinding_node)
			target_look_at = map_node_flee.get_child(index_pathfinding_node)
	
	set_data()

##########################################################################
func is_node_visible(node_list, type):
	for node in node_list:
		var space_state = get_world().direct_space_state
		var vector = node.global_transform.origin - parent_node.global_transform.origin
#		var intersect_ray = vector.normalized() * 50
		var result = space_state.intersect_ray(parent_node.global_transform.origin, node.global_transform.origin)
		if (result):
			if (result.collider == node):
				if (type == "player"):
					map_node.update_player_last_position()
					target_player = map_node.player_node_last_position
#				if (type == "dead"):
#					target_dead = node
				if (type == "npc"):
					target_npc = node
				return true
	
	if (type == "dead"):
		for node in dead_list_from_map.get_children():
			node.get_node("Collision").disabled = false
			var space_state = get_world().direct_space_state
			var vector = node.global_transform.origin - parent_node.global_transform.origin
			var result = space_state.intersect_ray(parent_node.global_transform.origin, node.global_transform.origin)
			node.get_node("Collision").disabled = true
			if (result):
				if (result.collider == node):
					if (parent_node.NAVIGATION_AGENT.get_distance(node) <= max_range_target_dead):
#					if (result.collider.global_transform.origin.distance_to(node.global_transform.origin) <= 20):
						target_dead = node
						return true
#			node.get_node("Collision").disabled = true
	return false
