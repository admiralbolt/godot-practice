class_name PlayerAttackState extends State

var attacking: bool = false

@onready var idle_state: PlayerIdleState = $"../PlayerIdleState"
@onready var walk_state: PlayerWalkState = $"../PlayerWalkState"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter() -> void:
  attacking = true
  player.update_animation("attack")
  player.attack_effect.visible = true
  player.hurt_box.monitoring = true
  animation_player.animation_finished.connect(end_attack)

func exit() -> void:
  player.attack_effect.visible = false
  player.hurt_box.monitoring = false
  attacking = false
  animation_player.animation_finished.disconnect(end_attack)

func end_attack(_anim_name: String) -> void:
  attacking = false


func process(_delta: float) -> State:
  if attacking:
    player.velocity = player.direction * 150.5 * 0.6
    return null

  if player.direction == Vector2.ZERO:
    return idle_state

  return walk_state
