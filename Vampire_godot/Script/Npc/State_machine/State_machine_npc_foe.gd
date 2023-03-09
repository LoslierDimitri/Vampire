extends Spatial

##########################################################################
onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")
onready var player_node = main_node.get_node("Player_actual")
onready var parent_node = get_parent()

onready var NEUTRAL_STATE = get_node("Neutral")
onready var INVESTIGATION_1_STATE = get_node("Investigation_1")
onready var INVESTIGATION_2_STATE = get_node("Investigation_2")
onready var INVESTIGATION_AREA_STATE = get_node("Investigation_area")
onready var COMBAT_STATE = get_node("Combat")

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

var target_pathfinding
var target_look_at

##########################################################################
func change_state(new_state):
	state = new_state

func get_data():
	player_node = main_node.get_node("Player_actual")
	
	player_list = parent_node.player_list
	dead_list = parent_node.dead_list
	npc_list = parent_node.npc_list
	sound_list = parent_node.sound_list

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
	if (state == "investigation_2"):
		INVESTIGATION_2_STATE.calcul()
	if (state == "investigation_area"):
		pass
	if (state == "combat"):
		COMBAT_STATE.calcul()
	
	set_data()
	
	#a retirer
	set_text_to_print()

##########################################################################
func is_node_visible(node_list, type):
	for node in node_list:
		var space_state = get_world().direct_space_state
		var vector = node.global_transform.origin - self.global_transform.origin
		var result = space_state.intersect_ray(self.global_transform.origin, vector * 100)
		if (result):
			if (result.collider == node):
				if (type == "player"):
					pass
				if (type == "dead"):
					pass
				if (type == "npc"):
					pass
				return true
	return false

#a retirer
var text_to_print = ""
func set_text_to_print():
	text_to_print = ""
	if (state == "neutral"):
		text_to_print += str("is_player_visible: ", NEUTRAL_STATE.is_player_visible)
	if (state == "investigation_1"):
		text_to_print += str("is_player_visible: ", INVESTIGATION_1_STATE.is_player_visible)
	if (state == "investigation_2"):
		text_to_print += str("is_player_visible: ", INVESTIGATION_2_STATE.is_player_visible)
	if (state == "investigation_area"):
		pass
	if (state == "combat"):
		text_to_print += str("is_player_visible: ", COMBAT_STATE.is_player_visible)
