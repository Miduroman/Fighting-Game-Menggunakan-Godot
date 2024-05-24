extends KinematicBody2D

var laju_cepat = 900
var laju_normal = 250
var laju = laju_normal
var kecepatan = Vector2.ZERO
var laju_lompat = -380
var gravitasi = 12
var sedang_terluka = false
var health_maks = 50
var health = 50
var mati = false
var sedang_serang = false


onready var sprite = $Sprite


func _input(event):
	if event is InputEventKey and event.is_action_pressed("serang"):
		sedang_serang = true
		sprite.play("Serang")
		yield(sprite, "animation_finished")
		sedang_serang = false

func _physics_process(delta):
	var is_jumping = false

	kecepatan.y = kecepatan.y + gravitasi
	
	if(not sedang_terluka and not mati and Input.is_action_pressed("gerak_kanan")):
		kecepatan.x = laju
	if(not sedang_terluka and not mati and Input.is_action_pressed("gerak_kiri")):
		kecepatan.x = -laju
	
	if(not sedang_terluka and not mati and Input.is_action_just_pressed("lari_cepat")):
		lari_cepat()
	
	if(not sedang_terluka and not mati and Input.is_action_pressed("lompat") and is_on_floor()):
		kecepatan.y = laju_lompat
		is_jumping = true
	
	var snap = Vector2.ZERO if is_jumping else (Vector2.DOWN * 8)
	
	kecepatan.x = lerp(kecepatan.x, 0, 0.2)
	kecepatan = move_and_slide_with_snap(kecepatan, snap, Vector2.UP)
	
	if not sedang_terluka and not mati and not sedang_serang:
		update_animasi()

func update_animasi():
	if is_on_floor():
		if kecepatan.x < (laju * 0.5) and kecepatan.x > (-laju * 0.5):
			sprite.play("Diam")
		else:
			if laju == laju_normal:
				sprite.play("Lari")
			elif laju == laju_cepat:
				sprite.play("LariCepat")
	else:
		if kecepatan.y > 0:
			# jatuh
			sprite.play("Jatuh")
		else:
			# lompat
			sprite.play("Lompat")
	
	sprite.flip_h = false
	if kecepatan.x < 0:
		sprite.flip_h = true

func lari_cepat():
	laju = laju_cepat
	$Timer.start()

func _on_Timer_timeout():
	laju = laju_normal
	

func kitsune():
	sedang_terluka = true
	
	health -= 15
	
	
	sprite.play("Terluka")
	
	if kecepatan.x >= 0:
		kecepatan.x = -2000
		sprite.flip_h = false
	else:
		kecepatan.x = -2000
		sprite.flip_h = false
	yield(get_tree().create_timer(1), "timeout")
	
	if health <= 0:
		mati()
	else:
		sedang_terluka = false
	
	kecepatan.x = 0.1
	print("Darah :", health)
	

func yamabushi():
	sedang_terluka = true
	health -= 5
	
	
	sprite.play("Terluka")
		
	yield(get_tree().create_timer(1), "timeout")
	
	if health <= 0:
		mati()
	else:
		sedang_terluka = false
	
	print("Darah :", health)
	

	

func terluka():
	sedang_terluka = true
	health -= 10

	
	sprite.play("Terluka")
	
	if kecepatan.x >= 0:
		kecepatan.x = -2000
	else:
		kecepatan.x <= 2000
	
	if kecepatan.y > 0:
		kecepatan.y = -500
	yield(get_tree().create_timer(1), "timeout")
	
	if health <= 0:
		mati()
	else:
		sedang_terluka = false
		
	kecepatan.x = 0.1
	print("Darah :", health)

func mati():
	sprite.play("Mati")
	yield(get_tree().create_timer(0.1), "timeout")
	mati = true
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(2, false)
	emit_signal("hero_mati")
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene("res://Level1.tscn")


