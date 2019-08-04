extends Area2D

onready var host = get_parent();
var hittable = false;

enum HIT_TYPE {AWAY, LINEAR, DIRECTIONAL, VORTEX};
var hit_type;
var inch = -50;
var one_hit = false;

func _on_HitBox_area_entered(area):
	if("knockback" in area):
		if(hittable):
			
			host.deactivate_fric();
			host.deactivate_grav();
			
			hit_type = area.knockback_type;
			var mitigation = (global_position.distance_to(area.global_position) * sign(area.true_knockback))/10
			var knockback = area.true_knockback - mitigation;
			var tinch = inch * area.inchdir;
			
			match(hit_type):
				HIT_TYPE.AWAY:
					host.hspd = cos(get_angle_to(area.global_position)) * knockback * -1;
					host.vspd = ((sin(get_angle_to(area.global_position)) * knockback) + (tinch*sign(tinch) - abs(mitigation))) * -1;
				HIT_TYPE.LINEAR:
					var rad = atan2(area.host.vspd, area.host.hspd);
					host.hspd = cos(rad) * knockback;
					host.vspd = ((sin(rad) * knockback) + tinch);
				HIT_TYPE.DIRECTIONAL:
					host.hspd = cos(deg2rad(area.direction)) * knockback;
					host.vspd = ((sin(deg2rad(area.direction)) * knockback) + tinch);
			
			if(host.super_vulnerable):
				host.hitpoints -= area.host.damage * 2.5;
			elif(host.vulnerable):
				host.hitpoints -= area.host.damage * 1.5;
			else:
				host.hitpoints -= area.host.damage;
			
			if(host.hitpoints <= 0):
				$CollisionShape2D.call_deferred("set_disabled",true);
			
			if(host.hitpoints <= 0 && host.one_hit):
				one_hit = true;
			else:
				one_hit = false;
				host.one_hit = false;
			
			if(host.tag == "Dummy"):
				host.hit = true;
				host.get_node("damage_timer").start();
			else:
				host.states[host.state].exit('hurt');
	pass;
