class_name VisionArea extends Area2D

signal player_entered()
signal player_exited()

func _ready() -> void:
  self.body_entered.connect(self._on_body_entered)
  self.body_exited.connect(self._on_body_exited)

  var p = get_parent()
  if p is Enemy:
    p.direction_changed.connect(self._on_direction_changed)

func _on_body_entered(body: Node2D) -> void:
  if body is Player:
    self.player_entered.emit()

func _on_body_exited(body: Node2D) -> void:
  if body is Player:
    self.player_exited.emit()

func _on_direction_changed(new_direction: Vector2) -> void:
  var cardinal_direction: Vector2 = Vector2.UP.rotated(round(new_direction.angle() / TAU * 4) * TAU / 4).snapped(Vector2.ONE)

  rotation_degrees = cardinal_direction.angle() * 180 / PI