extends CanvasLayer


func show_message(text: String) -> void:
  $Message.text = text
  $Message.show()
  $MessageTimer.start()

func show_game_over():
  show_message("You suck.")
  await $MessageTimer.timeout

  $Message.text = "Dodge the Creeps!"
  $Message.show()
  await get_tree().create_timer(1.0).timeout
  $StartButton.show()

func update_score(score: int) -> void:
  $ScoreLabel.text = str(score)

func _on_start_button_pressed():
  $StartButton.hide()
  SignalBus.start_game.emit()

func _on_message_timer_timeout():
  $Message.hide()