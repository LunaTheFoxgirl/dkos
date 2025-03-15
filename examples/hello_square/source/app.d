module app;
import dreamcast.pvr.pvr;
import dreamcast.maple.controller;
import dreamcast.maple;
import dreamcast.video;
import nulib.math;
import nulib;
import nulib.c.stdio;
import numem;

@nogc:

class Sprite {
@nogc:
private:
	pvr_sprite_cxt_t cxt;
	pvr_sprite_hdr_t hdr;
	pvr_sprite_col_t pdata;
	float w = 32, h = 32;

	float lx, ly;

public:
	this(pvr_list_t list) {
		pvr_sprite_cxt_col(&cxt, list);
		cxt.gen.specular = PVR_SPECULAR_ENABLE;
		cxt.txr.env = PVR_TXRENV_REPLACE;
		cxt.txr.alpha = PVR_TXRALPHA_ENABLE;
		cxt.blend.src_enable = PVR_BLEND_ENABLE;
		cxt.blend.src = PVR_BLEND_ONE;
		cxt.blend.dst_enable = PVR_BLEND_ENABLE;
		cxt.blend.dst = PVR_BLEND_INVDESTALPHA;

		pdata.flags = PVR_CMD_VERTEX_EOL;

		pvr_sprite_compile(&hdr, &cxt);
		hdr.argb = 0xFFFFFFFF;
	}

	void setColor(uint argb) {
		hdr.argb = argb;
	}

	void setSize(float w, float h) {
		this.w = w;
		this.h = h;
	}

	void begin() {
		pvr_list_begin(PVR_LIST_OP_POLY);
	}

	void end() {
		pvr_list_finish();
	}

	void draw(float x, float y, float z = 1) {


		// Stupid caching system
		if (lx != x || ly != y) {
			pdata.ax = x;
			pdata.ay = y;
			pdata.az = z;
			pdata.bx = x+w;
			pdata.by = y;
			pdata.bz = z;
			pdata.cx = x+w;
			pdata.cy = y+h;
			pdata.cz = z;
			pdata.dx = x;
			pdata.dy = y+h;

			lx = x;
			ly = y;
		}

		pvr_prim(&hdr, pvr_sprite_hdr_t.sizeof);
		pvr_prim(&pdata, pvr_sprite_col_t.sizeof);
	}
}

struct tr {
	float x;
	float y;
}

float lerp(float x, float y, float t) {
	return (1 - t) * x + t * y;
}


void main(string[] args) {
	
	// :)
	vid_border_color(0, 0, 0);
	vid_empty();
	vid_waitvbl();
	
	cast(void)printf("Hello world from dkos!\n");
	cast(void)printf("This is code running, written in DLang!\n");
	cast(void)printf("%d arguments were passed to the program!\n", args.length);
	foreach(arg; args) {
		cast(void)printf("%.*s", cast(int)arg.length, arg.ptr);
	}

	cast(void)printf("Attempting to bring up the PVR... ");
	if (pvr_init_defaults() == 0) {
		cast(void)printf("success!\n");
	} else cast(void)printf("failed :c\n");
	
	auto spr = nogc_new!Sprite(PVR_LIST_OP_POLY);
	spr.setColor(0xFFFF0000);

	vector!tr tr_list;

	foreach(i; 0..32) {
		tr_list ~= tr(256, 256);
	}

	float t = 0;
	while(true) {
		t += 0.001;
		maple_device_t* cont = maple_enum_type(0, MAPLE_FUNC_CONTROLLER);

		foreach_reverse(i; 1..tr_list.length) {
			tr_list[i] = tr_list[i-1];
		}

		if (cont) {
			cont_state_t* state = cast(cont_state_t*)maple_dev_status(cont);
			
			float fact = 64;
			if (state.a) fact = 32;

			if (state) {
				tr_list[0].x += cast(float)state.joyx/fact;
				tr_list[0].y += cast(float)state.joyy/fact;
			}
		}

		pvr_wait_ready();
		pvr_scene_begin();

			spr.begin();
			
				ubyte[4] argb;
				argb[0] = 0;
				argb[1] = 0;
				argb[2] = 255;
				argb[3] = 0;

				float percent = 0;
				foreach (i; 0..tr_list.length) {
					percent = cast(float)(i)/cast(float)tr_list.length;

					argb[2] = cast(ubyte)lerp(255, 0, percent);
					argb[0] = cast(ubyte)lerp(0, 32, percent);
					uint argbF = *(cast(uint*)&argb);

					float iOff = i*0.01;
					float offsetA = sin((iOff+t)*10)*4*percent;
					float offsetB = cos((iOff+t)*10)*4*percent;

					float offsetX = offsetA;
					float offsetY = offsetB;

					spr.setColor(argbF);
					spr.draw(tr_list[i].x+offsetX, tr_list[i].y+offsetY, cast(float)(tr_list.length-i)*0.5);
				}

			spr.end();
		pvr_scene_finish();
	}
}
