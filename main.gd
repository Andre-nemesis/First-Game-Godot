extends Node

@export var mob_scene: PackedScene
@export var mob2_scne: PackedScene
@export var power_up: PackedScene

var score
var elapsed_time: float = 0.0
var game_active: bool = false
var lifes: int = 5

func _ready() -> void:
	randomize()
	new_game()

func _process(delta: float) -> void:  
	if game_active:
		elapsed_time += delta
		$HUD.update_time(elapsed_time)

func _on_score_timer_timeout():
	score += 0.5
	$HUD.update_score(score)

func _on_start_timer_timeout():
	game_active = true
	$MobTimer.start()
	$ScoreTimer.start()

func lose_life(damage:int = 1) -> void:
	if lifes == 0:
		game_over()
	lifes -= damage
	$HUD.update_life(lifes)
	if lifes <= 0:
		game_over()
	else:
		$player.start($StartPosition.position)

func game_over() -> void:
	game_active = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$GameOver.play()

func new_game() -> void:
	$GameOver.stop()
	$Music.play()
	score = 0
	elapsed_time = 0.0
	game_active = false
	lifes = 5
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$HUD.update_score(score)
	$HUD.update_life(lifes)
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("mobs2", "queue_free")
	get_tree().call_group("powerup", "queue_free")
	$player.start($StartPosition.position)
	
func _on_mob_timer_timeout() -> void:
	var roll = randf()
	if roll < 0.05:
		var powerUp = power_up.instantiate()
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		powerUp.position = mob_spawn_location.position
		add_child(powerUp)
		powerUp.add_to_group("powerup")
	elif roll < 0.15:
		var mob = mob2_scne.instantiate()
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
		var direction = mob_spawn_location.rotation + PI / 2
		direction += randf_range(-PI / 4, PI / 4)
		mob.rotation = direction
		var velocity = Vector2(75.0, 0.0)
		mob.linear_velocity = velocity.rotated(direction)
		add_child(mob)
		mob.add_to_group("mobs2")
	else:
		var mob = mob_scene.instantiate()
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
		var direction = mob_spawn_location.rotation + PI / 2
		direction += randf_range(-PI / 4, PI / 4)
		mob.rotation = direction
		var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
		mob.linear_velocity = velocity.rotated(direction)
		add_child(mob)
		mob.add_to_group("mobs")
	
