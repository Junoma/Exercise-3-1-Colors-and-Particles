extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var time_appear = 0.3
var time_fall = 0.8
var time_rotate = 1.0
var time_a = 0.8
var time_s = 1.2
var time_v = 1.5
var tween

func _ready():
	position = new_position
	position.x = new_position.x
	position.y = -100
	tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.5 + randf()*2).set_trans(Tween.TRANS_BOUNCE)
	if score >= 100:
		$ColorRect.color = Color8(224,49,49,255)
	elif score >= 90:
		$ColorRect.color = Color8(253,126,20,255)
	elif score >= 80:
		$ColorRect.color = Color8(255,212,59,255)
	elif score >= 70:
		$ColorRect.color = Color8(148,216,45,255)
	elif score >= 60:
		$ColorRect.color = Color8(34,139,230,255)
	elif score >= 50:
		$ColorRect.color = Color8(132,94,247,255)
	elif score >= 40:
		$ColorRect.color = Color8(190,75,219,255)
	elif score >= 30:
		$ColorRect.color = Color8(253,213,59,255)  
	else: 
		$ColorRect.color = Color8(134,142,150,255)



func _physics_process(_delta):
	if dying and not $Confetti.emitting and not tween:
		queue_free()

func hit(ball):
	die()

func die():
	dying = true
	$CollisionShape2D.queue_free()
	collision_layer = 0
	$Confetti.emitting = true
	$ColorRect.hide()
	Global.update_score(score)
	get_parent().check_level()
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", Vector2(position.x, 1000), time_fall).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation", -PI + randf()*2*PI, time_rotate).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($ColorRect, "color:a", 0, time_a)
	tween.tween_property($ColorRect, "color:s", 0, time_s)
	tween.tween_property($ColorRect, "color:v", 0, time_v)
	var die_sound = get_node_or_null("/root/Game/Die_Sound")
	if die_sound != null:
		die_sound.play()
	queue_free()
