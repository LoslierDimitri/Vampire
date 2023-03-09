extends Spatial

##########################################################################
onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")
onready var player_node = main_node.get_node("Player_actual")
onready var parent_node = get_parent()

onready var TIMER_SMALL_TIME = get_node("Timer_small_time")
onready var TIMER_LONG_TIME = get_node("Timer_long_time")

export var timer_small_time = 1
export var timer_long_time = 5

var timer_small_time_done = true
var timer_long_time_done = true

##########################################################################
"""
state machine

all states:
	neutral
	investigation_1
	investigation_2
	combat
	investigation_area

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
var state = ""

var player_node_target
var dead_node_target
var npc_node_target
var alarm_node_target
var explosion_node_target

var player_visible = false

#get data
var player_list = []
var dead_list = []
var npc_list = []

#set data
var target_look_at
var target_pathfinding

##########################################################################
func _ready():
	state = "neutral"
	
	TIMER_SMALL_TIME.set_wait_time(timer_small_time)
	TIMER_LONG_TIME.set_wait_time(timer_long_time)

##########################################################################
#get data required from the npc node (list of detection and so on...)
func get_data():
	player_list = parent_node.player_list
	dead_list = parent_node.dead_list
	npc_list = parent_node.npc_list

##########################################################################
#update data for npc node (target for pathfinding and so on...)
func set_data():
	if (target_pathfinding != null):
		parent_node.target_pathfinding = target_pathfinding
		parent_node.target_look_at = target_look_at
	else:
		parent_node.target_pathfinding = parent_node

##########################################################################
func calcul():
	reset()
	
	get_data()
	
	##########################################################################
	if (state == "neutral"):
		#see player and look at him for a whort period of time
		#if done, go to investigation_1
		#if player no more visible, go to neutral and target look at normal (self for test)
		if (is_node_visible(player_list, "player") == true):
#			state = "investigation_1"
			target_look_at = player_node_target
#			target_pathfinding = parent_node
			target_pathfinding = player_node_target
			if (timer_small_time_done == true):
				TIMER_SMALL_TIME.start()
				timer_small_time_done = false
		#if player is no more done during the timer, if done npc return to neutral state
		if (is_node_visible(player_list, "player") == false):
			if (TIMER_SMALL_TIME.get_time_left() != 0):
				pass
		
		if (is_node_visible(dead_list, "dead") == true):
			state = "investigation_area"
			target_look_at = dead_node_target
			
		if (is_node_visible(npc_list, "npc") == true):
			state = "investigation_area"
			target_look_at = npc_node_target
		
		if (is_alarm_close() == true):
			state = "investigation_area"
			target_pathfinding = alarm_node_target
			target_look_at = alarm_node_target
		
		if (is_explosion_close() == true):
			state = "investigation_area"
			target_look_at = explosion_node_target
			target_pathfinding = explosion_node_target
	
	##########################################################################
	if (state == "investigation_1"):
		if (is_node_visible(player_list, "player") == true):
			state = "investigation_2"
			target_look_at = player_node
			target_pathfinding = player_node
			
		if (is_node_visible(dead_list, "dead") == true):
			state = "investigation_area"
			target_look_at = dead_node_target
			
		if (is_node_visible(npc_list, "npc") == true):
			state = "investigation_area"
			target_look_at = npc_node_target
		
		if (is_alarm_close() == true):
			state = "investigation_area"
			target_pathfinding = alarm_node_target
			target_look_at = alarm_node_target
		
		if (is_explosion_close() == true):
			state = "investigation_area"
			target_look_at = explosion_node_target
			target_pathfinding = explosion_node_target
	
	##########################################################################
	if (state == "investigation_2"):
		pass
	
	##########################################################################
	if (state == "combat"):
		pass
	
	##########################################################################
	if (state == "investigation_area"):
		pass
	
	##########################################################################
	
	set_data()
	
	return state

##########################################################################
func reset():
	timer_small_time_done = false
	timer_long_time_done = false

##########################################################################
func is_node_visible(node_list, type):
#	print("node list: ", node_list)
	for node in node_list:
		var space_state = get_world().direct_space_state
		var vector = node.global_transform.origin - self.global_transform.origin
		var result = space_state.intersect_ray(self.global_transform.origin, vector * 100)
		
		if (result):
#			print("result: ", result.collider)
#			print("node: ", node)
			if (result.collider == node):
				if (node.is_in_group("Player") and type == "player"):
					player_node_target = node
					return true
				if (node.is_in_group("Dead") and type == "dead"):
					dead_node_target = node
					return true
				if (node.is_in_group("Npc") and type == "npc"):
					npc_node_target = node
					return true
				
	return false

##########################################################################
func is_alarm_close():
	pass

##########################################################################
func is_explosion_close():
	pass

##########################################################################
func is_target_reachable():
	pass

##########################################################################
#small time
func _on_Timer_small_time_timeout():
	timer_small_time_done = true
#long time
func _on_Timer_long_time_timeout():
	timer_long_time_done = true
