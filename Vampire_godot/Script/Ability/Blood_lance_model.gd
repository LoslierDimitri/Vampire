extends MeshInstance

onready var main_node = get_tree().root.get_node("Main")
onready var player_node = main_node.get_node("Player_actual")
onready var ability_node = player_node.get_node("Ability")

onready var TIMER = get_node("Timer")

var timer

func _ready():
	TIMER.set_wait_time(timer)
	
	TIMER.start()
	ability_node.can_teleport = true

func _on_Timer_timeout():
	ability_node.can_teleport = false
	queue_free()
