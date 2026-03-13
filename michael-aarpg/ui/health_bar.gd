class_name HealthBar extends ProgressBar

var player: Player
@onready var health_text: Label = $HealthText


func _ready() -> void:
  player = PlayerManager.player
  # Set our min / max values based on player health.
  health_text.text = str(player.health) + " / " + str(player.max_health)
  value = (player.health / player.max_health) * 100

  # Connect to the player's health damaged signal.
  player.player_damaged.connect(_on_player_damaged)

func _on_player_damaged(hurt_box: HurtBox) -> void:
  # Update the health bar value to match the player's current health.
  health_text.text = str(player.health) + " / " + str(player.max_health)
  value = (player.health / player.max_health) * 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
