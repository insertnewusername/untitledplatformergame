extends CharacterBody2D
@onready var sprite :=$AnimatedSprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_sound: AudioStreamPlayer2D = $DeathSound


const SPEED = 450.0
const JUMP_VELOCITY = -450.0
var alive = true
var respawn_x = 0.0
var respawn_y = 166.0
var accelerationvalue = 0.01
var slidevalue = 0.01
var stopvalue = 15
var onice = false

func _ready():
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !alive:
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if onice:
		move_on_ice(direction)
	else:
		if direction:
			velocity.x = direction * SPEED
			animated_sprite_2d.animation = "walk"
			sprite.flip_h = direction <0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			animated_sprite_2d.animation = "idle"
	move_and_slide()
	
func die() -> void:
	death_sound.play()
	animated_sprite_2d.play("death")
	alive = false
		
func _on_animation_finished():
	if animated_sprite_2d.animation == "death":
		respawn()
		
func respawn():
	print("Player position:", global_position)
	print("respawning...")
	animated_sprite_2d.play("idle")
	global_position = Vector2(respawn_x, respawn_y)
	alive = true
	
	
func _on_portal_teleport_player(pos: Vector2):
	print("PLAYER TELEPORT RECEIVED:", pos)
	global_position = pos
	velocity = Vector2.ZERO
	animated_sprite_2d.play("idle")
	
func move_on_ice(direction):
	if direction:
		sprite.flip_h = direction <0
		velocity.x = lerp(velocity.x, direction * SPEED, accelerationvalue)
	else:
		velocity.x = lerp(velocity.x, 0.0, slidevalue)
			
		if velocity.x < stopvalue and  velocity.x > -stopvalue:
			velocity.x = 0
	


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body == self:
		onice = true


func _on_area_2d_3_body_exited(body: Node2D) -> void:
	if body == self:
		onice = false
