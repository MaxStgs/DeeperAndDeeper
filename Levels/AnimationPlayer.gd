extends AnimationPlayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var animTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animTimer = Global.oneShotTimer(1.0, self, self, "onAnimTimer")
	animTimer.start()
	pass # Replace with function body.

func onAnimTimer():
	self.play("FadeIn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
