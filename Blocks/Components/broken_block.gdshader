shader_type canvas_item;

instance vec4 colour : source_color;
instance float darkness_amount : hint_range(0, 1.0) = 0.5;

void fragment() {
	vec4 pixelColour = texture(TEXTURE, UV);
	vec4 darkness = mix(pixelColour, colour * darkness_amount, darkness_amount);
	
	COLOR = pixelColour * darkness;
}