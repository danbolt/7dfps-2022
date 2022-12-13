class_name OmniLightFlicker extends OmniLight


export var base_energy: float = 1.0
export var flicker_magnitude: float = 0.1


func _process(_delta):
	light_energy = lerp(light_energy, base_energy + randf() * flicker_magnitude, 0.8)
