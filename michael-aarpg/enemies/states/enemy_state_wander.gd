class_name EnemyStateWander extends EnemyState

@export var anim_name: String = "walk"
@export var wander_speed: float = 33.3

@export_category("AI")
@export var state_animation_duration: float = 0.7
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 3

@export var state_duration_min: float = 0.5
@export var state_duration_max: float = 1.5
@export var next_state: EnemyState

var _timer: float = 0.0

func enter() -> void:
  _timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
  var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
  enemy.set_direction(direction)
  enemy.velocity = direction * wander_speed
  enemy.update_animation(anim_name)
  pass

func exit() -> void:
  pass

func process(delta: float) -> EnemyState:
  _timer -= delta
  if _timer <= 0.0:
    return next_state
  return null
  

func physics(_delta: float) -> EnemyState:
  return null



