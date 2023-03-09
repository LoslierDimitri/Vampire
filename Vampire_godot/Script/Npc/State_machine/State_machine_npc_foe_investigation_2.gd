extends Spatial

onready var state_node = get_parent()

onready var TIMER_SMALL_VISIBLE = get_node("Timer_small_time_visible")
onready var TIMER_SMALL_NO_VISIBLE = get_node("Timer_small_time_no_visible")

var player_list = []
var dead_list = []
var npc_list = []
var sound_list = []

var is_player_visible = false
var is_timer_done = false

var look_at_target
var pathfinding_target

func get_data():
	player_list = state_node.player_list
	dead_list = state_node.dead_list
	npc_list = state_node.npc_list
	sound_list = state_node.sound_list

func set_data():
	if (look_at_target != null):
		state_node.target_look_at = look_at_target
	if (pathfinding_target != null):
		state_node.target_pathfinding = pathfinding_target

##########################################################################
func calcul():
	get_data()
	
	#player detection
	"""
	change look_at_target
	
	si joueur visible
		lance timer une fois
		joueur visible true
	si joueur non visible
		lance timer une fois
		joueur visible false
	si joueur visible et timer fini
		investigation_2
	si joueur non visible et timer fini
		neutral
	"""
	look_at_target = state_node.player_node
	pathfinding_target = state_node.player_node
	if (state_node.is_node_visible(player_list, "player") == true):
		if (is_player_visible == false):
			is_player_visible = true
			TIMER_SMALL_VISIBLE.start()
			TIMER_SMALL_NO_VISIBLE.stop()
	if (state_node.is_node_visible(player_list, "player") == false):
		if (is_player_visible == true):
			is_player_visible = false
			TIMER_SMALL_NO_VISIBLE.start()
			TIMER_SMALL_VISIBLE.stop()
	if (is_player_visible == true and is_timer_done == true):
		is_timer_done = false
		is_player_visible = false
		TIMER_SMALL_VISIBLE.stop()
		TIMER_SMALL_NO_VISIBLE.stop()
		state_node.change_state("combat")
	if (is_player_visible == false and is_timer_done == true):
		is_timer_done = false
		is_player_visible = false
		TIMER_SMALL_VISIBLE.stop()
		TIMER_SMALL_NO_VISIBLE.stop()
		state_node.change_state("investigation_1")
		state_node.INVESTIGATION_1_STATE.TIMER_SMALL_NO_VISIBLE.start()
	
	set_data()

func _on_Timer_small_time_visible_timeout():
	is_timer_done = true
func _on_Timer_small_time_no_visible_timeout():
	is_timer_done = true
