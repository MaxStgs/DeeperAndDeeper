extends Node2D

export(float) var Interval = 2.5
export(String, FILE, "*.tscn") var NextLevel
var spawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnTimer = Global.oneShotTimer(Interval, self, self, "onSpawnTimer")
	spawnTimer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.

func onSpawnTimer():
	get_tree().change_scene(NextLevel)
	spawnTimer.queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Button_pressed() -> void:
	get_tree().change_scene(NextLevel)
	pass # Replace with function body.
