class_name NodeUtil
extends Object

static func findParentOfType(node: Node, type: Variant) -> Node:
	while node:
		var parent := node.get_parent()
		if is_instance_of(parent, type):
			return parent
		node = parent
	return null
	
static func findParentsOfType(node: Node, type: Variant) -> Array[Node]:
	var ret: Array[Node] = []
	while node:
		var parent := node.get_parent()
		if is_instance_of(parent, type):
			ret.append(parent)
		node = parent
	return ret

static func findChildOfType(parent: Node, type: Variant, recursive: bool) -> Node:
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
		if recursive:
			var other := findChildOfType(child, type, recursive)
			if other:
				return other
	return null

static func findChildrenOfType(parent: Node, type: Variant, recursive: bool) -> Array[Node]:
	var ret: Array[Node] = []
	for child in parent.get_children():
		if is_instance_of(child, type):
			ret.append(child)
		if recursive:
			ret += findChildrenOfType(child, type, recursive)
	return ret
