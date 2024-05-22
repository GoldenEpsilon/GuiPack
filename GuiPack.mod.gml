//A bunch of useful functions (mainly gui related) that I find useful
//You are free to use any part of GuiPack in your mods as long as you credit me (Golden Epsilon) in the code
/*OBJECTS (make a customObject and set GuiPack to the name in this list)
gp_ticker: x:number, y:number, w:number, h:number, text:string, ?ticker_speed:number, ?offset:number, ?color:color ?font:index, ?fontWidth:number, ?fontHeight:number, timing:["draw", "draw_gui"]
*/
/*FUNCTIONS
gp_ticker(x:number, y:number, w:number, h:number text:string, ?speed:number, ?offset:number, ?color:color ?font:index, ?fontWidth:number):
gp_button_check(x:number, y:number, w:number, h:number, ?hold:bool, ?index:number):
*/

#define init
global.inputHolds = [];
for(var i = 0; i < maxp; i++){
	array_push(global.inputHolds, 0);
}
global.tooltips = [];

//these are basically unit tests, right?
{
/*with(gp_create_object("gp_ticker", "GPTestTicker")){
	x = game_width - 320 + 140;
	y = 185;
	w = 180;
	h = 10;
	depth = 1000;
	bgColor = 0;
	color = c_red;
	font = fntChat;
	fontWidth = 5;
	text = "GuiPack      ";
//}

with(gp_create_object("gp_window", "GPTestWindow")){
	x = 110;
	y = 50;
	w = 140;
	h = 110;
	name = "Test Window";
	colorH = make_color_rgb(90,90,90);
	color = make_color_rgb(70,70,70);
	colorIH = make_color_rgb(40,40,40);
	bgColor = make_color_rgb(10,10,20);
	bannerColorHighlight = make_color_rgb(120,200,80);
	bannerColor = c_green;
	gpmarkup = [
		gpsurf_text_setup("Testing this @qout#let's see if this wooooooooooooooooooooooorks", fntChat),
		gpsurf_image_setup(sprBanditIdle, 0),
		gpsurf_image_setup(sprBanditIdle, 0),
		gpsurf_obj_setPos(gpsurf_obj_setSameLine(gpsurf_text_setup("Hi.", fntM0)), 0, 7),
		gpsurf_obj_setPos(gpsurf_obj_setSameLine(gpsurf_image_setup(sprBanditIdle, 0)), 0, 7),
		gpsurf_obj_setPos(gpsurf_obj_setSameLine(gpsurf_image_setup(sprBanditIdle, 0)), 0, -7)
	];
//}*/
}

#define cleanup
with(instances_matching_ne(CustomObject, "GuiPack", null)){
	instance_destroy();
}

#define step
with(instances_matching_ne(instances_matching(CustomObject, "GuiPack", "gp_ticker"), "ready", true)){
	if("fontWidth" not in self){fontWidth = 8}
	if("fontHeight" not in self){fontHeight = 8}
	if("w" not in self){w = game_width - x + fontWidth}
	if("h" not in self){h = max(game_height - y, fontHeight)}
	if("text" not in self){text = ""}
	if("ticker_speed" not in self){ticker_speed = 1}
	if("offset" not in self){offset = current_frame}
	if("color" not in self){color = c_white}
	if("font" not in self){font = fntM0}
	if("bgColor" not in self){bgColor = "trans"}
	gpdraw = -1;
	ready = true;
	surf = -1;
}
with(instances_matching_ne(instances_matching(CustomObject, "GuiPack", "gp_window"), "ready", true)){
	if("bannerHeight" not in self){bannerHeight = 8}bannerHeight = 8;//it doesn't work with other heights because I don't want to program that X
	if("w" not in self){w = game_width - x}
	if("h" not in self){h = max(game_height - y, bannerHeight)}
	if("color" not in self){color = c_silver}
	if("colorH" not in self){colorH = make_color_rgb(230,230,230)}
	if("colorIH" not in self){colorIH = make_color_rgb(150,150,150)}
	if("bannerColorHighlight" not in self){bannerColorHighlight = make_color_rgb(50,200,255)}
	if("bannerColor" not in self){bannerColor = make_color_rgb(50,80,220)}
	if("bgColor" not in self){bgColor = c_white}
	if("nameColor" not in self){nameColor = c_white}
	if("name" not in self){name = ""}
	if("on_close" not in self){on_close = script_ref_create(nullScr);}
	if("on_step" not in self){on_step = script_ref_create(nullScr);}
	gpdraw = -1;
	hold = -1;
	holdType = -1;
	holdx = x;
	holdy = y;
	ready = true;
	surf = -1;
}
with(instances_matching_ne(instances_matching(CustomObject, "GuiPack", "gp_button"), "ready", true)){
	if("image" not in self){image = null;}
	if("clickScr" not in self){clickScr = script_ref_create(nullScr);}
	if("hoverScr" not in self){hoverScr = script_ref_create(nullScr);}
	if("holdScr" not in self){holdScr = script_ref_create(nullScr);}
	if("stepScr" not in self){stepScr = script_ref_create(nullScr);}
	if("w" not in self){if(image == null){w = 50;}else{w = sprite_get_width(image)}}
	if("h" not in self){if(image == null){h = 50;}else{h = sprite_get_height(image)}}
	if("bgColor" not in self){bgColor = c_silver}
	if("bgAlpha" not in self){bgAlpha = 1}
	if("clicked" not in self){clicked = 0;}
	gpdraw = -1;
	ready = true;
	surf = -1;
}

