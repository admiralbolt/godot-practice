class_name PlayerIdleState extends State

@onready var walk_state: PlayerWalkState = $"../PlayerWalkState"
@onready var attack_state: PlayerAttackState = $"../PlayerAttackState"

func enter() -> void:
  player.update_animation("idle")
  player.velocity = Vector2.ZERO

func process(_delta: float) -> State:
  if player.direction != Vector2.ZERO:
    return walk_state

  return null

func handle_input(event: InputEvent) -> void:
  if event.is_action_pressed("attack"):
    state_machine.change_state(attack_state)

  if event.is_action_pressed("interact"):
    PlayerManager.interact_pressed.emit()