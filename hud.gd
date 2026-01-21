extends CanvasLayer

@onready var time_label: Label = $Control/TimeLabel
@onready var life_label: Label = $LifeLabel

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$LifeLabel.show()
	$Control/TimeLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$StartButton.show()
	$MessageLabel.text = "Dodge the Wests!"
	$MessageLabel.show()
	
	await get_tree().create_timer(1.0).timeout
	
func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	emit_signal("start_game")
	
func update_life(lifes:int) -> void:
	life_label.text = "%d LP" % lifes

func _on_message_timer_timeout() -> void:
	$MessageLabel.hide()
	
func update_time(total_time:float) -> void:
	var minutes: int = int(total_time / 60)
	var seconds: int = int(total_time) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]