//I use draw for stuff you'd normally use step for so that input doesn't lag behind like a frame.
//I could also use a custom step but meh
#define draw
for(var i = 0; i < maxp; i++){
	if(!button_check(i, "fire")){
		global.inputHolds[i] = 0;
	}
}
with(instances_matching(instances_matching(CustomObject, "GuiPack", "gp_window"), "ready", true)){
	if(hold < 0 || !global.inputHolds[hold]){
		if(gp_button_check(x + w - bannerHeight, y + 2, bannerHeight - 2, bannerHeight - 2)){
			hold = gp_button_index(x + w - bannerHeight, y + 2, bannerHeight - 2, bannerHeight - 2);
			if(hold >= 0){
				holdType = 5;
				global.inputHolds[hold]++;
			}
		}else if(gp_button_check(x + 1, y + 1, w - 2, bannerHeight)){
			hold = gp_button_index(x + 1, y + 1, w - 2, bannerHeight);
			if(hold >= 0){
				holdType = 0;
				holdx = mouse_x[hold];
				holdy = mouse_y[hold];
				global.inputHolds[hold]++;
			}
		}else if(gp_button_check(x, y-1, w, 2)){
			hold = gp_button_index(x, y-1, w, 2);
			if(hold >= 0){
				holdType = 1;
				holdy = mouse_y[hold];
				global.inputHolds[hold]++;
			}
		}else if(gp_button_check(x-1, y, 2, h)){
			hold = gp_button_index(x-1, y, 2, h);
			if(hold >= 0){
				holdType = 2;
				holdx = mouse_x[hold];
				global.inputHolds[hold]++;
			}else{
				hold = -1;
			}
		}else if(gp_button_check(x, y+h-1, w, 2)){
			hold = gp_button_index(x, y+h-1, w, 2);
			if(hold >= 0){
				holdType = 3;
				holdy = mouse_y[hold];
				global.inputHolds[hold]++;
			}
		}else if(gp_button_check(x+w-1, y, 2, h)){
			hold = gp_button_index(x+w-1, y, 2, h);
			if(hold >= 0){
				holdType = 4;
				holdx = mouse_x[hold];
				global.inputHolds[hold]++;
			}
		}
	}
	if(hold >= 0 && global.inputHolds[hold] == 1){
		switch(holdType){
			case 0:
				x += mouse_x[hold] - holdx;
				holdx = mouse_x[hold];
				y += mouse_y[hold] - holdy;
				holdy = mouse_y[hold];
				if(!button_check(hold, "fire")){
					hold = -1;
				}
				break;
			case 1:
				y += mouse_y[hold] - holdy;
				h -= mouse_y[hold] - holdy;
				holdy = mouse_y[hold];
				if(!button_check(hold, "fire")){
					hold = -1;
				}
				break;
			case 2:
				x += mouse_x[hold] - holdx;
				w -= mouse_x[hold] - holdx;
				holdx = mouse_x[hold];
				if(!button_check(hold, "fire")){
					hold = -1;
				}
				break;
			case 3:
				h += mouse_y[hold] - holdy;
				holdy = mouse_y[hold];
				if(!button_check(hold, "fire")){
					hold = -1;
				}
				break;
			case 4:
				w += mouse_x[hold] - holdx;
				holdx = mouse_x[hold];
				if(!button_check(hold, "fire")){
					hold = -1;
				}
				break;
			case 5:
				script_ref_call(on_close, self);
				global.inputHolds[hold] = 0;
				instance_destroy();
				break;
		}
	}else if(hold >= 0){
		global.inputHolds[hold]--;
		hold = -1;
	}
	if(instance_exists(self)){
		draw_set_font(fntChat);
		var tw = w;
		var th = h;
		w = max(w,bannerHeight + 9 + string_width(name));
		h = max(h,bannerHeight + 7);
		holdx -= tw-w;
		holdy -= th-h;
		draw_set_font(fntM0);
	}
}
with(instances_matching(instances_matching(CustomObject, "GuiPack", "gp_ticker"), "ready", true)){
	surface_destroy(surf);
	surf = gp_ticker(0,0,w,h,text,ticker_speed,offset,color,font,fontWidth,fontHeight,bgColor);
	if(depth < 1000){gpdraw = script_bind_draw(gp_ticker_draw, depth, x, y, surf);}
}
with(instances_matching(instances_matching(CustomObject, "GuiPack", "gp_button"), "ready", true)){
	hover = false;
	for(var i = 0; i < 4; i++){
		var mouseX = mouse_x[i]-view_xview[i];
		var mouseY = mouse_y[i]-view_yview[i];
		if(!hover){hover = point_in_rectangle(mouseX,mouseY,x,y,x+w,y+h) * (index + 1);}
	}
	if(hover){
		script_ref_call(hoverScr, self, hover - 1);
		if(!instance_exists(self)){continue;}
	}
	if(gp_button_check(x, y, w, h)){
		var index = gp_button_index(x, y, w, h);
		if(index >= 0 && !global.inputHolds[index]){
			script_ref_call(clickScr, self, index);
			if(!instance_exists(self)){continue;}
			clicked = 2;
		}
	}
	if(gp_button_check(x, y, w, h, 1)){
		var index = gp_button_index(x, y, w, h);
		if(index >= 0 && !global.inputHolds[index]){
			script_ref_call(holdScr, index);
			if(!instance_exists(self)){continue;}
		}
	}
	script_ref_call(stepScr, self);
	if(!instance_exists(self)){continue;}
}

