class_name NodeUtil
extends Object

static func find_parent_of_type(node: Node, type: Variant) -> Node:
	while node:
		var parent := node.get_parent()
		if is_instance_of(parent, type):
			return parent
		node = parent
	return null
	
static func find_all_parents_of_type(node: Node, type: Variant) -> Array[Node]:
	var ret: Array[Node] = []
	while node:
		var parent := node.get_parent()
		if is_instance_of(parent, type):
			ret.append(parent)
		node = parent
	return ret

static func find_child_of_type(parent: Node, type: Variant, recursive: bool) -> Node:
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
		if recursive:
			var other := find_child_of_type(child, type, recursive)
			if other:
				return other
	return null

static func find_all_children_of_type(parent: Node, type: Variant, recursive: bool) -> Array[Node]:
	var ret: Array[Node] = []
	for child in parent.get_children():
		if is_instance_of(child, type):
			ret.append(child)
		if recursive:
			ret += find_all_children_of_type(child, type, recursive)
	return ret

static func remove_all_children(node: Node, queue_free_children: bool) -> void:
	for child in node.get_children():
		node.remove_child(child)
		if queue_free_children:
			child.queue_free()
