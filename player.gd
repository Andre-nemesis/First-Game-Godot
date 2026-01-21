extends Area2D
signal hit(damage: int)

@export var speed = 400 
var screen_size 
var invincible: bool = false

func _ready():
	screen_size = get_viewport_rect().size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	invincible = true
	modulate.a = 1.0
	
	var tween = create_tween()
	for i in 5:
		tween.tween_property(self,"modulate:a",0.0,0.15)
		tween.tween_property(self,"modulate:a",1.0,0.15)
	tween.tween_callback(func(): invincible=false)
	tween.play()

func _process(delta):
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
