extends Node

class_name Scorer

@onready var sound: AudioStreamPlayer = $Sound
@onready var reveal_timer: Timer = $RevealTimer


var selections: Array = []
var target_pairs : int = 0
var moves_made : int = 0
var pairs_made : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_tile_selected.connect(on_tile_selected)
	SignalManager.on_exit_pressed.connect(on_exit_pressed)


func get_moves_made_str() -> String:
	return str(moves_made)

func get_pairs_made_str() -> String:
	return "%s / %s" % [pairs_made, target_pairs]


func selections_are_pair() -> bool:
	return (
		selections[0].get_instance_id() != selections[1].get_instance_id()
		and 
		selections[0].get_item_name() == selections[1].get_item_name()
		)

func clear_new_game(target: int) -> void:
	selections.clear()
	pairs_made = 0
	moves_made = 0
	target_pairs = target


func kill_tiles() -> void:
	for s in selections:
		s.kill_on_success()
	pairs_made += 1
	SoundManager.play_sound(sound, SoundManager.SOUND_SUCCESS)

func hide_selection() -> void :
	for s in selections:
		s.reveal(false)

func update_selections() -> void:
	reveal_timer.start()
	if selections_are_pair() == true :
		kill_tiles()

func check_pair_made(tile : MemoryTile) -> void:
	tile.reveal(true)
	selections.append(tile)
	
	if selections.size() != 2 :
		return
	
	SignalManager.on_selection_disable.emit()
	moves_made += 1
	
	update_selections()
	

func on_tile_selected(tile : MemoryTile) -> void:
	SoundManager.play_tile_click(sound)
	check_pair_made(tile)


func _on_reveal_timer_timeout() -> void:
	if selections_are_pair() == false:
		hide_selection()
	selections.clear()
	check_game_over()
	SignalManager.on_selection_enabled.emit()

func on_exit_pressed() -> void:
	reveal_timer.stop()

func check_game_over() -> void:
	if pairs_made >= target_pairs :
		SignalManager.on_game_over.emit(moves_made)
		
