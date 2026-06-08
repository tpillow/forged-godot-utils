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

enum Dir8 {
	LEFT, RIGHT, UP, DOWN,
	UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT,
}

static func dir8_to_vec2(dir: Dir8) -> Vector2:
	match dir:
		Dir8.LEFT: return Vector2.LEFT
		Dir8.RIGHT: return Vector2.RIGHT
		Dir8.UP: return Vector2.UP
		Dir8.DOWN: return Vector2.DOWN
		Dir8.UP_LEFT: return Vector2(-1, -1)
		Dir8.UP_RIGHT: return Vector2(1, -1)
		Dir8.DOWN_LEFT: return Vector2(-1, 1)
		Dir8.DOWN_RIGHT: return Vector2(1, 1)
		_: assert(false); return Vector2.ZERO
