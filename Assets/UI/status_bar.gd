extends Control

@onready var fuel_bar = $FuelBar
@onready var score_label = $Score
@onready var life_counter = $LifeCounter

var score: int = 0

var player: Player

func _ready() -> void:
	for collectable in get_tree().get_nodes_in_group("collectable"):
		collectable.connect("collected", _collect_treasure)
		
	player = get_tree().get_nodes_in_group("player")[0]
	player.connect("fuel_changed", _on_fuel_changed)
	player.connect("lives_changed", _on_lives_changed)
	_on_fuel_changed(player.fuel)
	_on_lives_changed(player.lives)
		
	
func _on_fuel_changed(fuel):
	fuel_bar.set_value(fuel / player.max_fuel * 100)
	
func _on_lives_changed(lives):
	life_counter.set_text("%02d" % [lives])

func _collect_treasure(points):
	score += points
	score_label.set_text("%06d" % [score])
