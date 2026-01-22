extends Area2D

signal hit(damage: int)

@export var speed = 400
var screen_size
var invincible: bool = false
var invuln_timer: float = 0.0 

func _ready():
	screen_size = get_viewport_rect().size
	area_entered.connect(_on_area_entered)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	invincible = true
	invuln_timer = 1.5 
	modulate.a = 1.0
	_start_invuln_piscar(1.5)

func _process(delta):
	if invuln_timer > 0:
		invuln_timer -= delta
		if invuln_timer <= 0:
			invincible = false
			modulate = Color.WHITE  
	
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _start_invuln_piscar(duration: float):
	invincible = true
	var tween = create_tween()
	var cycle_time = 0.3  # Tempo de cada ciclo (ida e volta)
	var cycles = int(duration / cycle_time) + 1
	
	for i in cycles:
		tween.tween_property(self, "modulate", Color.GOLD, cycle_time / 2)   
		tween.tween_property(self, "modulate", Color.WHITE, cycle_time / 2)  
	
	tween.tween_callback(func():
		if invuln_timer <= 0:
			invincible = false
			modulate = Color.WHITE
	)

func _on_body_entered(body: Node2D) -> void:
	if not invincible:
		var damage: int = 1
		if body.is_in_group("mobs2"):
			damage = 2
		elif body.is_in_group("mobs"):
			damage = 1
		else:
			return
		
		hit.emit(damage)
		body.queue_free()
		$CollisionShape2D.disabled = true
		modulate = Color.RED
		var flash_tween = create_tween()
		flash_tween.tween_property(self, "modulate", Color.WHITE, 0.1)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("powerup"):
		area.queue_free()
		invuln_timer = 10.0  
		_start_invuln_piscar(5.0) 
   
