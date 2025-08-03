class_name MathUtil
extends Object

# Take an angle in degrees, and normalize it to [0.0, 360.0)
static func normalize_deg_angle(angle: float) -> float:
	return fmod(fmod(angle, 360.0) + 360.0, 360.0)

# Take an angle in radians, and normalize it to [0.0, TAU)
static func normalize_rad_angle(angle: float) -> float:
	# TODO: do this without the conversion to normal degrees...
	return deg_to_rad(normalize_deg_angle(rad_to_deg(angle)))
