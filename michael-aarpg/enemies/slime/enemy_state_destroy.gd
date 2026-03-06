class_name EnemyDestroyStun extends EnemyState

@export var anim_name: String = "destroy"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

func init() -> void:
  enemy.enemy_destroyed.connect(_on_enemy_destroyed)

func enter() -> void:
  enemy.invincible = true
  var direction = enemy.global_position.direction_to(enemy.player.global_position)

  enemy.set_direction(direction)
  enemy.velocity = direction * -knockback_speed
  enemy.update_animation(anim_name)
  enemy.animation_player.animation_finished.connect(_on_animation_finished)
  enemy.set_collision_layer_value(5, false)
  enemy.set_collision_layer_value(9, false)

func exit() -> void:
  enemy.invincible = false
  enemy.animation_player.animation_finished.disconnect(_on_animation_finished)

func process(delta: float) -> EnemyState:
  enemy.velocity -= enemy.velocity * decelerate_speed * delta
  return null

func _on_enemy_destroyed() -> void:
  state_machine.change_state(self)

func _on_animation_finished(_anim_name: String) -> void:
  enemy.queue_free()
