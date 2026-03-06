class_name PlayerWalkState extends State

@export var move_speed: float = 150.5

@onready var idle_state: PlayerIdleState = $"../PlayerIdleState"
@onready var attack_state: PlayerAttackState = $"../PlayerAttackState"

func enter() -> void:
  player.update_animation("walk")

func process(_delta: float) -> State:
  if player.direction == Vector2.ZERO:
    player.velocity = Vector2.ZERO
    return idle_state

  player.velocity = player.direction * move_speed

  if player.set_direction():
    player.update_animation("walk")

  return null

func handle_input(event: InputEvent) -> void:
  if event.is_action_pressed("attack"):
    state_machine.change_state(attack_state)