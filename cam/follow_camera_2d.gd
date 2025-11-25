class_name FollowCamera2D
extends Camera2D

@export var _follow_node: Node2D
var follow_node: Node2D:
	get: return _follow_node

@export var smooth_zoom_tween_settings: TweenSettings

@export_category("Shake")
@export var max_shake_magnitude := 4.0
@export var shake_magnitude := 0.0
@export var shake_decay := 4.0
@export var max_shake_offset := Vector2(8, 8)
@export var max_shake_rotation_degs := 0.0
@export var shake_noise: FastNoiseLite = FastNoiseLite.new()
@export var randomize_shake_noise_seed_on_start := true

var _zoom_tween: Tween
var _shake_noise_timer := 0.0

func _ready() -> void:
	if randomize_shake_noise_seed_on_start:
		shake_noise.seed = randi()
	set_follow_node(follow_node, true)
	
func _process(delta: float) -> void:
	_process_follow()
	_process_shake(delta)

func _process_shake(delta: float) -> void:
	shake_magnitude = clamp(shake_magnitude - shake_decay * delta, 0, max_shake_magnitude)
	_shake_noise_timer += 1
	var shake_modifier := shake_magnitude / max_shake_magnitude
	offset.x = shake_modifier * max_shake_offset.x * shake_noise.get_noise_2d(_shake_noise_timer, 0)
	offset.y = shake_modifier * max_shake_offset.y * shake_noise.get_noise_2d(_shake_noise_timer, 1000)
	rotation_degrees = shake_modifier * max_shake_rotation_degs * shake_noise.get_noise_2d(_shake_noise_timer, 2000)

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
