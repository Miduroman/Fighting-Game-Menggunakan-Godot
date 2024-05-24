extends Node2D



func _on_Zonajatuh_body_entered(body):
	if body.name == 'Fighter':
		get_tree().change_scene("res://Level1.tscn")



