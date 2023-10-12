extends RigidBody2D

var min_speed = 100.0
var max_speed = 600.0
var accelerate = false 
var time_highlight = 0.4
var time_highlight_size = 0.3

var decay = 0.04

var wobble_period = 0.0
var wobble_amplitude = 0.0
var wobble_max = 5
var wobble_direction = Vector2.ZERO
var decay_wobble = 0.15

var Indicator = load("res://UI/Indicator.tscn")
var indicator_margin = Vector2(25, 15)
var indicator_index = 25
var indicator_mod = 0.0
var indicator_mod_start = 0.0
var indicator_mod_target = 0.5
var indicator_scale = Vector2(0.5,0.5)
var indicator_scale_start = Vector2(0.5,0.5)
var indicator_scale_target = Vector2(1.5,1.5)

var tween

var distort_effect = 0.0002

func _ready():
	contact_monitor = true
	max_contacts_reported = 8
	if Global.level < 0 or Global.level >= len(Levels.levels):
		Global.end_game(true)
	else:
		var level = Levels.levels[Global.level]
		min_speed *= level["multiplier"]
		max_speed *= level["multiplier"]
	

func _on_Ball_body_entered(body):
	if body.has_method("hit"):
		body.hit(self)
		accelerate = true
	if tween:
		tween.kill()
		tween = create_tween().set_parallel(true)
		$Images/Highlight.modulate.a = 1.0
		tween.tween_property($Images/Highlight, "modulate:a", 0, time_highlight).set_trans(Tween.TRANS_LINEAR)
		$Images/Highlight.scale = Vector2(2.0,2.0)
		tween.tween_property($Images/Highlight, "scale", Vector2(1.0,1.0),time_highlight_size).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
		wobble_direction = linear_velocity.orthogonal().normalized()
		wobble_amplitude = wobble_max
		
		if $Highlight.modulate.a > 0:
			$Highlight.modulate.a -= decay 

func _integrate_forces(state):
	wobble()
	distort()
	if position.y > Global.VP.y + 100:
		die()
	if accelerate:
		state.linear_velocity = state.linear_velocity * 1.1
		accelerate = false
	if abs(state.linear_velocity.x) < min_speed:
		state.linear_velocity.x = sign(state.linear_velocity.x) * min_speed
	if abs(state.linear_velocity.y) < min_speed:
		state.linear_velocity.y = sign(state.linear_velocity.y) * min_speed
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed

func update_lives():
	var indicator_pos = Vector2(indicator_margin.x, Global.VP.y - indicator_margin.y)
	for i in $Indicator_Container.get_children():
		i.queue_free()
	for i in range(Global.lives):
		var indicator = Indicator.instantiate()
		indicator.position = Vector2(indicator_pos.x + i*indicator_index, indicator_pos.y)
		$Indicator_Container.add_child(indicator)
		breathe()

func breathe():
	indicator_scale = indicator_scale_target if indicator_scale == indicator_scale_start else indicator_scale_start
	indicator_mod = indicator_mod_target if indicator_mod == indicator_mod_start else indicator_mod_start
	if tween: 
		tween.kill()
	tween = get_tree().create_tween().set_parallel(true)
	for i in $Indicator_Container.get_children():
		tween.tween_property(i.get_node("/root/Ball/Images/Highlight"), "scale", indicator_scale, 0.5)
		tween.tween_property(i.get_node("/root/Ball/Images/Highlight"), "modulate:a", indicator_mod, 0.5)
	tween.set_parallel(false)
	tween.tween_callback(breathe)

func die():
	var die_sound = get_node_or_null("/root/Game/Die_Sound")
	if die_sound != null:
		die_sound.play()
	queue_free()

func wobble():
	wobble_period += 1
	if wobble_amplitude > 0:
		var pos = wobble_direction * wobble_amplitude * sin(wobble_period)
		$Images.position = pos
		wobble_amplitude -= decay_wobble

func distort():
	var direction = Vector2(1 + linear_velocity.length() * distort_effect, 1 - linear_velocity.length() * distort_effect)
	$Images.rotation = linear_velocity.angle()
	$Images.scale = direction
