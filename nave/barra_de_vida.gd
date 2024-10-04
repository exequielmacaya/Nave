extends ProgressBar


var maxValue: int
var damage: int

func _ready() -> void:
	maxValue = 3

func DisminuirVida(damage):
	value -= damage
