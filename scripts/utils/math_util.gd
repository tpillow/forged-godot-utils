class_name MathUtil
extends Object

# Take an angle in degrees, and normalize it to [0.0, 360.0)
static func normalize_deg_angle(angle: float) -> float:
	return fmod(fmod(angle, 360.0) + 360.0, 360.0)

# Take an angle in radians, and normalize it to [0.0, TAU)
static func normalize_rad_angle(angle: float) -> float:
	return angle - floor(angle / TAU) * TAU

static func rand_deg_angle() -> float:
	return randf_range(0.0, 359.9999)

static func rand_rad_angle() -> float:
	return randf_range(0.0, TAU - 0.0001)
