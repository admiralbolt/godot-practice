class_name PlayerStunState extends State

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export var invincible_duration: float = 1.0

var hurt_box: HurtBox
var direction: Vector2
var next_state: State = null

@onready var idle_state: PlayerIdleState = $"../PlayerIdleState"
@onready var attack_state: PlayerAttackState = $"../PlayerAttackState"


func init() -> void:
  player.player_damaged.connect(_on_player_damaged)

func enter() -> void:
  player.animation_player.animation_finished.connect(_on_stun_animation_finished)
  direction = player.global_position.direction_to(hurt_box.global_position)
  player.velocity = direction * -knockback_speed
  player.set_direction()
  player.update_animation("stun")
  player.make_invincible(invincible_duration)
  player.effect_animation_player.play("damaged")

func exit() -> void:
  next_state = null
  player.animation_player.animation_finished.disconnect(_on_stun_animation_finished)

func process(delta: float) -> State:
  player.velocity -= player.velocity * decelerate_speed * delta
  return next_state

func _on_stun_animation_finished(_anim_name: String) -> void:
  next_state = idle_state

func _on_player_damaged(p_hurt_box: HurtBox) -> void:
  hurt_box = p_hurt_box
  state_machine.change_state(self)