#define draw_gui
with(instances_matching(CustomObject, "GuiPack", "gp_ticker")){
	if("surf" in self){
		if(depth >= 1000){gp_ticker_draw(x,y,surf);}
	}
}
with(instances_matching(instances_matching(CustomObject, "GuiPack", "gp_button"), "ready", true)){
	draw_set_colour(c_black);
	draw_set_alpha(0.3);
	draw_rectangle(x+1, y+1, x+w, y+h, 0);
	draw_set_alpha(1);
	if(image == null){
		draw_set_colour(color);
		draw_rectangle(x + (clicked > 0), y + (clicked > 0), x+w - 1, y+h - 1, 0);
	}else{
		draw_sprite_stretched(image, 0, x + (clicked > 0), y + (clicked > 0), w, h);
	}
	clicked--;
}
var inst = instances_matching(instances_matching(CustomObject, "GuiPack", "gp_window"), "ready", true);
for(i = array_length(inst) - 1; i >= 0; i--){
	with(inst[i]){
		if("gpscroll" not in self){gpscroll = 0;}
		if("gpmarkup" not in self){gpmarkup = [];}
		draw_set_colour(c_black);
		draw_set_alpha(0.3);
		draw_rectangle(x+1, y+1, x+w, y+h, 0);
		draw_set_alpha(1);
		draw_set_colour(color);
		draw_rectangle_color(x, y, x+w - 1, y+h - 1, color, colorH, color, colorIH, 0);
		draw_set_colour(bgColor);
		draw_rectangle(x + 1, y + 2 + bannerHeight, x + w - 2, y + h - 2, 0);
		draw_rectangle_color(x + 1, y + 1, x + w - 2, y + bannerHeight, bannerColor, bannerColorHighlight, bannerColorHighlight, bannerColor, 0);
		draw_set_colour(color);
		draw_rectangle(x + w - bannerHeight, y + 2, x + w - 3, y + bannerHeight - 1, 0);
		draw_set_colour(colorIH);
		draw_rectangle(x + w - bannerHeight, y + bannerHeight - 1, x + w - 3, y + bannerHeight - 1, 0);
		draw_rectangle(x + w - 3, y + 2, x + w - 3, y + bannerHeight - 1, 0);
		draw_set_colour(colorH);
		draw_rectangle(x + w - bannerHeight, y + 2, x + w - 3, y + 2, 0);
		draw_rectangle(x + w - bannerHeight, y + 2, x + w - bannerHeight, y + bannerHeight - 1, 0);
		draw_set_colour(color_get_value(color) > 128 ? c_black : c_white);
		draw_set_font(fntChat);
		draw_set_halign(fa_center);
		draw_text(x + w - bannerHeight/2, y - 2, "x");
		draw_set_colour(nameColor);
		draw_set_halign(fa_left);
		draw_text(x + 9, y - 1, name);
		draw_set_font(fntM0);
		
		gpscroll = draw_gp_surface(x + 1, y + bannerHeight + 2, w - 2, h - bannerHeight - 3, x + 1, y + bannerHeight + 2, gpscroll, gpmarkup, true, null);
	}
}
with(global.tooltips){
	draw_set_font(fntM1);
	draw_set_color(hoverTextColor);
	var temph = array_length(string_split(hoverText, "#")) + array_length(string_split(hoverText, chr(13))) + array_length(string_split(hoverText, chr(10))) - 2;
	var tempw = string_width(string_split(string_split(string_split(string_delete_nt(hoverText), chr(10))[0], chr(13))[0], "#")[0]);
	var tempx = mouse_x[hover - 1] - view_xview[hover - 1] - 12;
	var tempy = mouse_y[hover - 1] - view_yview[hover - 1] - 12;
	
	draw_triangle(tempx - tempw/2 - 2, tempy - string_height(hoverText) * temph - 1, tempx - tempw/2, tempy - string_height(hoverText) * temph - 3, tempx + tempw/2 + 1, tempy - string_height(hoverText) * temph - 3, 0);
	draw_triangle(tempx + tempw/2 + 1, tempy - string_height(hoverText) * temph - 1, tempx + tempw/2 - 1, tempy - string_height(hoverText) * temph - 3, tempx - tempw/2 - 2, tempy - string_height(hoverText) * temph - 1, 0);
	
	draw_triangle(tempx - tempw/2 - 2, tempy + 1, tempx - tempw/2, tempy + 3, tempx + tempw/2 + 1, tempy + 3, 0);
	draw_triangle(tempx + tempw/2 + 1, tempy + 1, tempx + tempw/2 - 1, tempy + 3, tempx - tempw/2 - 2, tempy + 1, 0);
	
	draw_triangle(tempx - 2, tempy + 3, tempx + 12, tempy + 12, tempx + 12, tempy + 12, 0);
	draw_triangle(tempx + 12 + 1, tempy + 3, tempx + 12, tempy + 12, tempx - 2, tempy + 3, 0);
	
	draw_rectangle(tempx - tempw/2 - 1, tempy - string_height(hoverText) * temph, tempx + tempw/2 + 1, tempy + 1, 0);
	draw_set_halign(fa_center);
	draw_text_nt(tempx, tempy - string_height(hoverText) * temph, hoverText);
	draw_set_halign(fa_left);
	draw_set_font(fntM0);
}
global.tooltips = [];

