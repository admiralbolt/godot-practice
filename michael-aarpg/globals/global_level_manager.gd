extends Node

signal level_load_started
signal level_loaded
signal tilemap_bounds_changed(bounds: Array[Vector2])

var current_tilemap_bounds: Array[Vector2]
var target_transition: String
var position_offset: Vector2

func _ready() -> void:
  await get_tree().process_frame

  level_loaded.emit()

func load_new_level(level_path: String, p_target_transition: String, p_position_offset: Vector2) -> void:
  print("load_new_level called with: ", level_path, target_transition, position_offset)

  target_transition = p_target_transition
  position_offset = p_position_offset

  get_tree().paused = true

  await SceneTransition.fade_out()

  level_load_started.emit()

  await get_tree().process_frame
  
  get_tree().change_scene_to_file(level_path)

  await SceneTransition.fade_in()

  get_tree().paused = false

  await get_tree().process_frame

  level_loaded.emit()

func change_tilemap_bounds(bounds: Array[Vector2]) -> void:
  current_tilemap_bounds = bounds
  emit_signal("tilemap_bounds_changed", bounds)
