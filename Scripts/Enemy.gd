extends KinematicBody2D

export(Array) var levelSpeeds = [150, 250, 350]
export(float) var Speed = 150.0

var spawnedBy

var maxEnemyLevel = 3

var angle
var direction

var enemyLevel = 1

export(float) var MaxHealth = 10
var health

var visibilityNotifier

var firingTimer
var IntervalBetweenAttacks = 1.0
export(PackedScene) var MissileScene
export(float) var MissileDamage = 1.0

var speedIndex

func _ready():
	preload("res://Assets/Particles/explosion_green.tscn")
	speedIndex = enemyLevel - 1
	
	if MissileScene:
		firingTimer = Global.oneShotTimer(IntervalBetweenAttacks, self, self, "onFiringTimerStopped")
		firingTimer.start()
		
	health = MaxHealth
	pass


func _physics_process(delta):

	# warning-ignore:return_value_discarded
	var collision = move_and_collide(angle * Speed * delta)
	if collision:
		direction += 90.0
		angle = Vector2(cos(direction), sin(direction))


func missileHit(damage):
	health -= damage
	
	print(health)
	
	randomize()
	var randomVolume = rand_range(-2, 0)
	$explosion.set_emitting(true)
	$hitSound.set_volume_db(randomVolume)
	$hitSound.play()
	
	if health > 0:
		return
	
	# Not sure why, but this line didn't work to disable collision
#	$CollisionPolygon2D.disabled = true
	# This line did work to disable collision
	$CollisionPolygon2D.set_deferred("disabled", true)
	$character.set_visible(false)
	
	# slightly vary the volume of the sound played when missile hits enemy so it doens't do your head in
	
	Global.score += enemyLevel * 10
	
	Global.hudScore.set_text(str(Global.score))
	
	spawnedBy.killed(enemyLevel)
		
	# wait a second for the sound to play then destroy self
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")

	self.queue_free()


func onScreenExit():
	self.queue_free()

func onFiringTimerStopped():
	shotPlayer()
	pass
	
func shotPlayer():
	return
	var playerSpawner = get_node("../PlayerSpawner")
	if !playerSpawner:
		firingTimer.start()
		return
		
	if !playerSpawner.player:
		firingTimer.start()
		return
		
	randomize()
	var randomVolume = rand_range(-2, 0)
	
	var missile = MissileScene.instance()
	
	print(playerSpawner.player.position)
	# missile.position = playerSpawner.player.get_node("CollisionShape2D").position
	missile.position = self.position
	# missile.position = Vector2(0.0, 0.0)
	
	# var target = playerSpawner.player.get_node("CollisionShape2D").position
	var target = get_viewport().size / 2
	
	# missile.rotation = self.position.direction_to(player.position).angle()
	missile.rotation = self.position.angle_to_point(target)
	missile.damage = MissileDamage
	
	missile.add_to_group("missiles")
	
	get_tree().get_root().add_child(missile)
	firingTimer.start()
	pass

func _on_Area2D_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