#define draw_gp_surface(_x,_y,_w,_h,_uix,_uiy, _gpscroll, _gpmarkup, _scrollbar, _basesurf)
{
	surface_reset_target();
	var _surf = surface_create(_w, _h);
	if(_scrollbar){
		_w -= 9;
	}
	surface_set_target(_surf);
	draw_clear_alpha(c_black, 0);
	draw_set_colour(c_white);
	var yoff = -_gpscroll;
	var maxyoff = -_gpscroll;
	var xoff = 0;
	for(var i = 0; i < array_length(_gpmarkup) && yoff < _h; i++){
		var o = _gpmarkup[i];
		if(o == null){continue;}
		xoff += o.lborder;
		if(!o.sameLine || xoff >= _w && ("width" not in o || o.width > 0 || o.type == "image" || o.type == "button")){
			xoff = o.lborder;
			yoff = maxyoff + o.uborder;
		}
		if(maxyoff + o.ysize + o.dborder >= 0){
			var ox = o.x + xoff - view_xview[0];
			var oy = o.y + yoff - view_yview[0];
			var ix = o.x + xoff + _uix;
			var iy = o.y + yoff + _uiy;
			switch(o.type){
				case "image":
					if("spriteScr" in o){
						o.sprite = script_ref_call(o.spriteScr, self, _gpmarkup[i])
					}
					draw_sprite_general(o.sprite, o.subimg, o.left, o.top, o.width <= 0 ? sprite_get_width(o.sprite) + o.width : o.width, o.height <= 0 ? sprite_get_height(o.sprite) + o.height : o.height, ox, oy, o.xscale, o.yscale, o.rot, o.c1, o.c2, o.c3, o.c4, o.alpha);
					o.xsize = o.width * o.xscale;
					o.ysize = o.height * o.yscale;
					if("hoverText" in o){
						o.hover = false;
						for(var i2 = 0; i2 < maxp; i2++){
							if(!player_is_active(i2)){break;}
							var mouseX = mouse_x[i2]-view_xview[i2];
							var mouseY = mouse_y[i2]-view_yview[i2];
							if(!o.hover){o.hover = point_in_rectangle(mouseX,mouseY,ix,max(iy, o.y + _y),min(ix+o.xsize, _uix+_w),min(iy+o.ysize, _uiy+_h)) * (i2 + 1);}
						}
						if(o.hover){array_push(global.tooltips, {hover : o.hover, hoverText : o.hoverText, hoverTextColor : "hoverTextColor" in o ? o.hoverTextColor : c_purple});}
					}
					break;
				case "button":
					if("spriteScr" in o){
						o.sprite = script_ref_call(o.spriteScr, self, _gpmarkup[i])
					}
					var w = o.width <= 0 ? sprite_get_width(o.sprite) + o.width : o.width;
					var h = o.height <= 0 ? sprite_get_height(o.sprite) + o.height : o.height;
					o.hover = false;
					var t1 = max(iy, o.y + _y);
					var t2 = min(ix+w, _uix+_w);
					var t3 = min(iy+h, _uiy+_h);
					for(var i2 = 0; i2 < maxp; i2++){
						if(!player_is_active(i2)){break;}
						o.hover = point_in_rectangle(mouse_x[i2]-view_xview[i2],mouse_y[i2]-view_yview[i2],ix,t1,t2,t3) * (i2 + 1);
						if(o.hover){break;}
					}
					if(o.hover){
						if("hoverText" in o){array_push(global.tooltips, {hover : o.hover, hoverText : o.hoverText, hoverTextColor : "hoverTextColor" in o ? o.hoverTextColor : c_purple});}
						script_ref_call(o.hoverScr, self, _gpmarkup[i], o.hover - 1);
						if(!instance_exists(self)){exit;}
						if(self == null){continue;}
						if(gp_button_check(ix, max(iy, o.y + _y), min(w, _w-o.x-xoff), min(h, _h-( yoff + o.y)), 1)){
							if(gp_button_check(ix, max(iy, o.y + _y), min(w, _w-o.x-xoff), min(h, _h-(yoff + o.y)))){
								var index = gp_button_index(ix, max(iy, o.y + _y), min(w, _w-o.x-xoff), min(h, _h-(yoff + o.y)));
								if(index >= 0 && !global.inputHolds[index]){
									script_ref_call(o.clickScr, self, _gpmarkup[i], index);
									if(!instance_exists(self)){exit;}
									if(self == null){continue;}
									o.clicked = 2;
								}
							}
							var index = gp_button_index(ix, max(iy, o.y + _y), min(w, _w-o.x-xoff), min(h, _h-(yoff + o.y)));
							if(index >= 0 && !global.inputHolds[index]){
								script_ref_call(o.holdScr, self, _gpmarkup[i], index);
								if(!instance_exists(self)){exit;}
								if(self == null){continue;}
							}
						}
					}
					script_ref_call(o.stepScr, self, _gpmarkup[i]);
					if(!instance_exists(self)){exit;}
					if(self == null){continue;}
					draw_set_colour(c_black);
					draw_set_alpha(0.3);
					draw_rectangle(ox + 1, oy + 1, ox + w, oy + h, 0);
					draw_set_alpha(o.bgAlpha);
					draw_set_colour(o.bgColor);
					draw_rectangle(ox + (o.clicked > 0), oy + (o.clicked > 0), ox + w - 1 + (o.clicked > 0), oy + h - 1 + (o.clicked > 0), 0);
					draw_set_alpha(1);
					if(o.sprite != null){
						draw_sprite_stretched(o.sprite, o.subimg, ox + (o.clicked > 0), oy + (o.clicked > 0), w, h);
					}
					o.clicked--;
					o.xsize = w;
					o.ysize = h;
					break;
				case "text":
					draw_set_font(o.font);
					o.xsize = o.width <= 0 ? (_w-(o.x + xoff)) + o.width : o.width;
					var txt = gp_text_setup(o.text, o.xsize, o.buffer, o.font);
					for(var i2 = 0; i2 < array_length(txt) && (o.height <= 0 || i2 < o.height / o.fontHeight); i2++){
						draw_text_nt(ox,oy + i2 * o.fontHeight,txt[i2]);
					}
					o.ysize = o.height <= 0 ? array_length(txt) * o.fontHeight + o.height : o.height;
					if("hoverText" in o){
						o.hover = false;
						for(var i2 = 0; i2 < maxp; i2++){
							if(!player_is_active(i2)){break;}
							var mouseX = mouse_x[i2]-view_xview[i2];
							var mouseY = mouse_y[i2]-view_yview[i2];
							if(!o.hover){o.hover = point_in_rectangle(mouseX,mouseY,ix,max(iy, o.y + _y),min(ix+o.xsize, _uix+_w),min(iy+o.ysize, _uiy+_h)) * (i2 + 1);}
						}
						if(o.hover){array_push(global.tooltips, {hover : o.hover, hoverText : o.hoverText, hoverTextColor : "hoverTextColor" in o ? o.hoverTextColor : c_purple});}
					}
					break;
				case "ticker":
					var s = gp_ticker(-view_xview[0],-view_yview[0],(o.width <= 0 ? _w-o.lborder-o.rborder + o.width : o.width),o.height <= 0 ? o.fontHeight : o.height,o.text,o.speed,o.offset,o.color,o.font,o.fontWidth,o.fontHeight,o.bgColor);
					surface_set_target(_surf);
					draw_surface(s, ox, oy+1);
					o.xsize = o.width <= 0 ? _w + o.width : o.width;
					o.ysize = o.height <= 0 ? o.fontHeight : o.height;
					if("hoverText" in o){
						o.hover = false;
						for(var i2 = 0; i2 < maxp; i2++){
							if(!player_is_active(i2)){break;}
							var mouseX = mouse_x[i2]-view_xview[i2];
							var mouseY = mouse_y[i2]-view_yview[i2];
							if(!o.hover){o.hover = point_in_rectangle(mouseX,mouseY,ix,max(iy, o.y + _y),min(ix+o.xsize, _uix+_w),min(iy+o.ysize, _uiy+_h)) * (i2 + 1);}
						}
						if(o.hover){array_push(global.tooltips, {hover : o.hover, hoverText : o.hoverText, hoverTextColor : "hoverTextColor" in o ? o.hoverTextColor : c_purple});}
					}
					surface_reset_target();
					break;
				case "surface":
					if("scroll" not in o){o.scroll = 0;}
					if("scrollbar" not in o){o.scrollbar = 0;}
					o.xsize = o.width <= 0 ? _w + o.width : o.width;
					o.ysize = o.height <= 0 ? _h + o.height : o.height;
					o.gpscroll = draw_gp_surface(ox,oy,o.xsize,o.ysize,_uix,_uiy,o.scroll,o.markup,o.scrollbar, _surf);
					if("hoverText" in o){
						o.hover = false;
						for(var i2 = 0; i2 < maxp; i2++){
							if(!player_is_active(i2)){break;}
							var mouseX = mouse_x[i2]-view_xview[i2];
							var mouseY = mouse_y[i2]-view_yview[i2];
							if(!o.hover){o.hover = point_in_rectangle(mouseX,mouseY,ix,max(iy, o.y + _y),min(ix+o.xsize, _uix+_w),min(iy+o.ysize, _uiy+_h)) * (i2 + 1);}
						}
						if(o.hover){array_push(global.tooltips, {hover : o.hover, hoverText : o.hoverText, hoverTextColor : "hoverTextColor" in o ? o.hoverTextColor : c_purple});}
					}
			}
		}
		xoff += o.xsize + o.rborder;
		maxyoff = max(o.y + yoff + o.ysize + o.dborder, maxyoff);
	}
	retVal = 0;
	if(_scrollbar){
		retVal = draw_gp_surface_scrollbar(_w-view_xview[0], -1-view_yview[0], 8, _h, _uix+_w, _uiy, _gpscroll, gpsurf_height(_gpmarkup, _w - 8));
	}
	surface_reset_target();
	if(_basesurf != null){
		surface_set_target(_basesurf);
	}
	draw_surface(_surf, _x, _y);
	surface_free(_surf);
	return retVal;
}
#define draw_gp_surface_scrollbar(_x,_y,_w,_h,_uix,_uiy,_scrollPos,_scrollMax)
{
	draw_set_colour(colorIH);
	draw_rectangle(_x+1, _y+1, _x+_w, _y+_h, 0);
	draw_set_colour(colorH);
	draw_rectangle(_x+1, _y+1, _x+_w, _y+8, 0);
	draw_rectangle(_x+1, _y+_h-7, _x+_w, _y+_h, 0);
	draw_set_colour(color);
	var _uih = _h;
	if(_h > 32){
		if(gp_button_check(_uix+1, _uiy+1, _w, 8)){
			_scrollPos = max(_scrollPos - max(_scrollMax/_uih, 1), 0);
		}
		if(gp_button_check(_uix+1, _uiy+_h-7, _w, _h)){
			_scrollPos = min(_scrollPos + max(_scrollMax/_uih, 1), _scrollMax-_uih);
		}
		_h -= 17;
		_y += 8;
		_uiy += 8;
	}
	var barH = max(_h*min(_uih/_scrollMax, 1), 3);
	draw_rectangle(_x+1, _y+1+(_h-barH)*(_scrollPos/max(_scrollMax - _uih, 1)), _x+_w, _y+1+(_h-barH)*(_scrollPos/max(_scrollMax - _uih, 1))+barH, 0);
	if(gp_button_check(_uix+1, _uiy+1, _w, _h)){
		holdScroll = gp_button_index(_uix+1, _uiy+7, _w, _h-6);
		if(holdScroll != -1 && global.inputHolds[holdScroll] == 0){
			global.inputHolds[holdScroll] = 1;
			_scrollPos = max(min((mouse_y[holdScroll] - barH/2 - _uiy - view_yview[0])/(_h-barH), 1), 0) * max(_scrollMax - _uih, 0);
		}else{
			holdScroll = -1;
		}
	}
	if("holdScroll" in self && holdScroll >= 0){
		_scrollPos = max(min((mouse_y[holdScroll] - barH/2 - _uiy - view_yview[0])/(_h-barH), 1), 0) * max(_scrollMax - _uih, 0);
		if(!button_check(holdScroll, "fire")){
			holdScroll = -1;
		}
	}
	return _scrollPos;
}
#define gpsurf_height(_gpmarkup, _w)
{
	var xoff = 0;
	var yoff = 0;
	var maxyoff = 0;
	for(var i = 0; i < array_length(_gpmarkup); i++){var o = _gpmarkup[i];
		if(o == null){continue;}
		xoff += o.lborder;
		if(!o.sameLine || xoff >= _w && ("width" not in o || o.width > 0 || o.type == "image" || o.type == "button")){
			xoff = o.lborder;
			yoff = maxyoff + o.uborder;
		}
		maxyoff = max(o.y + yoff + o.ysize + o.dborder, maxyoff);
		xoff += o.xsize + o.rborder;
	}
	return maxyoff;
}

