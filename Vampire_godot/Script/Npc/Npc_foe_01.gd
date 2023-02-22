extends KinematicBody

onready var main_node = get_tree().root.get_node("Main")

onready var NAVIGATION_AGENT = get_node("Navigation_follow")

onready var TIMER_ATTACK = get_node("Timer_attack")

export var speed = 5

var target_pathfinding
var target_reachable = false
var target_close = false

var direction = Vector3()

export var life_point = 100
export var stun_point = 2

var is_player_in_area_attack_zone = false
export var damage = 10
export var type = "damage"
var can_attack_timer = true

func _ready():
	NAVIGATION_AGENT.change_pathfinding(main_node.get_node("Player_actual"))

func _physics_process(delta):
	direction = Vector3()
	direction = NAVIGATION_AGENT.pathfinding(target_pathfinding, delta)
	direction *= speed
	
	if (direction != null):
		if (target_reachable == true and target_close == false):
			move_and_collide(direction)
	
	var look_at_vector = target_pathfinding.global_transform.origin - direction
	look_at_vector.y = global_transform.origin.y
	look_at(look_at_vector, Vector3.UP)
	
	if (is_player_in_area_attack_zone == true and can_attack_timer == true):
		attack(main_node.get_node("Player_actual"))

func take_damage(damage, type):
	if (type == "damage"):
		life_point -= damage
		if (life_point <= 0):
			queue_free()
	
	if (type == "stun"):
		stun_point -= damage
		if (stun_point <= 0):
			print("stun")

func attack(player):
	player.take_damage(damage, type)
	TIMER_ATTACK.start()
	can_attack_timer = false

func _on_Timer_attack_timeout():
	can_attack_timer = true

func _on_Area_attack_zone_body_entered(body):
	if (body.is_in_group("Player") == true):
		is_player_in_area_attack_zone = true

func _on_Area_attack_zone_body_exited(body):
	if (body.is_in_group("Player") == true):
		is_player_in_area_attack_zone = false
