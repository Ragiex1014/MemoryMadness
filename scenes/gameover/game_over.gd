extends Control

@onready var moves_label: Label = $NinePatchRect/MC/VB/Hb/MovesLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)


func on_game_over(moves : int) -> void:
	moves_label.text = str(moves)
	show()

func _on_exit_button_pressed() -> void:
	hide()
	SignalManager.on_exit_pressed.emit()