#define gpsurf_image_setup(_sprite, _subimg) 
{
	var retVal = {
		type : "image",
		ysize : 0,
		xsize : 0,
		sprite : _sprite,
		subimg : _subimg,
		x : 0,
		y : 0,
		xscale : 1,
		yscale : 1,
		left : 0,
		top : 0,
		width : 0,
		height : 0,
		rot : 0,
		dborder : 3,
		uborder : 0,
		lborder : 3,
		rborder : 0,
		sameLine : false,
		c1 : c_white,
		c2 : c_white,
		c3 : c_white,
		c4 : c_white,
		alpha : 1
	};
	return retVal;
}
#define gpsurf_image_set_size(_gpobj, _w, _h)
{
	_gpobj.xscale = _w/_gpobj.width;
	_gpobj.yscale = _h/_gpobj.height;
	return _gpobj;
}
#define gpsurf_button_setup(_sprite, _subimg)
{
	var retVal = {
		type : "button",
		ysize : 0,
		xsize : 0,
		sprite : _sprite,
		bgColor : c_silver,
		bgAlpha : _sprite == null ? 1 : 0,
		subimg : _subimg,
		x : 0,
		y : 0,
		width : 0,
		height : 0,
		dborder : 3,
		uborder : 0,
		lborder : 3,
		rborder : 0,
		sameLine : false,
		clicked : 0,
		clickScr : script_ref_create(nullScr),
		hoverScr : script_ref_create(nullScr),
		holdScr : script_ref_create(nullScr),
		stepScr : script_ref_create(nullScr),
	};
	return retVal;
}
#define gpsurf_button_setColor(_gpobj, _color, _alpha)
{
	_gpobj.bgColor = _color;
	_gpobj.bgAlpha = _alpha;
	return _gpobj;
}	
#define gpsurf_button_setScripts(_gpobj, _click, _hover, _hold, _step)
{
	if(_click != null){_gpobj.clickScr = _click;}
	if(_hover != null){_gpobj.hoverScr = _hover;}
	if(_hold != null){_gpobj.holdScr = _hold;}
	if(_step != null){_gpobj.stepScr = _step;}
	return _gpobj;
}	
#define gpsurf_button_setClick(_gpobj, _scr)
{
	_gpobj.clickScr = _scr;
	return _gpobj;
}	
#define gpsurf_button_setHover(_gpobj, _scr)
{
	_gpobj.hoverScr = _scr;
	return _gpobj;
}	
#define gpsurf_button_setHold(_gpobj, _scr)
{
	_gpobj.holdScr = _scr;
	return _gpobj;
}	
#define gpsurf_button_setStep(_gpobj, _scr)
{
	_gpobj.stepScr = _scr;
	return _gpobj;
}	
#define gpsurf_button_setSize(_gpobj, _w, _h)
{
	_gpobj.width = _w;
	_gpobj.height = _h;
	return _gpobj;
}
#define gpsurf_text_setup(_text, _font)
{
	draw_set_font(_font);
	var retVal = {
		type : "text",
		ysize : 0,
		xsize : 0,
		x : 0,
		y : 0,
		dborder : 3,
		uborder : 0,
		lborder : 3,
		rborder : 0,
		sameLine : false,
		text : _text,
		font : _font,
		width : 0,
		height : 0,
		fontWidth : string_width("OO")/2,
		fontHeight : string_height("O"),
		buffer : 3,
	};
	draw_set_font(fntM0);
	return retVal;
}
#define gpsurf_text_setSize(_gpobj, _w, _h)
{
	_gpobj.width = _w;
	_gpobj.height = _h;
	return _gpobj;
}
#define gpsurf_ticker_setup(_text, _speed)
{
	var _font = fntChat;
	draw_set_font(_font);
	var retVal = {
		type : "ticker",
		ysize : 0,
		xsize : 0,
		x : 0,
		y : 0,
		dborder : 0,
		uborder : 0,
		lborder : 0,
		rborder : 0,
		sameLine : false,
		text : _text,
		speed : _speed,
		font : _font,
		offset : 0,
		color : c_white,
		bgColor : c_black,
		fontWidth : string_width("OO")/2,
		fontHeight : string_height("O"),
		width : 0,
		height : 0,
		buffer : 5,
	};
	draw_set_font(fntM0);
	return retVal;
}
#define gpsurf_surface_setup(_markup)
{
	var _font = fntChat;
	draw_set_font(_font);
	var retVal = {
		type : "surface",
		ysize : 0,
		xsize : 0,
		x : 0,
		y : 0,
		dborder : 0,
		uborder : 0,
		lborder : 0,
		rborder : 0,
		sameLine : false,
		width : 0,
		height : 0,
		markup : _markup,
	};
	draw_set_font(fntM0);
	return retVal;
}
#define gpsurf_obj_setSameLine(_gpobj)
{
	_gpobj.sameLine = true;
	return _gpobj;
}	
#define gpsurf_obj_setPos(_gpobj,_x,_y)
{
	_gpobj.x = _x;
	_gpobj.y = _y;
	return _gpobj;
}
#define gpsurf_obj_setBorder(_gpobj,_L,_R,_U,_D)
{
	_gpobj.lborder = _L;
	_gpobj.rborder = _R;
	_gpobj.uborder = _U;
	_gpobj.dborder = _D;
	return _gpobj;
}

