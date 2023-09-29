extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

func _ready():
	position = new_position
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
	if dying and not $Confetti.emitting:
		queue_free()

func hit():
	die()

func die():
	dying = true
	collision_layer = 0
	$Sonfetti.emitting = true
	$ColorRect.hide()
	Global.update_score(score)
	get_parent().check_level()
