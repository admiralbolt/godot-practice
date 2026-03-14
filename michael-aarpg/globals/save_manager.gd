extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save: Dictionary = {
  "scene_path": "",
  "player": {
    "health": 1,
    "max_health": 1,
    "pos_x": 0,
    "pos_y": 0
  },
  "items": [],
  "persistence": [],
  "quests": []
}

func save_game() -> void:
  current_save["player"] = {
    "health": PlayerManager.player.health,
    "max_health": PlayerManager.player.max_health,
    "pos_x": PlayerManager.player.global_position.x,
    "pos_y": PlayerManager.player.global_position.y
  }

  current_save["scene_path"] = get_tree().current_scene.scene_file_path

  var file: FileAccess = FileAccess.open(SAVE_PATH + "save_game.json", FileAccess.WRITE)
  file.store_line(JSON.stringify(current_save))
  file.close()
  game_saved.emit()

func load_game() -> void:
  var file: FileAccess = FileAccess.open(SAVE_PATH + "save_game.json", FileAccess.READ)
  if not file:
    return

  var json: JSON = JSON.new()
  json.parse(file.get_line())
  file.close()

  current_save = json.get_data() as Dictionary

  LevelManager.load_new_level(current_save["scene_path"], "", Vector2.ZERO)
  await LevelManager.level_load_started

  PlayerManager.set_player_position(Vector2(current_save["player"]["pos_x"], current_save["player"]["pos_y"]))
  PlayerManager.set_health(current_save["player"]["health"], current_save["player"]["max_health"])

  await LevelManager.level_loaded
  game_loaded.emit()

  
