extends KinematicBody2D


onready var raycast2d = $RayCast2D
onready var animation = $AnimationTree

onready var statemachine = animation["parameters/playback"]

var _api = preload("res://Api.tscn")
var darah = 15
var lagi_sakit = false
var mokad = false

func _process(delta):
	var lihat_target = raycast2d.is_colliding()
	if lihat_target:
		statemachine.travel("Nembak")

func tembak():
	var api = _api.instance()
	api.global_position = $Position2D.global_position
	get_tree().current_scene.add_child(api)

func _on_BadanKitsune_body_entered(body):
	if body.name == 'Fighter':
		body.terluka()

func luka():
	darah -= 5
	lagi_sakit = true
	$AnimatedSprite.play("Terluka")
	
	yield(get_tree().create_timer(1), "timeout")
	
	if darah <= 0:
		turu()
	else:
		lagi_sakit = false
	print("Kitsune :", darah)
	
func turu():
	mokad = true
	$AnimatedSprite.play("Mati")
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(0, false)
