extends CharacterBody2D

class_name Player

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var current_attack : bool
var attack_type : String

var health = 150
var health_max = 150
var health_min = 0
var can_take_damage: bool
var dead: bool = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D
@onready var deal_damage_zone = $DealDamageZone

func _ready():
	Global.playerBody = self
	current_attack = false
	dead = false
	can_take_damage = true
	Global.playerAlive = true
	
func _physics_process(delta):
	Global.playerDamageZone = deal_damage_zone
	Global.playerHitbox = $PlayerHitbox
	
	#Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if !dead:
	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
		if !current_attack:
			if Input.is_action_just_pressed("left_mouse"):
				current_attack = true
				attack_type = "single"
			set_damage(attack_type)
			handle_attack_animation(attack_type)
		
		handle_movement_animation(direction)
		check_hitbox()
	move_and_slide()
	
func check_hitbox():
	var hitbox_areas = $PlayerHitbox.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() is Enemyknight:
			damage = Global.enemyDamageAmount
		elif hitbox.get_parent() is commander:
			damage = Global.commanderDamageAmount
			
	if can_take_damage:
		take_damage(damage)
		
func take_damage(damage):
	if damage != 0:
		if health > 0:
			health -= damage
			if health <= 0:
				health = 0
				dead = true
				handle_death_animation()
			take_damage_cooldown(1.0)
		
func handle_death_animation():
	animated_sprite.play("death")
	await get_tree().create_timer(3.5).timeout
	Global.playerAlive = false
	self.queue_free()

func take_damage_cooldown(wait_time):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true

func handle_movement_animation(direction):
	if is_on_floor() and !current_attack:
		if !velocity:
			animated_sprite.play("idle")
		if velocity:
			animated_sprite.play("run")
			toggle_flip_sprite(direction)
		elif !is_on_floor() and !current_attack:
			animated_sprite.play("jump")
			
func toggle_flip_sprite(direction):
	if direction > 0:
		animated_sprite.flip_h = false
		deal_damage_zone.scale.x = 1
	elif direction < 0:
		animated_sprite.flip_h = true
		deal_damage_zone.scale.x = -1

func handle_attack_animation(attack_type):
	if current_attack:
		var animation = str(attack_type, "_attack")
		animated_sprite.play(animation)
		toggle_damage_collisions(attack_type)
		
func toggle_damage_collisions(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	var wait_time: float
	if attack_type == "single":
		wait_time = 0.6
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true

func _on_animated_sprite_2d_animation_finished():
	current_attack = false
	
func set_damage(attack_type):
	var current_damage_to_deal: int
	if attack_type == "single":
		current_damage_to_deal = 8
	Global.playerDamageAmount = current_damage_to_deal
