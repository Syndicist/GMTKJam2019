extends "res://Game Objects/Actors/Actor.gd"

onready var actionTimer = get_node("Action_Timer");
onready var player = get_tree().get_root().get_children()[0].get_node("Player");

#range which the enemy attacks
export(float) var attack_range = 50;
#range which the enemy chases
export(float) var chase_range = 150;

###background_enemy_data###
var decision;
var wait;

onready var states;
var state;

var friction = 10;
var hit = false;
var moving = false;

var vulnerable = false;
var super_vulnerable = true;
var one_hit = true;

### Enemy ###
func _ready():
	states = {
	'default' : $States/Default,
	'chase' : $States/Chase,
	'attack' : $States/Attack,
	'hurt' : $States/Hurt
	}
	decision = 0;
	wait = 0;
	state = 'default';
	pass

func execute(delta):
	#assumes the enemy is stored in a Node2D
	if(actionTimer.time_left <= 0.1):
		decision = makeDecision();
	wait = rand_range(.5, 2);
	
	if(hitpoints <= 0):
		$HitBox
		Kill();

func phys_execute(delta):
	#state machine
	#state = 'default' by default
	states[state].handleAnimation();
	states[state].handleInput(Input);
	states[state].execute(delta);
	
	velocity.x = hspd;
	velocity.y = vspd;
	velocity = move_and_slide(velocity,floor_normal);
	
	#no gravity acceleration when on floor
	if(on_floor()):
		velocity.y = 0
		vspd = 0;
	
	#add gravity
	if(grav_activated):
		vspd += gravity;
	
	#cap gravity
	if(vspd > 900):
		vspd = 900;
	if(is_on_ceiling()):
		vspd = 500;
	
	if(fric_activated && !moving):
		if(hspd > 0):
			hspd -= friction;
		elif(hspd < 0):
			hspd += friction;
		if((hspd <= 44 && hspd > 0) || (hspd >= 44 && hspd < 0)):
			hspd = 0;
	pass;

var done_knockback = false;

func makeDecision():
	var dec = randi() % 100 + 1;
	return dec;

func canSeePlayer():
	var space_state = get_world_2d().direct_space_state;
	var result = space_state.intersect_ray(global_position, player.global_position, [self], collision_mask);
	if(!result.empty()):
		return false;
	elif((global_position.distance_to(player.global_position) <= chase_range)):
		return true;
	return false;

func Kill():
	.Kill();
	animate($animator,"death", false);