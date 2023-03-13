extends Spatial

onready var state_node = get_parent()

onready var TIMER_LONG = get_node("Timer_long_time")

var player_list = []
var dead_list = []
var npc_list = []
var sound_list = []

var is_player_visible = false
var is_timer_done = false

var look_at_target
var pathfinding_target

var target_player
var target_player_last_position
var target_no

func get_data():
	player_list = state_node.player_list
	dead_list = state_node.dead_list
	npc_list = state_node.npc_list
	sound_list = state_node.sound_list
	
	target_player = state_node.player_node
	target_player_last_position = state_node.player_node_last_position
	target_no = state_node.parent_node

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
	si joueur visible
		continu
	si joueur non visible
		lance timer
		is_player_visible false
	is joueur non visible et timer done
		change state to investigation_2
	"""
	look_at_target = state_node.player_node
	pathfinding_target = state_node.player_node
	if (state_node.is_node_visible(player_list, "player") == true):
		if (is_player_visible == false):
			is_player_visible = true
			TIMER_LONG.stop()
			look_at_target = target_player
			pathfinding_target = target_player
	if (state_node.is_node_visible(player_list, "player") == false):
		if (is_player_visible == true):
			is_player_visible = false
			TIMER_LONG.start()
			look_at_target = target_player
			pathfinding_target = target_player
	if (is_player_visible == false and is_timer_done == true):
		is_timer_done = false
		is_player_visible = false
		TIMER_LONG.stop()
		state_node.change_state("investigation_2")
		state_node.INVESTIGATION_2_STATE.TIMER_SMALL_NO_VISIBLE.start()
		look_at_target = target_no
		pathfinding_target = target_no
	
	set_data()

func _on_Timer_long_time_timeout():
	is_timer_done = true
