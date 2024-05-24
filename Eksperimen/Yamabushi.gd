extends KinematicBody2D

var gravitasi = 12
var laju = 50
var kecepatan = Vector2.ZERO
var arah = 1
var kesehatan = 20

onready var raycast = $Pivot/RayCast2D
onready var pivot = $Pivot
onready var AttackDetector = $AttackDetector
onready var PlayerDetector = $PlayerDetector

var apakah_terluka = false
var serang = false
var mokad = false

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	kecepatan.y += gravitasi
	
	if is_on_wall() or not raycast.is_colliding() and not apakah_terluka and not mokad:
		arah = arah * -1
		pivot.scale.x = pivot.scale.x * -1
		AttackDetector.scale.x = AttackDetector.scale.x * -1
		PlayerDetector.scale.x = PlayerDetector.scale.x * -1
		
	kecepatan.x = laju * arah
	
	if not apakah_terluka and not mokad:
		kecepatan = move_and_slide(kecepatan, Vector2.UP)
	
	if $AnimationPlayer.current_animation == "Serang":
		return
	
	if not apakah_terluka and not mokad:
		_update_animasi()
	
func _update_animasi():
	if is_on_floor():
		$AnimatedSprite.play("Jalan")
	else:
		$AnimatedSprite.play("Jatuh")
	$AnimatedSprite.flip_h = false
	if arah == -1:
		$AnimatedSprite.flip_h = true


func _on_Area2D_body_entered(body):
	if body.name == 'Fighter':
		body.terluka()
		
func hit():
	$AttackDetector.monitoring = true
	
func end_of_hit():
	$AttackDetector.monitoring = false
	
func star_walk():
	$AnimationPlayer.play("Jalan")


func _on_PlayerDetector_body_entered(body):
	if not apakah_terluka and not mokad:
		$AnimationPlayer.play("Serang")
		laju = 0
		yield(get_tree().create_timer(0.5), "timeout")
		laju = 50
	

func damage():
	kesehatan -= 5
	apakah_terluka = true
	$AnimatedSprite.play("Terluka")
	
	yield(get_tree().create_timer(1), "timeout")
	
	if kesehatan <= 0:
		mati()
	else:
		apakah_terluka = false
	print("Yamabushi :", kesehatan)
	
	
func mati():
	mokad = true
	$AnimatedSprite.play("Mati")
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(0, false)
	$Area2D.set_collision_mask_bit(0, false)
	$PlayerDetector.set_collision_mask_bit(0, false)
	$AttackDetector.set_collision_mask_bit(0, false)
	

func _on_AttackDetector_body_entered(body):
	if body.name == 'Fighter':
		serang = true
		kecepatan.x = 0
		body.yamabushi()

