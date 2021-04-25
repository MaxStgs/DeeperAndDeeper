extends KinematicBody2D

export(Array) var levelSpeeds = [150, 250, 350]

var spawnedBy

var maxEnemyLevel = 3

var Speed

var angle
var direction

var enemyLevel = 1

export(float) var MaxHealth = 10

var health = MaxHealth

var visibilityNotifier

var speedIndex

func _ready():
	
	visibilityNotifier = VisibilityNotifier2D.new()
	# increase the size of the visibility notifier size otherwise
	# the asteroid will disappear before it's fully off screen
	visibilityNotifier.set_rect(Rect2(-100, -100, 200, 200))
	add_child(visibilityNotifier)
	
	visibilityNotifier.connect("screen_exited", self, "onScreenExit")
	
	speedIndex = enemyLevel - 1
	
	
	Speed = levelSpeeds[speedIndex]


func _physics_process(delta):

	# warning-ignore:return_value_discarded
	var collision = move_and_collide(angle * Speed * delta)
	if collision:
		direction += 90.0
		angle = Vector2(cos(direction), sin(direction))


func missileHit(damage):
	health -= damage
	print(health)
	if health > 0:
		return
	
	# Not sure why, but this line didn't work to disable collision
#	$CollisionPolygon2D.disabled = true
	# This line did work to disable collision
	$CollisionPolygon2D.set_deferred("disabled", true)
	$character.set_visible(false)
	
	# slightly vary the volume of the sound played when missile hits enemy so it doens't do your head in
	randomize()
	var randomVolume = rand_range(-2, 0)
	
	$explosion.set_emitting(true)
	$hitSound.set_volume_db(randomVolume)
	$hitSound.play()
	
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


func _on_Area2D_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
