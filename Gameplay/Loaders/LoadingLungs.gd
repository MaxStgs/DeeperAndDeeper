extends Node2D

export(float) var Interval = 5.0
export(String, FILE, "*.tscn") var NextLevel
var spawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnTimer = Global.oneShotTimer(Interval, self, self, "onSpawnTimer")
	spawnTimer.start()
	pass # Replace with function body.

func onSpawnTimer():
	get_tree().change_scene(NextLevel)
	spawnTimer.queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
