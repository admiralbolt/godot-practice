extends Node

const PLAYER = preload("res://player.tscn")
const INVENTORY_DATA = preload("res://ui/inventory/player_inventory.tres")

var player: Player
var player_spawned: bool = false

func _ready() -> void:
  add_player_instance()
  await get_tree().create_timer(1).timeout
  player_spawned = true

func add_player_instance() -> void:
  player = PLAYER.instantiate()
  add_child(player)

func set_player_position(position: Vector2) -> void:
  player.global_position = position

func set_as_parent(parent: Node) -> void:
  if player.get_parent():
    player.get_parent().remove_child(player)
  parent.add_child(player)

func unparent_player(parent: Node) -> void:
  parent.remove_child(player)

func set_health(health: float, max_health: float) -> void:
  player.max_health = max_health
  player.health = health
  player.update_health(0)
