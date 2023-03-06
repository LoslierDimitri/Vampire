extends KinematicBody

onready var main_node = get_tree().root.get_node("Main")
var player_node

onready var NAVIGATION_AGENT = get_node("Navigation_follow")
onready var TIMER_ATTACK = get_node("Timer_attack")
onready var BLOOD_LINK = get_node("Blood_link")

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

var is_hypnosis = false

var is_blood_link = false
var blood_link_list = []
var blood_link_node

func _ready():
	NAVIGATION_AGENT.change_pathfinding(main_node.get_node("Player_actual"))
	BLOOD_LINK.visible = false

func _physics_process(delta):
	direction = Vector3()
	
	if (is_hypnosis == false):
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
	
	reset()

func take_damage(damage, type):
	if (is_blood_link == true):
		for node in blood_link_list:
			if (type == "damage"):
				node.life_point -= damage
				if (node.life_point <= 0):
					node.queue_free()
				
			if (type == "stun"):
				node.stun_point -= damage
				if (node.stun_point <= 0):
					print("stun")
	else:
		if (type == "damage"):
			life_point -= damage
			if (life_point <= 0):
				var blood_lance = get_node("blood_lance")
				if (blood_lance != null):
					player_node.get_node("Ability").can_teleport = false
				queue_free()
		if (type == "stun"):
			stun_point -= damage
			if (stun_point <= 0):
				print("stun")

func take_hypnose():
	is_hypnosis = true
func reset_hypnosis():
	is_hypnosis = false

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

func _process(delta):
	if (is_blood_link == true):
		BLOOD_LINK.visible = true
	else:
		BLOOD_LINK.visible = false

func reset():
	player_node = main_node.get_node("Player_actual")
	blood_link_node = player_node.get_node("Ability").get_node("blood_link")
	blood_link_list = player_node.get_node("Ability").get_node("blood_link").blood_link_list
#	is_hypnosis = false
