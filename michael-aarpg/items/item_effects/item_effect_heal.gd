class_name ItemEffectHeal extends ItemEffect

@export var heal_amount: float = 1
@export var sound: AudioStream

func use() -> void:
  PlayerManager.player.update_health(heal_amount)
  PauseMenu.play_audio(sound)