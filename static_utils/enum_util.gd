class_name EnumUtil
extends Object

enum Dir4 {
	LEFT, RIGHT, UP, DOWN,
}

static func dir4_to_vec2(dir: Dir4) -> Vector2:
	match dir:
		Dir4.LEFT: return Vector2.LEFT
		Dir4.RIGHT: return Vector2.RIGHT
		Dir4.UP: return Vector2.UP
		Dir4.DOWN: return Vector2.DOWN
		_: assert(false); return Vector2.ZERO
