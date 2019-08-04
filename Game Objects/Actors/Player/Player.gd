extends "res://Game Objects/Actors/Actor.gd"

signal hp_changed;
signal stamina_changed;
signal light_changed;

export(float) var max_stamina = 100;
var stamina = 100;
export(float) var stam_recov = 1;
var light = 0.0;
export(float) var base_stam_cost = 20;

var stam_cost = 20;
###states###
#TODO: hurt_state
onready var move_states = {
	'idle' : $Movement_States/Idle,
	'ledge_grab' : $Movement_States/Ledge_Grab,
	'dash' : $Movement_States/Dash,
	'hurt' : $Movement_States/Hurt
}
var move_state = 'idle';

###hitbox detection###
var targettableHitboxes = [];
var itemTrace = [];

###camera control###
onready var cam = get_node("Camera2D");

var rad = 0.0;
var deg = 0.0;


enum InputType {GAMEPAD, KEYMOUSE};
var ActiveInput = InputType.GAMEPAD;

func _ready():
	._ready();
	$Camera2D.current = true;
	move_states[move_state].enter();

func _input(event):
	if(event.get_class() == "InputEventMouseButton" || event.get_class() == "InputEventKey" || Input.get_connected_joypads().size() == 0):
		ActiveInput = InputType.KEYMOUSE;
	elif(event.get_class() == "InputEventJoypadMotion" || event.get_class() == "InputEventJoypadButton"):
		ActiveInput = InputType.GAMEPAD;


func execute(delta):
	if(enabled):
		if(Input.is_action_just_pressed("test")):
			change_light(50);
		if(ActiveInput == InputType.KEYMOUSE):
			rad = atan2(get_global_mouse_position().y - global_position.y , get_global_mouse_position().x - global_position.x);
		elif(ActiveInput == InputType.GAMEPAD):
			rad = atan2(Input.get_joy_axis(0, JOY_ANALOG_LY), Input.get_joy_axis(0, JOY_ANALOG_LX));
		deg = rad2deg(rad);
		
		damage = base_damage * (1 + (light/10000));
		stam_cost = base_stam_cost * (1 + (light/5000));
		print(damage);
		$Sprites/Sprite.material.set_shader_param("width", min(light/1000.0, 1000));
		print(light);
		hitboxLoop();

func phys_execute(delta):
	if(enabled):
		_stretch_based_on_velocity();
		#print(move_state);
		#state machine
		move_states[move_state].handleInput();
		move_states[move_state].handleAnimation();
		move_states[move_state].execute(delta);
		
		#count time in air
		air_time += delta;
		
		#move across surfaces
		velocity.y = vspd;
		velocity.x = hspd;
		velocity = move_and_slide(velocity, floor_normal);
		#no gravity acceleration when on floor
		if(on_floor()):
			air_time = 0;
			velocity.y = 0
			vspd = 0;
		
		if(is_on_ceiling()):
			vspd = 0;
		
		if(grav_activated):
			vspd += gravity;
		
		#cap gravity
		if(vspd > g_max && grav_activated) :
			vspd = g_max;

func _on_DetectHitboxArea_area_entered(area):
	if(!targettableHitboxes.has(area)):
		targettableHitboxes.push_back(area);

func _on_DetectHitboxArea_area_exited(area):
	if(targettableHitboxes.has(area)):
		targettableHitboxes.erase(area);

func hitboxLoop():
	var space_state = get_world_2d().direct_space_state;
	for item in targettableHitboxes:
		var enemy = nextRay(self,item,4,space_state);
		if(enemy):
			item.hittable = true;
		else:
			item.hittable = false;

func nextRay(origin,dest,col_layer,spc):
	if(!itemTrace.has(origin)):
		itemTrace.push_back(origin);
	var result = spc.intersect_ray(origin.global_position, dest.global_position, itemTrace, $RayCastCollision.collision_mask);
	if(result.empty()):
		itemTrace.clear();
		return true;
	
	elif(result.collider.get_collision_layer_bit(col_layer)):
		if(result.collider != dest):
			return nextRay(result.collider,dest,col_layer,spc);
		else:
			itemTrace.clear();
			return true;
	
	else:
		itemTrace.clear();
		return false;

func _stretch_based_on_velocity():
	if(move_state == 'dash'):
		$Sprites/Sprite.scale.y = range_lerp(abs(velocity.y), 0, 500, 1, 1.5);
	else:
		$Sprites/Sprite.scale.y = 1;
	$Sprites/Sprite.scale.x = range_lerp(abs(velocity.x), 0, 500, 1, 1.5)

func mouse_r():
	return (deg > -90 && deg < 90);

func mouse_u():
	return (deg > -150 && deg < -30);

func mouse_l():
	return (deg > 90 || deg < -90);

func mouse_d():
	return (deg < 150 && deg > 30);

func add_velocity(vel: float):
	hspd = vel * cos(rad);
	vspd = vel * sin(rad);

func _on_GUI_hit_zero():
	enabled = false;
	$anim.play("death");

func _on_stamTimer_timeout():
	if(stamina < max_stamina):
		stamina += stam_recov;
	if(stamina > max_stamina):
		stamina = max_stamina;
	emit_signal("stamina_changed",stamina);

func change_stamina(stam = -stam_cost):
	stamina += stam;
	emit_signal("stamina_changed",stamina);

func change_light(li):
	light += li;
	emit_signal("light_changed", li);