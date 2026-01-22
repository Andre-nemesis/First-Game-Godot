extends Node2D

@onready var lights: Array[PointLight2D] = [
	$Top,
	$Bottom,
	$LeftLight,
	$RightLight
]

func _ready() -> void:
	for i in lights.size():
		_blink_loop(lights[i], i * 0.5)

func _blink_loop(light: PointLight2D, delay:float) -> void:
	await get_tree().create_timer(delay).timeout
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
		
	tween.tween_property(light, "energy", 0.0, 1.0)
	tween.tween_property(light, "energy", 2.5, 1.0)
	


func _process(delta: float) -> void:
	pass
