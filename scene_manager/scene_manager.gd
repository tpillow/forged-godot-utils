class_name SceneManager
extends Node

var normal_state: StateNode
var trans_state: StateNode

var is_transitioning: bool:
	get: return trans_state.is_active_state()

func _ready() -> void:
	normal_state = StateNode.new()
	normal_state.name = "Normal"
	add_child(normal_state)
	
	trans_state = StateNode.new()
	trans_state.name = "Transition"
	add_child(trans_state)

func set_scene(node: Node) -> void:
	if not is_node_ready():
		set_scene.call_deferred(node)
		return
		
	NodeUtil.remove_all_children(normal_state, true)
	NodeUtil.remove_all_children(trans_state, true)
	if node:
		normal_state.add_child(node)
	normal_state.set_active()

func transition_to(to_node: Node, trans: SceneTransition) -> void:
	assert(not is_transitioning)
	var from_node: Node = normal_state.get_child(0)
	normal_state.remove_child(from_node)
	NodeUtil.remove_all_children(trans_state, true)
	trans.from_node = from_node
	trans.to_node = to_node
	trans.completed.connect(func(): set_scene(to_node), CONNECT_ONE_SHOT)
	trans_state.add_child(trans)
	trans_state.set_active()
