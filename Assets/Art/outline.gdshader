shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;
uniform bool show_outline = false;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	if (show_outline) {
		vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
		float outline = 0.0;
		
		// Sample surrounding pixels
		outline += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
		outline += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
		
		outline = min(outline, 1.0);
		
		// Draw outline where there's no sprite but neighbors exist
		vec4 final_color = mix(color, outline_color, outline * (1.0 - color.a));
		COLOR = final_color;
	} else {
		COLOR = color;
	}
}
