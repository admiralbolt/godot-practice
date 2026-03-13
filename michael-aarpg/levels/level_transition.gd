@tool
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file("*.tscn") var level: String
@export var target_transition_area: String = "LevelTransition"

@export_category("Collision Area Settings")
@export_range(1, 12, 1, "or_greater") var size: int = 2: set = _set_size
@export var side: SIDE = SIDE.LEFT: set = _set_side
@export var snap_to_grid: bool = true: set = _set_snap_to_grid
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _set_size(p_size: int) -> void:
  size = p_size
  _update_area()

func _set_side(p_side: SIDE) -> void:
  side = p_side
  _update_area()

func _set_snap_to_grid(_p_snap: bool) -> void:
  _snap_to_grid()

func _ready() -> void:
  _update_area()

  if Engine.is_editor_hint():
    return

  monitoring = false
  _place_player()

  await LevelManager.level_loaded
  body_entered.connect(_on_body_entered)
  monitoring = true


func _on_body_entered(_body: Node2D) -> void:
  print("Transitioning to level: ", level)
  var offset: Vector2 = Vector2.ZERO
  var player_pos: Vector2 = PlayerManager.player.global_position
  if side == SIDE.LEFT or side == SIDE.RIGHT:
    offset.y = player_pos.y - global_position.y
    offset.x = 16 if side == SIDE.RIGHT else -16
  else:
    offset.x = player_pos.x - global_position.x
    offset.y = 16 if side == SIDE.BOTTOM else -16

  LevelManager.load_new_level(level, target_transition_area, offset)

func _place_player() -> void:
  if name != LevelManager.target_transition:
    return

  PlayerManager.set_player_position(global_position + LevelManager.position_offset)


func _update_area() -> void:
  var new_rect: Vector2 = Vector2(32, 32)
  var new_position: Vector2 = Vector2.ZERO

  if side == SIDE.TOP:
    new_rect.x *= size
    new_position.y -= 16
  elif side == SIDE.BOTTOM:
    new_rect.x *= size
    new_position.y += 16
  elif side == SIDE.LEFT:
    new_rect.y *= size
    new_position.x -= 16
  elif side == SIDE.RIGHT:
    new_rect.y *= size
    new_position.x += 16


  if collision_shape == null:
    collision_shape = get_node("CollisionShape2D")

  collision_shape.shape.size = new_rect
  collision_shape.position = new_position

func _snap_to_grid() -> void:
  position.x = round(position.x / 16) * 16
  position.y = round(position.y / 16) * 16

  