#define gp_ticker
//_x,_y,_w,_h,text,?speed,?offset,?color,?font,?fontWidth,?fontHeight,?bgColor
if(argument_count >= 5){
	var _x = real(argument[0]);
	var _y = real(argument[1]);
	var _w = real(argument[2]);
	var _h = real(argument[3]);
	var surf = surface_create(_w, _h);
	surface_set_target(surf);
	var text = string(argument[4]);
	var offset = 0;
	var color = draw_get_color();
	var font = fntM0;
	var fontWidth = 8;
	var fontHeight = 8;
	if(argument_count >= 7){offset = (current_frame-real(argument[6]))/real(argument[5]);}
	else if(argument_count >= 6){offset = current_frame/real(argument[5]);}
	if(argument_count >= 8){color = real(argument[7]);}
	if(argument_count >= 9){draw_set_font(argument[8]);}
	if(argument_count >= 10){fontWidth = real(argument[9]);}
	else{fontWidth = 8;}
	if(argument_count >= 11){fontHeight = real(argument[10]);}
	else{fontHeight = 8;}
	if(argument_count >= 12 && argument[11] != "trans"){
		draw_set_colour(real(argument[11]));
		draw_rectangle(_x, _y, _x + _w - 1, _y + _h - 1, 0);
	}
	if(string_width(text) > 0){
		var i = -(offset % (string_width("O")*max(text_width(text), 1)));
		while(i < w){
			draw_text_nt(_x + i, _y - 1, "@(color:"+string(color)+")"+text);
			i += string_width("O")*max(text_width(text), 1);
		}
	}
	draw_set_font(fntM0);
	surface_reset_target();
	return surf;
}

