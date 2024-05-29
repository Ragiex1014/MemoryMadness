extends Control

@export var level_button_scene : PackedScene
@onready var hb_levels: HBoxContainer = $VB/HbLevels

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_grid()


func create_level_btn(ln : int) -> void :
	var new_lb = level_button_scene.instantiate()
	hb_levels.add_child(new_lb)
	new_lb.set_level_number(ln)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func setup_grid() -> void :
	for level in GameManager.LEVELS:
		create_level_btn(level)
