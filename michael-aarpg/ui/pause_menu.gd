extends CanvasLayer

signal shown
signal hidden

@onready var button_save: Button = $Control/VBoxContainer/ButtonSave
@onready var button_load: Button = $Control/VBoxContainer/ButtonLoad
@onready var item_description: Label = $Control/ItemDescription
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
  set_pause_menu(false)
  button_save.pressed.connect(_on_button_save_pressed)
  button_load.pressed.connect(_on_button_load_pressed)
  

func _on_button_save_pressed() -> void:
  if not visible:
    return

  SaveManager.save_game()
  set_pause_menu(false)

func _on_button_load_pressed() -> void:
  if not visible:
    return

  SaveManager.load_game()
  await LevelManager.level_load_started
  set_pause_menu(false)

func set_pause_menu(status: bool) -> void:
  get_tree().paused = status
  visible = status

  if status:
    self.shown.emit()
  else:
    self.hidden.emit()

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("pause"):
    set_pause_menu(not visible)

    get_viewport().set_input_as_handled()

func update_item_description(new_text: String) -> void:
  item_description.text = new_text

func play_audio(audio: AudioStream) -> void:
  audio_player.stream = audio
  audio_player.play()