class_name FollowCamera2D
extends Camera2D

@export var _follow_node: Node2D
var follow_node: Node2D:
	get: return _follow_node

@export var smooth_zoom_tween_settings: TweenSettings

var _zoom_tween: Tween

func _ready() -> void:
	set_follow_node(follow_node, true)
	
func _process(delta: float) -> void:
	_process_follow()

func _process_follow() -> void:
	if not follow_node:
		return
	global_position = follow_node.global_position

func set_follow_node(node: Node2D, snap: bool) -> void:
	_follow_node = node
	if not follow_node:
		return
	_process_follow()
	if snap:
		reset_smoothing()

func smooth_zoom_to(to_zoom: Vector2) -> void:
	if _zoom_tween:
		_zoom_tween.stop()
	_zoom_tween = create_tween()
	smooth_zoom_tween_settings.setup_for_tween(_zoom_tween)
	_zoom_tween.tween_property(self, "zoom", to_zoom, smooth_zoom_tween_settings.duration)
