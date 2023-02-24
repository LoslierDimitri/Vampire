extends MeshInstance

onready var TIMER = get_node("Timer")

func _ready():
	TIMER.start()

func _on_Timer_timeout():
	queue_free()
