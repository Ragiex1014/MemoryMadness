extends TextureButton

class_name MemoryTile

@onready var frame_image: TextureRect = $FrameImage
@onready var item_image: TextureRect = $ItemImage

var _item_name : String
var can_select_me : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_selection_disable.connect(on_selection_disable)
	SignalManager.on_selection_enabled.connect(on_selection_enable)


func get_item_name() -> String:
	return _item_name


func reveal(r: bool) -> void :
	frame_image.visible = r
	item_image.visible = r

func setup(ii_dict: Dictionary, fimage : CompressedTexture2D) -> void:
	frame_image.texture = fimage;
	item_image.texture = ii_dict.item_texture
	_item_name = ii_dict.item_name
	reveal(false)


func kill_on_success() -> void :
	z_index = 1
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "disable", true, 0)
	tween.tween_property(self, "rotation", deg_to_rad(720), 0.5)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.5)
	tween.set_parallel(false)
	tween.tween_interval(0.6)
	tween.tween_property(self, "scale", Vector2(0, 0), 0)


func on_selection_disable() -> void:
	can_select_me = false
	

func on_selection_enable() -> void:
	can_select_me = true


func _on_pressed() -> void:
	if can_select_me == true :
		SignalManager.on_tile_selected.emit(self)
