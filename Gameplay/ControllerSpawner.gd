extends YSort

export(float) var Interval = 3.0

var spawnTimer

var currentWave = 0
var currentWaveState = 1

export(Array, NodePath) var Spawners

export(Array, PackedScene) var Enemies

export(Array, int) var CountEnemies

export(Array, int) var CountEnemiesForNextWave

var RemainingEnemies = []

var FullCountEnemies = 0

export(String, FILE, "*.tscn") var NextLevelLoader

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(CountEnemies)):
		RemainingEnemies.append(0)
		FullCountEnemies += CountEnemies[i]
	
	spawnTimer = Global.oneShotTimer(Interval, self, self, "onSpawnTimer")
	spawnTimer.start()
	pass # Replace with function body.
	
func startGame():
	spawnEnemy()
	pass
	
func spawnEnemy():
	spawnTimer = Global.oneShotTimer(Interval, self, self, "onSpawnTimer")
	spawnTimer.start()
	
	spawnEnemies()
	
func onSpawnTimer():
	spawnTimer.queue_free()
	spawnEnemy()
	
func spawnEnemies():
	# Should uprade wave?
	var isLastWave = currentWave == len(CountEnemiesForNextWave) - 1
	if !isLastWave:
		var isShouldRunNextWave = RemainingEnemies[currentWave + 1] == CountEnemiesForNextWave[currentWave + 1]
		if isShouldRunNextWave:
			currentWave += 1
			currentWaveState = 1
	
	for i in min(len(Spawners), currentWaveState):
		if CountEnemies[currentWave] <= 0:
			return
			
		var enemy = Enemies[currentWave].instance()
		enemy.enemyLevel = currentWave
		var spawner = get_node(Spawners[i])
		var spawnPosition = spawner.position
		enemy.position = spawnPosition
		enemy.add_to_group("enemies")
		
		randomize()
		var randomAngle = rand_range(0.0, 360.0)
		
		if randomAngle >= 90 && randomAngle <= 270:
			enemy.apply_scale(Vector2(-1,1))
			
		enemy.angle = Vector2(cos(randomAngle), sin(randomAngle))
		enemy.direction = randomAngle
		enemy.spawnedBy = self
		
		CountEnemies[currentWave] -= 1
		
		get_parent().add_child(enemy)

	currentWaveState = currentWaveState * 2
	pass

func killed(enemyLevel):
	FullCountEnemies -= 1
	if isAllEnemiesKilled():
		get_tree().change_scene(NextLevelLoader)
		
	var isLastEnemyLevel = enemyLevel == len(Enemies) - 1
	if isLastEnemyLevel:
		return
	
	RemainingEnemies[enemyLevel + 1] += 1
	onSpawnTimer()
		
	pass

func isAllEnemiesKilled():
	return FullCountEnemies == 0