#define gp_ticker_draw(x,y,surf)
{
	if(surface_exists(surf)){
		draw_surface(surf, x, y);
	}
	if(object_index == CustomDraw){instance_destroy();}
}

#define gp_text_setup(text, width, buffer, font)
//returns an array of text lines based on the width given in the given font
//buffer is recommended to be 3 or 4 for most cases.
{
	draw_set_font(font);
	var ret = [];
	var prevcut = 1;
	var count = 0;
	var extra = 0;
	if(width > string_width("O")){
		while(prevcut+count <= string_length(text)){
			while(prevcut+count <= string_length(text) && string_width(string_copy(text, prevcut, count)) - extra < width){
				if(string_char_at(text, prevcut+count) == " " && string_width(string_copy(text, prevcut, count + buffer)) - extra >= width){
					array_push(ret, string_copy(text, prevcut, count));
					extra = 0;
					prevcut += count + 1;
					count = -1;
				}else if(string_char_at(text, prevcut+count) == "\"){
					extra+=1;
					count++;
				}else if(string_char_at(text, prevcut+count) == "@"){
					extra+=string_width(string_copy(text, count, 2));
					count++;
				}else if(string_char_at(text, prevcut+count) == "#" || string_ord_at(text, prevcut+count) == 13 || string_ord_at(text, prevcut+count) == 10){
					array_push(ret, string_copy(text, prevcut, count));
					extra = 0;
					prevcut += count + 1;
					count = -1;
				}
				count++;
			}
			array_push(ret, string_copy(text, prevcut, count));
			extra = 0;
			prevcut += count;
			count = 0;
		}
	}
	return ret;
}

#define text_width(text)
{
	count = 0;
	maxcount = 0;
	for(var i = 0; i < string_length(text); i++){
		if(string_char_at(text, i) == "@"){
			var char = string_char_at(text, i+1);
			if(char == "(" || (string_char_at(text, i+2) == "(" && (char == "0" || char == "1" || char == "2" || char == "3" || char == "4" || char == "5" || char == "6" || char == "7" || char == "8" || char == "9"))){
				while(i < string_length(text) && string_char_at(text, i) != ")"){
					i++;
				}
			}
			i++;
		}else if(string_char_at(text, i) == "#" || string_ord_at(text, i) == 13 || string_ord_at(text, i) == 10){
			if(count > maxcount){maxcount = count;}
			count = 0;
		}else{
			count++;
		}
	}
	if(count > maxcount){maxcount = count;}
	return maxcount;
}

