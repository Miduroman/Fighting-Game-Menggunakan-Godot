extends Area2D

var kecepatan = 180
var arah = Vector2.LEFT


func _process(delta):
	translate(arah * kecepatan * delta)
	

func _on_Api_body_entered(body):
	if body.name == "Fighter":
		body.kitsune()
	kecepatan = 0
	$AnimatedSprite.visible = false
	yield(get_tree().create_timer($AnimatedSprite.visible), "timeout")
	queue_free()
