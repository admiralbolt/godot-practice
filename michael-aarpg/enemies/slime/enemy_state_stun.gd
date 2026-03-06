class_name EnemyStateStun extends EnemyState

@export var anim_name: String = "stun"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("AI")
@export var next_state: EnemyState

var _animation_finished: bool = false

func init() -> void:
  enemy.enemy_damaged.connect(_on_enemy_damaged)

func enter() -> void:
  enemy.invincible = true
  _animation_finished = false
  var direction = enemy.global_position.direction_to(enemy.player.global_position)

  enemy.set_direction(direction)
  enemy.velocity = direction * -knockback_speed
  enemy.update_animation(anim_name)
  enemy.animation_player.animation_finished.connect(_on_animation_finished)

func exit() -> void:
  enemy.invincible = false
  enemy.animation_player.animation_finished.disconnect(_on_animation_finished)

func process(delta: float) -> EnemyState:
  if _animation_finished:
    return next_state

  enemy.velocity -= enemy.velocity * decelerate_speed * delta
  return null
  

func physics(_delta: float) -> EnemyState:
  return null

func _on_enemy_damaged(_amount: float) -> void:
  state_machine.change_state(self)

func _on_animation_finished(_anim_name: String) -> void:
  _animation_finished = true
