shader_type canvas_item;

const int MAX_PALETTE_SIZE = 10;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;
uniform int palette_size;
uniform vec4 palette[MAX_PALETTE_SIZE] : source_color;

void fragment() {
	vec4 screen_color = texture(screen_tex, SCREEN_UV);
	float rgb_avg = (screen_color.r + screen_color.g + screen_color.b) / 3.0;
	float palette_step = 1.0 / float(palette_size);
	
	for(int i = 1;i <= palette_size;i++){
		if(rgb_avg < palette_step * float(i) || i == palette_size){
			COLOR = palette[i - 1];
			break;
		}
	}
}
