extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  SignalBus.player_hit.connect(game_over)
  SignalBus.start_game.connect(new_game)

func new_game() -> void:
  get_tree().call_group("mobs", "queue_free")
  $Music.play()
  score = 0
  $HUD.update_score(score)
  $HUD.show_message("Get Ready!")
  $Player.start($StartPosition.position)
  $StartTimer.start()

func game_over() -> void:
  $ScoreTimer.stop()
  $MobTimer.stop()
  $HUD.show_game_over()
  $Music.stop()
  $DeathSound.play()


func _on_mob_timer_timeout() -> void:
  var mob = mob_scene.instantiate()
  var mob_spawn_location = $MobPath/MobSpawnLocation
  mob_spawn_location.progress_ratio = randf()

  mob.position = mob_spawn_location.position
  var direction = mob_spawn_location.rotation + PI / 2

  direction += randf_range(-PI / 4, PI / 4)
  mob.rotation = direction

  var velocity = Vector2(randf_range(150, 250), 0)
  mob.linear_velocity = velocity.rotated(direction)

  add_child(mob)

func _on_score_timer_timeout() -> void:
  score += 1
  $HUD.update_score(score)

func _on_start_timer_timeout() -> void:
  $MobTimer.start()
  $ScoreTimer.start()