#define gp_button_check
//x,y,w,h,?hold,?index
{
	var retVal = false;
	if(argument_count == 4 || (argument_count == 5 && argument[4] == 0)){
		var x = argument[0];
		var y = argument[1];
		var w = argument[2];
		var h = argument[3];
		for(var i = 0; i < 4; i++){
			var mouseX = mouse_x[i]-view_xview[i];
			var mouseY = mouse_y[i]-view_yview[i];
			if(!retVal){retVal = (button_pressed(i, "fire") && point_in_rectangle(mouseX,mouseY,x,y,x+w,y+h));}
		}
	}else if(argument_count == 5){
		var x = argument[0];
		var y = argument[1];
		var w = argument[2];
		var h = argument[3];
		for(var i = 0; i < 4; i++){
			var mouseX = mouse_x[i]-view_xview[i];
			var mouseY = mouse_y[i]-view_yview[i];
			if(!retVal){retVal = (button_check(i, "fire") && point_in_rectangle(mouseX,mouseY,x,y,x+w,y+h));}
		}
	}
	else if(argument_count == 6 && argument[4] == 0){
		var mouseX = mouse_x[argument[5]]-view_xview[argument[5]];
		var mouseY = mouse_y[argument[5]]-view_yview[argument[5]];
		var x = argument[0];
		var y = argument[1];
		var w = argument[2];
		var h = argument[3];
		if(!retVal){retVal = (button_pressed(argument[5], "fire") && point_in_rectangle(mouseX,mouseY,x,y,x+w,y+h));}
	}
	else if(argument_count == 6){
		var mouseX = mouse_x[argument[5]]-view_xview[argument[5]];
		var mouseY = mouse_y[argument[5]]-view_yview[argument[5]];
		var x = argument[0];
		var y = argument[1];
		var w = argument[2];
		var h = argument[3];
		if(!retVal){retVal = (button_check(argument[5], "fire") && point_in_rectangle(mouseX,mouseY,x,y,x+w,y+h));}
	}
	return retVal;
}
#define gp_button_index
//x,y,w,h,?hold
{
	var retVal = false;
	if(argument_count == 4 || (argument_count == 5 && argument[4] == 0)){
		var x = argument[0];
		var y = argument[1];
		var w = argument[2];
		var h = argument[3];
		for(var i = 0; i < 4; i++){
			var mouseX = mouse_x[i]-view_xview[i];
			var mouseY = mouse_y[i]-view_yview[i];
			if(button_pressed(i, "fire") && point_in_rectangle(mouseX,mouseY,x,y,x+w,y+h)){return i;}
		}
	}else if(argument_count == 5){
		var x = argument[0];
		var y = argument[1];
		var w = argument[2];
		var h = argument[3];
		for(var i = 0; i < 4; i++){
			var mouseX = mouse_x[i]-view_xview[i];
			var mouseY = mouse_y[i]-view_yview[i];
			if(button_check(i, "fire") && point_in_rectangle(mouseX,mouseY,x,y,x+w,y+h)){return i;}
		}
	}
	return -1;
}

#define gp_create_object(gp_name, name)
{
	if(array_length(instances_matching(CustomObject, "guiName", name)) == 0){
		with(instance_create(0,0,CustomObject)){
			GuiPack = gp_name;
			guiName = name;
			guiID = array_length(instances_matching(CustomObject, "guiName", name));
			return self;
		}
	}
	return instances_matching(CustomObject, "guiName", name)[0];
}
#define gp_create_generic_object(gp_name, name)
{
	with(instance_create(0,0,CustomObject)){
		GuiPack = gp_name;
		guiName = name;
		guiID = array_length(instances_matching(CustomObject, "guiName", name));
		return self;
	}
	return noone;
}

#define nullScr

//now for the yokin scripts to come to the rescue!
#define string_delete_nt(_string)
	/*
		Returns a given string with "draw_text_nt()" formatting removed
		
		Ex:
			string_delete_nt("@2(sprBanditIdle:0)@rBandit") == "  Bandit"
			string_width(string_delete_nt("@rHey")) == 3
	*/
	
	var	_split          = "@",
		_stringSplit    = string_split(_string, _split),
		_stringSplitMax = array_length(_stringSplit);
		
	for(var i = 1; i < _stringSplitMax; i++){
		if(_stringSplit[i - 1] != _split){
			var	_current = _stringSplit[i],
				_char    = string_upper(string_char_at(_current, 1));
				
			switch(_char){
				
				case "": // CANCEL : "@@rHey" -> "@rHey"
					
					if(i < _stringSplitMax - 1){
						_current = _split;
					}
					
					break;
					
				case "W":
				case "S":
				case "D":
				case "R":
				case "G":
				case "B":
				case "P":
				case "Y":
				case "Q": // BASIC : "@qHey" -> "Hey"
					
					_current = string_delete(_current, 1, 1);
					
					break;
					
				case "0":
				case "1":
				case "2":
				case "3":
				case "4":
				case "5":
				case "6":
				case "7":
				case "8":
				case "9": // SPRITE OFFSET : "@2(sprBanditIdle:1)Hey" -> "  Hey"
					
					if(string_char_at(_current, 2) == "("){
						_current = string_delete(_current, 1, 1);
						
						 // Offset if Drawing Sprite:
						var _spr = string_split(string_copy(_current, 2, string_pos(")", _current) - 2), ":")[0];
						if(
							real(_spr) > 0
							|| sprite_exists(asset_get_index(_spr))
							|| _spr == "sprKeySmall"
							|| _spr == "sprButSmall"
							|| _spr == "sprButBig"
						){
							// draw_text_nt uses width of "A" instead of " ", so this is slightly off on certain fonts
							if(string_width(" ") > 0){
								_current = string_repeat(" ", real(_char) * (string_width("A") / string_width(" "))) + _current;
							}
						}
					}
					
					 // NONE : "@2Hey" -> "@2Hey"
					else{
						_current = _split + _current;
						break;
					}
					
				case "(": // ADVANCED : "@(sprBanditIdle:1)Hey" -> "Hey"
					
					var	_bgn = string_pos("(", _current),
						_end = string_pos(")", _current);
						
					if(_bgn < _end){
						_current = string_delete(_current, _bgn, 1 + _end - _bgn);
						break;
					}
					
				default: // NONE : "@Hey" -> "@Hey"
					
					_current = _split + _current;
					
			}
			
			_stringSplit[i] = _current;
		}
	}
	
	return array_join(_stringSplit, "");
