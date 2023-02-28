extends MeshInstance

"""
description of each frame:
	initialise npc_node from map
	initialise npc_list to []
	initialise npc_dict to {}
	
	fill npc_dict with all npc and distance to model
	
	for the number of max target:
		for each node in dict:
			get closest node
		remove the node from dict
		fill npc_list
	
	hypnose npc_list target
"""

onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")

onready var TIMER = get_node("Timer")
onready var TIMER_RESET = get_node("Timer_reset")

var timer
var timer_reset

var npc_list = []
var npc_dict = {}
var npc_max_hypnosis
var range_effective_hypnosis

var npc_foe_node
var npc_neutral_node

func _ready():
	TIMER.set_wait_time(timer)
	TIMER.start()
	TIMER_RESET.set_wait_time(timer_reset)
	TIMER_RESET.start()
	hypnosis()

func hypnosis():
	npc_foe_node = map_node.get_node("Npc_foe")
	npc_neutral_node = map_node.get_node("Npc_neutral")
	reset_hypnosis()
	
	npc_list = []
	npc_dict = {}
	
	initialise_dict()
	
	for i in npc_max_hypnosis:
		var node_test
		var distance_test
		var close_node
		var close_distance = 1000
		
		for node in npc_dict:
			node_test = node
			distance_test = npc_dict[node]
			
			if (distance_test < close_distance):
				close_distance = distance_test
				close_node = node_test
		
		npc_list.append(close_node)
		npc_dict.erase(close_node)
	
	for node in npc_list:
		if (node.global_transform.origin.distance_to(self.global_transform.origin) < range_effective_hypnosis):
			node.take_hypnose()

func initialise_dict():
	for node in npc_foe_node.get_children():
		npc_dict[node] = node.global_transform.origin.distance_to(self.global_transform.origin)
	for node in npc_neutral_node.get_children():
		npc_dict[node] = node.global_transform.origin.distance_to(self.global_transform.origin)

func _on_Timer_timeout():
	reset_hypnosis()
	queue_free()

func _on_Timer_reset_timeout():
	TIMER_RESET.start()
	hypnosis()

func reset_hypnosis():
	for node in npc_foe_node.get_children():
		node.reset_hypnosis()
	for node in npc_neutral_node.get_children():
		node.reset_hypnosis()
