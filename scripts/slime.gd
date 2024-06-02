extends CharacterBody2D

class_name Enemyknight

const speed = 30
var is_enemy_chase: bool = false

var health = 8
var health_max = 8
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 10
var is_dealing_damage: bool = false

var direction: Vector2
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback_force = 200
var is_roaming: bool = true

var player: CharacterBody2D

@onready var detection_area = $Detection_area

func _ready():
	is_enemy_chase = false

func _process(delta):
	Global.enemyDamageAmount = damage_to_deal
	Global.enemyDamageZone = $EnemyDealDamageArea
	
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	if is_on_floor() and dead:
		await get_tree().create_timer(3.0).timeout
		self.queue_free()
		
	move(delta)
	move_and_slide()
	handle_animation()
	
func move(delta):
	player = Global.playerBody
	if !dead:
		is_roaming = true
		if !taking_damage and is_enemy_chase and Global.playerAlive:
			velocity = position.direction_to(player.position) * speed
			direction.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_direction = position.direction_to(player.position) * -30
			velocity = knockback_direction
		else:
			velocity += direction * speed * delta
	elif dead:
		velocity.x = 0
		
		


func _on_dircetion_timer_timeout():
	var direction_timer = $DircetionTimer
	direction_timer.wait_time = choose([0.1, 0.25, 0.5, 1.0])
	if !is_enemy_chase:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
	
func choose(array):
	array.shuffle()
	return array.front()
	
func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		if direction.x == 0:
			animated_sprite.play("default")
		if direction.x < 0:
			animated_sprite.play("walk")
			animated_sprite.flip_h = true
			detection_area.scale.x = -1
		elif direction.x > 0:
			animated_sprite.play("walk")
			animated_sprite.flip_h = false
			detection_area.scale.x = 1
	elif !dead and taking_damage:
		animated_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif !dead and is_dealing_damage:
		animated_sprite.play("single_attack")
		await get_tree().create_timer(0.6).timeout
	if dead and is_roaming:
		is_roaming = false
		animated_sprite.play("death")
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)


func _on_hitbox_area_entered(area):
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		take_damage(damage)
		
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true


func _on_detection_area_body_entered(body):
	if body is Player:
		is_enemy_chase = true
		is_roaming = false


func _on_detection_area_body_exited(body):
	if body is Player:
		is_enemy_chase = false
		is_roaming = true


func _on_enemy_deal_damage_area_area_entered(area):
	if area == Global.playerHitbox:
		is_dealing_damage = true
		await get_tree().create_timer(1.0).timeout
		is_dealing_damage = false
