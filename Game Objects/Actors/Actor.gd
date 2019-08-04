extends KinematicBody2D

###actor_data###
export(int) var max_hp = 1;
#warning-ignore-
export(int) var base_damage = 1;
export(float) var mspd = 100;
export(float) var jspd = 50;
export(String) var tag = "NPC";

var damage;
var hitpoints;

###physics vars###
var air_time = 0;
var hspd = 0;
var vspd = 0;
var Direction = 1;
export(float) var gravity = 10;
export(float) var g_max = 250;
var velocity = Vector2(0,0);
var floor_normal = Vector2(0,-1);
var grav_activated = true;
var fric_activated = true;

export(bool) var enabled = true;

func _ready():
	hitpoints = max_hp;
	### default movement controller vars ###
	#1 = right, -1 = left
	Direction = 1;
	velocity = Vector2(0,0);
	floor_normal = Vector2(0,-1);
	pass;

func _process(delta):
	if(enabled):
		execute(delta);

func _physics_process(delta):
	if(enabled):
		phys_execute(delta);

func execute(delta):
	pass;

func phys_execute(delta):
	pass;

var first = false;
func animate(animator, anim, cont = true):
	animator.stop(cont);
	animator.play(anim);
	pass;

func Kill():
	enabled = false;

func on_floor():
	return test_move(transform, Vector2(0,1));

func deactivate_grav():
	grav_activated = false;
	vspd = 0;
	velocity.y = 0;

func deactivate_grav_dont_stop():
	grav_activated = false;

func deactivate_fric():
	fric_activated = false;
	hspd = 0;
	velocity.x = 0;

func activate_grav():
	grav_activated = true;

func activate_fric():
	fric_activated = true;