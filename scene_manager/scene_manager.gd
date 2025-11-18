class_name SceneManager
extends Node

var overlays_canvas_layer_num: int = 100
var ui_canvas_layer_num: int = 50

var trans_instant := SceneTransitionInstant.new()
var trans_color_from_center := SceneTransitionColorFromCenter.new()
var trans_fade := SceneTransitionFade.new()

var _scenes_container: Node
var _overlays_container: CanvasLayer

var top_scene: Node:
	get: return (
		_scenes_container.get_child(-1)
		if _scenes_container.get_child_count() > 0
		else null )
	
func _ready() -> void:
	_scenes_container = Node.new()
	add_child(_scenes_container)
	_overlays_container = CanvasLayer.new()
	_overlays_container.layer = overlays_canvas_layer_num
	add_child(_overlays_container)

func _pop_all_scenes(free: bool = true) -> Array[Node]:
	var ret: Array[Node] = []
	while top_scene:
		ret.append(_pop_scene(free))
	return ret
	
func _pop_scene(free: bool = true) -> Node:
	var scene := top_scene
	assert(scene)
	scene.get_parent().remove_child(scene)
	if free:
		scene.queue_free()
	return scene
	
func _push_scene(scene: Node) -> void:
	_scenes_container.add_child(scene)

func _disable_top_scene() -> void:
	assert(top_scene)
	top_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
func _enable_top_scene() -> void:
	assert(top_scene)
	top_scene.process_mode = Node.PROCESS_MODE_INHERIT
	
func _wrap_in_ui_canvas(node: Node) -> CanvasLayer:
	var canvas := CanvasLayer.new()
	canvas.layer = ui_canvas_layer_num
	canvas.add_child(node)
	return canvas
	
func replace_all(new_scene: Node, transition: SceneTransition) -> void:
	transition.begin(self, SceneTransition.Type.REPLACE_ALL, new_scene)

func replace_all_with_ui(new_scene: Node, transition: SceneTransition) -> void:
	replace_all(_wrap_in_ui_canvas(new_scene), transition)

func replace(new_scene: Node, transition: SceneTransition) -> void:
	transition.begin(self, SceneTransition.Type.REPLACE, new_scene)

func replace_with_ui(new_scene: Node, transition: SceneTransition) -> void:
	replace(_wrap_in_ui_canvas(new_scene), transition)

func push(new_scene: Node, transition: SceneTransition) -> void:
	transition.begin(self, SceneTransition.Type.PUSH, new_scene)

func push_ui(new_scene: Node, transition: SceneTransition) -> void:
	push(_wrap_in_ui_canvas(new_scene), transition)

func pop(transition: SceneTransition) -> void:
	transition.begin(self, SceneTransition.Type.POP, null)
