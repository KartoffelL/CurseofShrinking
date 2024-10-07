data asdt  = {123}
data source_basicvs = {#version 300 es
	in vec4 Vertex;
	out mediump vec2 texCoords;
	out mediump vec2 wpos;
	
	uniform mediump vec4 position;
	uniform mediump vec4 tposition;
	uniform mediump vec4 camera;
	uniform mediump float depth;
	
	void main() {
		gl_Position = vec4(Vertex.xy*position.zw+position.xy, 0, 1);
		wpos = gl_Position.xy*depth;
		gl_Position.xy = (gl_Position.xy-camera.xy)*camera.wz/depth;
		vec4 a = tposition;
		
		a.y = 1.0-a.w-a.y;
		texCoords = (Vertex.xy*0.5+0.5)*a.zw+a.xy;
		texCoords.y = 1.0-texCoords.y;
	}
}
data source_basicfs = {#version 300 es
	out mediump vec4 color;
	in mediump vec2 texCoords;
	in mediump vec2 wpos;
	
	uniform mediump vec3 col;
	uniform sampler2D tex0;
	uniform mediump float depth;
	uniform mediump vec2 level;
	
	void main() {
		if(abs(wpos.x) > level.x || abs(wpos.y) > level.y)
			discard;
      		color = texture(tex0, vec2(texCoords.x, texCoords.y));
		color.rgb *= col/depth;
		if(color.a < 0.1)
			discard;
   	 }
}
data level1 = {JG_HHGGGHGGHGGAAAAAAAAAAEEEEFEEEEFCCCDEEECCCEEEFEEEEFEEEEECCDEEEEEEEEFEEEE}
data u_position_name = {position}
data u_tposition_name = {tposition}
data u_camera_name = {camera}
data u_val_name = {val}
data u_color_name = {col}
data u_texture_name = {tex0}
data u_depth_name = {depth}
data u_level_name = {level}

function import env void print(double a);
function import env void print();

function import env void glClear(int bits);
function import env void glClearColor(float r, float g, float b, float a);
function import env int glCreateShader(int vshader, int fshader);
function import env int glCreateTexture(int source);
function import env void glDrawQuad();
function import env void glBindShader(int shader);
function import env void glBindTexture(int texture, int location);
function import env void glViewport(int x, int y, int width, int height);
function import env int glGenUniformLocation(int shader, int name);
function import env void glSetUniform1f(int location, float value);
function import env void glSetUniform2f(int location, float x, float y);
function import env void glSetUniform3f(int location, float x, float y, float z);
function import env void glSetUniform4f(int location, float x, float y, float z, float w);
function import env void glSetUniform1i(int location, int value);
function import env void glSetUniform2i(int location, int x, int y);
function import env void glSetUniform3i(int location, int x, int y, int z);
function import env void glSetUniform4i(int location, int x, int y, int z, int w);

function import env void drawText(int string, int x, int y);
function import env void drawScore(int tscore, int lscore, int x, int y, float c, int d);

function import env float mouseX();
function import env float mouseY();
function import env int isKeyDown(int char);
function import env int isMouseDown(int button);


function import Math float cos(float a);
function import Math float min(float a, float b);
function import Math float max(float a, float b);
function import Math float random();

function import env void playSound(int pointr, double volume, double pitch, int loop);

struct ArrayList{
	var int p;
	var int p_size = 0;
	var int size = 0;
	function ArrayList new() {
		ArrayList l = allocate(ArrayList:sizeof);
		l.p = allocate(16);
		l.p_size = 4;
		.return l;
	}
	function void re(ArrayList l) {
		.if(l.size > l.p_size) {
			int s = l.p_size;
			l.p_size = l.size; #Increase by four+1
			int o = l.p;
			l.p = allocate(4*l.p_size);
			copy(o, l.p, s*4);
			free(o);
			ArrayList:check(l);
		}
	}
	#Shifts including the index
	function void shift(ArrayList l, int index, int length, int amount) {
		.if(length ! 0) {
			copy(l.p+index*4, l.p+index*4+amount, length);
		}
	}
	function void check(ArrayList l) {
		.if(l.p = 0) {
			exception(err_Nullptr);
		}
	}
	function void add(ArrayList l, int index, int pointr) {
		ArrayList:check(l);
		.if(index > l.size | index < 0) {
			exception(errMes);
		}
		l.size = l.size+1;
		ArrayList:re(l);
		ArrayList:shift(l, index, (l.size-index-1)*4, 4);
		l.p[index*4] = pointr;
	}
	function int remove(ArrayList l, int index) {
		ArrayList:check(l);
		int trm = ArrayList:get(l, index);
		ArrayList:shift(l, index+1, (l.size-index)*4, -4);
		l.size = l.size-1;
		.return trm;
	}
	function int indexOf(ArrayList l, int pointr) {
		int res = -1;
		int adsg = 0;
		.while(adsg < l.size) {
			.if(ArrayList:get(l, adsg) = pointr) {
				res = adsg;
				.break;
			}
			adsg = adsg+1;
		}
		
		.return res;
	}
	function int get(ArrayList l, int index) {
		.if(index > l.size | index = l.size | index < 0) {
			print(index);
			exception(errMes);
		}
		.return l.p[index*4]§int;
	}
	function void clear(ArrayList l) {
		l.size = 0;
	}
	function int size(ArrayList l) {
		.return l.size;
	}
	
	
}



struct Entity {
	var float x = 0;
	var float y = 0;
	var float px = 0;
	var float py = 0;
	var float sx = 1;
	var float sy = 1;
	var float ssx = 1;
	var float ssy = 1;
	var float mx = 0;
	var float my = 0;
	var int onGround = 0;
	var int onWall = 0;
	var int touching = 0;
	var int health = 0;
	var float slideTime = 0;
	var int type = 0;
	var float tx = 0;
	var float ty = 0;
	var float tw = 0;
	var float th = 0;
	var float rsx = 1;
	var float rsy = 1;
	var float tsx = 1;
	var float tsy = 1;
	var float tpx = 0;
	var float tpy = 0;
	var float internal = 0;
	var int gravity = 1;
	var int touched = 0;
	
	var float attackCoolDown = 0;
	var float attackCharge = 0;
	var float deathTimr = 0;
	
	function Entity new(int t) {
		Entity a = allocate(Entity:sizeof);
		a.x = 0.0;
		a.y = 0.0;
		a.sx = 1.0;
		a.sy = 1.0;
		a.ssx = 1.0;
		a.ssy = 1.0;
		a.mx = 0;
		a.my = 0;
		a.px = 0;
		a.py = 0;
		a.onGround = 0;
		a.touching = 0;
		a.health = 3;
		a.slideTime = 0;
		a.type = t;
		a.attackCoolDown = 0;
		a.attackCharge = 0;
		a.tx = 0;
		a.ty = 0;
		a.tw = 1;
		a.th = 1;
		a.internal = random();
		a.deathTimr = 0;
		a.rsx= 1;
		a.rsy = 1;
		a.tsx= 1;
		a.tsy = 1;
		a.tpx= 0;
		a.tpy = 0;
		a.gravity = 1;
		a.touched = 0;
		.return a;
	}
}

struct Level {
	var int levelArr;
	var int levelWidth;
	var int levelHeight;
	var int px;
	var int py;
	var int doorx;
	var int doory;

}

var int shader = 0;
var int tileSet = 0;
var int tileWidth = 16;
var int tileHeight = 8;
var int entitySet = 0;
var int etileWidth = 15;
var int etileHeight = 10;


var int u_val;
var int u_position;
var int u_tposition;
var int u_camera;
var int u_color;
var int u_texture;
var int u_depth;
var int u_level;
var final int COLOR_BUFFER_BIT = 16384;
var final int DEPTH_BUFFER_BIT = 256;

var int entities = 0;

var int levels = 0;
var int loadedLevels;

var Level currentLevel = 0;
var Level backGroundLevel0 = 0;
var Level backGroundLevel1 = 0;

var int depth = 0;


var Entity player = 0;

var float time = 0;
var float aspect = 1.2;
var int click = 0;
var int clickSize = 0;
var int clickSlide = 0;
var int clickWall = 0;
var int clickTest = 0;
var int clickTest2 = 0;
var float wallJumpForbid = 0;
var float playerSize = 1;
var float levelTrans = 0;

var int levelScore = 0;
var int totalScore = 0;

var int ddddd= 0;
var float difficulty = 0;
var float transMul = 1;

var int unlocked = 0;
var int finalStrt = 0;
var int final = 0;
var float finalDialgTimr = 0;

function int loadLevel(int pointr) {
	Level l = allocate(Level:sizeof);
	int width = pointr[0]§int&255;
	int height = pointr[1]§int&255;
	int ps = pointr[2]§int&255;
	int py = pointr[3]§int&255;
	l.levelArr =  allocate(width*height*4);
	copy(pointr+16, l.levelArr, width*height*4);
	l.levelWidth = width;
	l.levelHeight = height;
	l.px = ps+0.5;
	l.py = py;
	print(width);
	print(height);
	prepareLevel(l);
	.return l;
}
function void prepareLevel(Level l) {
	int d132 = 0;
	.while(d132 < l.levelWidth*l.levelHeight) {
		int xx = remS(d132, l.levelWidth);
		int yy = d132/l.levelWidth;
		.if(yy > 0) {
			int ta = l.levelArr[d132*4]§int;
			int tb = l.levelArr[(d132-l.levelWidth)*4]§int;
			.if(ta = 60 | ta = 61 | ta = 62) {
				l.doorx = xx;
				l.doory = yy;
			}
		}
		d132 = d132+1;
	}
}
function void populateLevel(Level l) {
	int d132 = 0;

	int countr = 0;
	.while(d132 < l.levelWidth*l.levelHeight) {
		int xx = remS(d132, l.levelWidth);
		int yy = d132/l.levelWidth;
		.if(yy > 0) {
			int ta = remS((l.levelArr[d132*4]§int), tileWidth);
			int tb = remS((l.levelArr[(d132-l.levelWidth)*4]§int), tileWidth);
			.if(((ta < 8)=0) & (tb < 8)) {
				countr = countr+1;
				.if((random()>100/(difficulty+100))) {
					.if(random()*depth/3 < 0.5) {
						Entity e = Entity:new(1);
						e.x = xx+0.5;
						e.y = yy+0.5;
						ArrayList:add(entities, 0, e);
					} .else {
						Entity e = Entity:new(3);
						e.x = xx+0.5;
						e.y = yy+0.5;
						ArrayList:add(entities, 0, e);
					}
				}
				.if((random()<0.1) & (depth = 2)) {
					Entity e = Entity:new(5);
					e.x = xx+0.5;
					e.y = yy+0.5;
					changeEntitySize(l, e, 2, 2);
					ArrayList:add(entities, 0, e);
				}
			}
		}
		d132 = d132+1;
	}
	d132 = 0;
	countr =  random()*countr;
	int countr2 = 0;
	.while(d132 < l.levelWidth*l.levelHeight) {
		int xx = remS(d132, l.levelWidth);
		int yy = d132/l.levelWidth;
		.if(yy > 0) {
			int ta = remS((l.levelArr[d132*4]§int), tileWidth);
			int tb = remS((l.levelArr[(d132-l.levelWidth)*4]§int), tileWidth);
			.if(((ta < 8)=0) & (tb < 8)) {
				.if(countr2 = countr) {
					Entity e = Entity:new(2);
					e.x = xx+0.5;
					e.y = yy+0.5;
					ArrayList:add(entities, 0, e);
				.break 4;
				}
				countr2 = countr2+1;
			}
		}
		d132 = d132+1;
	}
}
function void switchLevel(int l) {
	Level le = loadLevel(levels[l*4]§int);
	populateLevel(le);
	.if(currentLevel ! 0) {
		free(currentLevel.levelArr);
		free(currentLevel);
	}
	currentLevel = le;
	player.x = currentLevel.px+0.5;
	player.y = currentLevel.py+0.5;
}
function void setTile(Level l, int x, int y, int tile) {
	l.levelArr[(x+y*l.levelWidth)*4] = tile;
}
function int getTile(Level l, int x, int y) {
	.return (l.levelArr[(x+y*l.levelWidth)*4]§int);
}
function void test() {
	ArrayList:remove(entities, ArrayList:indexOf(entities, player));
}
function void changeEntitySize(Level lev, Entity e, float sxx, float syy) {
	.if(sxx > 0.001 & syy > 0.001) {
		float osx = e.sx;
		float osy = e.sy;
		e.sx = sxx;
		e.sy = syy;
		float l = (syy-osy)/2;
		e.y = e.y+l;
		.if(checkEntityCol(lev, e)) {
			e.sx = osx;
			e.sy = osy;
			e.y = e.y-l;
		}
	}
}

function void damageEntity(Entity e, Entity source) {
	e.health = e.health-1;
	.if(e.health > 0) {
	playSound(hit_1_mp3, 0.1, 0.7+random()*0.6, 0);}
	.if(source ! 0) {
		e.mx = e.mx-copySign(10, source.x-e.x);
		.if((e.health > 0)=0 & source=player) {
			levelScore = levelScore+10;
			playSound(hit_2_mp3, 0.1, 0.7+random()*0.6, 0);
		}
	}
}
function void damageEntities(Entity source, float origX, float origY, float radius) {
	int c13 = 0;
	.while(c13 < ArrayList:size(entities)) {
		Entity e = ArrayList:get(entities, c13);
		.if(e ! source) {
			float dst = distance(e, source, 1, 1, origX, origY);
			.if(dst < radius*radius) {
				damageEntity(e, source);
			}
		}
		c13 = c13+1;
	}
}
function void clearEntities() {
	int c13 = 0;
	.while(c13 < ArrayList:size(entities)) {
		Entity e = ArrayList:get(entities, c13);
		.if(e ! player) {
			free(e);
		}
		c13 = c13+1;
	}
	ArrayList:clear(entities);
	ArrayList:add(entities, 0, player);
}
function float distance(Entity a, Entity b, float mux, float muy, float ox, float oy) {
	.return (a.x-b.x+ox)*(a.x-b.x+ox)+(a.y-b.y+oy)*(a.y-b.y+oy);
}
function void stepAI(Entity e, double t) {
	.if(e.attackCoolDown > 0) {
		e.attackCoolDown = max(e.attackCoolDown-t°float, 0);
	}
	.if((e.health > 0)=0) {
		e.deathTimr = max(e.deathTimr-t°float, 0);
	}
	.if(e.type = 1) {
		.if(e.health > 0) {
			e.tx = 0;
			.if(distance(player, e, 1, 1, 0, 0) < 10*10) {
				.if(e.attackCharge=0 & e.attackCoolDown=0) {
					e.mx = e.mx-copySign(15*t, e.x-player.x)*(e.onGround*0.95+0.05);
					e.tx = 1+(e.internal*2-floor(e.internal)*2)°int;
					e.rsx = copySign(1, e.x-player.x)
				}
				.if(distance(player, e, 1, 1, 0, 0) < 1 & e.attackCoolDown=0) {
					e.attackCharge = e.attackCharge+t;
					.if(e.attackCharge > 1) {
						damageEntities(e, 0, 0, 1);
						e.attackCoolDown = 2;
						e.health = 0;
						e.tx = 8;
					}
					e.tx = (e.attackCharge*4+3)°int;
				} .else {e.attackCharge = 0;}
			}
		} .else {
			e.tx = 7;
		}
	}
	.if(e.type = 3) {
		.if(e.health > 0) {
			e.tx = 1;
			e.ty = 1;
			e.tw = 1;
			e.th = 1;
			e.tsx = 1;
			e.tpx = 0;
			.if(distance(player, e, 1, 1, 0, 0) < 10*10) {
				.if(e.attackCharge=0 & e.attackCoolDown=0) {
					e.mx = e.mx-copySign(5*t, e.x-player.x)*(e.onGround*0.95+0.05);
					e.tx = 1+(e.internal*6-floor(e.internal*2)*3)°int*2;
					e.rsx = copySign(1, e.x-player.x)
				}
				.if(distance(player, e, 1, 1, 0, 0) < 2 & e.attackCoolDown=0) {
					e.attackCharge = e.attackCharge+t*2;
					e.tx = 6+(e.attackCharge*4)°int*2;
					e.tsx = 2;
					e.tpx = 0-e.rsx/2;
					e.tw = 2;
					.if(e.attackCharge > 1) {
						damageEntities(e, e.rsx, 0, 1);
						e.attackCoolDown = 4;
					}
					
				} .else {e.attackCharge = 0;}
			}
			.if(e.attackCoolDown!0) {
				e.tx = 0;
				e.ty = 2;
				e.tsx = 2;
				e.tpx = 0-e.rsx/2;
				e.tw = 2;
			}
		} .else {
			e.tx = 3;
			e.ty = 2;
		}
	}
	.if(e.type = 5) { #Bacterea
		e.tx = 10;
		e.ty = 8;
		e.tw = 2;
		e.th = 2;
		e.mx = e.mx-copySign(15*t, e.x-player.x)*(e.onGround*0.95+0.05)*0.1;
		.if((e.internal > 4) & (distance(e, player, 1, 1, 0, 0) < 25)) {
			e.internal = 0;
			Entity ee = Entity:new(6);
			ee.x = e.x+0.5;
			ee.y = e.y+0.5;
			ee.mx = player.x-ee.x;
			ee.my = player.y-ee.y;
			ee.gravity = 0;
			ArrayList:add(entities, 0, ee);
		}
		.if(e.health < 1) {
			ArrayList:remove(entities, ArrayList:indexOf(entities, e));
			free(e);
		}
	}
	.if(e.type = 6) { #Bacterea Spit
 		e.tx = 12;
		e.ty = 9;
		e.mx = e.mx-copySign(15*t, e.x-player.x)*(e.onGround*0.95+0.05)*0.1;
		.if(e.touched > 0) {
			damageEntities(e, 0, 0, 1);
			ArrayList:remove(entities, ArrayList:indexOf(entities, e));
			free(e);
		}
		.if(distance(e, player, 1, 1, 0, 0) < 0.5) {
			damageEntity(player, e);
			ArrayList:remove(entities, ArrayList:indexOf(entities, e));
			free(e);
		}
	}
	.if(e.type = 2) { #Lever
		e.health = 3;
		e.tx = 0;
		e.ty = 4;
		.if(e.deathTimr ! 0) {
			e.tx = min((e.deathTimr*5)°int, 4);
			.if((e.tx = 4) & (unlocked=0)) {onUnlock();}
		}
		.if(distance(player, e, 1, 1, 0, 0) < 1) {
			e.deathTimr = min(e.deathTimr+t°float*0.5, 1);
		}
	}
	.if(e.type = 0) {
		.if(final & (finalStrt=0)) {
			.if(player.x > 40) {
				finalStrt = 1;
				finalDialgTimr = 12;
				playSound(ending_mp3, 1, 1, 0);
			}
		}
		.if(unlocked) {
			.if((entityTouching(currentLevel, e, 76) | entityTouching(currentLevel, e, 77) | entityTouching(currentLevel, e, 78)) & levelTrans=0) {
				levelTrans = 0.001;
			}
		}
		.if((entityTouching(currentLevel, e, 18) | entityTouching(currentLevel, e, 19)) & player.my < 0) {
			player.my = 0-player.my*0.01+22;
			player.mx = player.mx*0.9;
		}
		.if((entityTouching(currentLevel, e, 52-depth) | entityTouching(currentLevel, e, 51+depth)) & player.my < 0) {
			player.my = 0-player.my*0.01+5;
			player.mx = player.mx*2;
			damageEntity(player, 0);
		}
		player.tw = 0.7;
		player.th = 0.7;
		.if(e.health > 0) {
			float speed = 70/playerSize*(player.onGround*0.95+0.05);
			float playerdir = (isKeyDown(68)|isKeyDown(39))-(isKeyDown(37)|isKeyDown(65));
			.if(playerdir ! 0) {
				e.rsx = playerdir;
				e.tx = 1+(e.internal*9*1-floor(e.internal*1)*9)°int;
			}
			player.mx = player.mx+speed*t*playerdir;
			player.ty = 7.3;
			#player.my = player.my+speed*t*isKeyDown(87)-speed*t*isKeyDown(83)+speed*t*isKeyDown(38)-speed*t*isKeyDown(40);
			.if(player.onGround & (isKeyDown(32) | isKeyDown(87) | isKeyDown(38))) {
				player.my = 10;
				player.mx = player.mx*1.05;
				
			}
			.if((entityTouching(currentLevel, e, 9)|entityTouching(currentLevel, e, 108)|entityTouching(currentLevel, e, 109)) & (isKeyDown(32) | isKeyDown(87) | isKeyDown(38))) {
				player.my = 5.3;
				player.mx = player.mx*0.9;
			}
			.if(player.onWall & (isKeyDown(32) | isKeyDown(38))) {
				.if(clickWall & (wallJumpForbid!playerdir)) {
					player.mx = playerdir*3;
					player.my = 10;
					wallJumpForbid = playerdir;
				}
				clickWall = 0; 
			} .else {
				clickWall = 1;
			}
			.if(player.onGround) {
				player.ty = 5.3;
				.if(e.attackCoolDown!0) {
					player.ty = 7.3;
					int d = (4*e.attackCoolDown/0.3);
					player.tx = d+11.3;
					
				}
				wallJumpForbid = 0;
			}
			.if(isKeyDown(82)) {
				.if(clickSize) {
					changeEntitySize(currentLevel, player, player.sx*1.2, player.sy*1.2);
					playerSize = playerSize/1.2;
				}
				clickSize = 0;
			}
			 .if(isKeyDown(84)) {
				.if(clickSize) {
					changeEntitySize(currentLevel, player, player.sx/1.2, player.sy/1.2);
					playerSize = playerSize*1.2;
				}
				clickSize = 0;
			}
			.if(isKeyDown(69)|isKeyDown(96)) {
				.if(e.attackCoolDown=0) {
					damageEntities(player, 0-e.rsx*1.5, 0, 1.5);
					e.attackCoolDown = 0.3;
				}
			}
			.if((isKeyDown(84) | isKeyDown(82)) !1) {clickSize = 1;}
			.if(isKeyDown(71)) {
				.if(clickTest) {
					levelTrans = 0.001;
				}
				clickTest = 0;
			} .else {clickTest = 1;}
			.if(isKeyDown(72)) {
				.if(clickTest2) {
					levelTrans = 0.001;
					depth = depth+1;
				}
				clickTest2 = 0;
			} .else {clickTest2 = 1;}
			.if(isKeyDown(40)|isKeyDown(83))  {
				.if(clickSlide & player.onGround & (player.slideTime < 0.01)) {
					player.slideTime = 1;
					clickSlide = 0;
					player.mx = player.mx*2;
				}
			} .else {
				clickSlide = 1;
			}
		} .else {
			.if(ddddd) {
				onDeadth();
			}
		}
	}
}
function int checkEntityCol(Level l, Entity e) {
	e.touching = getTile(l, e.x°int, e.y°int);
	int mmx = floor(e.x-e.sx/2)°int;
	int mmy= floor(e.y-e.sy/2)°int;
	int max= floor(e.x+e.sx/2)°int;
	int may= floor(e.y+e.sy/2)°int;
	int a = mmx;
	int b = mmy;
	int c = 0;
	.while(a < max+1) {
			.while(b < may+1) {
				#drawQuad(((a+0.5)/levelWidth)*2-1, ((b+0.5)/levelHeight)*2-1, 1.0/levelWidth, 1.0/levelHeight, 0.0, 0.5, 1);
				int t = getTile(l, a, b);
				.if((remS(t, tileWidth) < 8) & ((t=18|t=19|t=51|t=52|t=53)=0)) {
					c = 1;
					e.touched = e.touched+1;
					.break 4;
				} 
				b = b+1;
			}
			a = a+1;
			b = mmy;
		}
	.if(mmx <0 | max > (l.levelWidth-1) | may > (l.levelHeight-1)) {
		c = 1;
	}
	.if(mmy < 0) {
		damageEntity(e, 0);
		c = 0;
	}
	.return c;
}
function int entityTouching(Level l, Entity e, int tilett) {
	e.touching = getTile(l, e.x°int, e.y°int);
	int mmx = floor(e.x-e.sx/2)°int;
	int mmy= floor(e.y-e.sy/2)°int;
	int max= floor(e.x+e.sx/2)°int;
	int may= floor(e.y+e.sy/2)°int;
	int a = mmx;
	int b = mmy;
	int c = 0;
	.while(a < max+1) {
			.while(b < may+1) {
				#drawQuad(((a+0.5)/levelWidth)*2-1, ((b+0.5)/levelHeight)*2-1, 1.0/levelWidth, 1.0/levelHeight, 0.0, 0.5, 1);
				int t = getTile(l, a, b);
				.if(t = tilett) {
					c = 1;
					.break 4;
				} 
				b = b+1;
			}
			a = a+1;
			b = mmy;
		}
	.return c;
}
function void onAdvanced() {
	.if(depth > 2) {
		clearEntities();
		currentLevel = loadLevel(end_tsr);
		player.x = currentLevel.px+0.5;
		player.y = currentLevel.py+0.5;
		player.mx = 0;
		player.my = 0;
		player.health = 3;
		ddddd = 1;
		totalScore = 0;
		levelScore = 0;
		transMul = 1;
		depth = 0;
		final = 1;
	} .else {
		int a = random()*16+depth*16;
		clearEntities();
		switchLevel(a);
		totalScore = totalScore+levelScore+70+50*difficulty*0.01;
		levelScore = 0;
		difficulty = difficulty+1;
		unlocked = 0;
		.if(totalScore > 1500*(depth+1)) {
			depth = depth+1;
			playSound(door_sfx_mp3, 1, 1, 0);
		}
	}
}
function void onUnlock() {
	unlocked = 1;
	setTile(currentLevel, currentLevel.doorx, currentLevel.doory, 76+depth);
}
function void reset() {
	clearEntities();
	.if(currentLevel ! 0) {
		free(currentLevel.levelArr);
		free(currentLevel);
	}
	currentLevel = loadLevel(tutorial_tsr);
	player.x = currentLevel.px+0.5;
	player.y = currentLevel.py+0.5;
	player.mx = 0;
	player.my = 0;
	player.health = 3;
	finalStrt = 0;
	ddddd = 1;
	totalScore = 0;
	levelScore = 0;
	transMul = 1;
	depth = 0;
	final = 0;
	Entity lvr = Entity:new(2);
	lvr.x = 39;
	lvr.y = 6;
	ArrayList:add(entities, 0, lvr);
	Entity lvr2 = Entity:new(1);
	lvr2.x = 37;
	lvr2.y = 6;
	ArrayList:add(entities, 0, lvr2);
}
function void onDeadth() {
	ddddd = 0;
	levelTrans = 0.001;
	transMul = 0.1;
	playSound(baah_sfx_mp3, 0.1, 0.7+random()*0.6, 0);
}
function void drawLevel(Level l) {
	int d132 = 0;
	float mmx = l.levelWidth/currentLevel.levelWidth;
	float mmy = l.levelHeight/currentLevel.levelHeight;
	.while(d132 < l.levelWidth*l.levelHeight) {
		int ctile = l.levelArr[d132*4]§int;
		.if(ctile!31) {
			int xx = remS(d132, l.levelWidth);
			int yy = d132/l.levelWidth;
			int tix = remS(ctile, tileWidth);
			int tiy = ctile/tileWidth;
			int ww = 1/tileWidth;
			int hh = 1/tileHeight;
			glSetUniform4f(u_position, (xx+ww)*mmx, (yy+hh)*mmy, mmx/2, mmy/2);
			glSetUniform4f(u_tposition, tix°float/tileWidth, tiy°float/tileHeight, 1.0/tileWidth, 1.0/tileHeight);
			glDrawQuad();
		}
		d132 = d132+1;
	}
}
function void init() {
	playSound(Mysteryyyyy_mp3, 0.02, 1, 1);
	glClearColor(1, 1, 0, 1);
	glClear(COLOR_BUFFER_BIT|DEPTH_BUFFER_BIT);
	shader = glCreateShader(source_basicvs, source_basicfs);
	u_val = glGenUniformLocation(shader, u_val_name);
	u_position = glGenUniformLocation(shader, u_position_name);
	u_tposition = glGenUniformLocation(shader, u_tposition_name);
	u_color = glGenUniformLocation(shader, u_color_name);
	u_texture = glGenUniformLocation(shader, u_texture_name);
	u_camera = glGenUniformLocation(shader, u_camera_name);
	u_depth = glGenUniformLocation(shader, u_depth_name);
	u_level = glGenUniformLocation(shader, u_level_name);

	tileSet = glCreateTexture(setf5_png);
	entitySet = glCreateTexture(entitesheet_png);
	loadedLevels = allocate(4*1);
	loadedLevels = glCreateTexture(entitesheet_png);
	entities = ArrayList:new();
	player = Entity:new(0);
	player.sx = 0.7;
	player.sy = 1.6;
	levels = allocate(4*16*3);
	levels[0] = level0_tsr;
	levels[4] = level1_tsr;
	levels[8] = level2_tsr;
	levels[12] = level3_tsr;
	levels[16] = level4_tsr;
	levels[20] = level5_tsr;
	levels[24] = level6_tsr;
	levels[28] = level7_tsr;
	levels[32] = level8_tsr;
	levels[36] = level9_tsr;
	levels[40] = level10_tsr;
	levels[44] = level11_tsr;
	levels[48] = level12_tsr;
	levels[52] = level13_tsr;
	levels[56] = level14_tsr;
	levels[60] = level15_tsr;
	levels[0+64] = 1_level0_tsr;
	levels[4+64] = 1_level1_tsr;
	levels[8+64] = 1_level2_tsr;
	levels[12+64] = 1_level3_tsr;
	levels[16+64] = 1_level4_tsr;
	levels[20+64] = 1_level5_tsr;
	levels[24+64] = 1_level6_tsr;
	levels[28+64] = 1_level7_tsr;
	levels[32+64] = 1_level8_tsr;
	levels[36+64] = 1_level9_tsr;
	levels[40+64] = 1_level10_tsr;
	levels[44+64] = 1_level11_tsr;
	levels[48+64] = 1_level12_tsr;
	levels[52+64] = 1_level13_tsr;
	levels[56+64] = 1_level14_tsr;
	levels[60+64] = 1_level15_tsr;
	levels[0+64*2] = 2_level0_tsr;
	levels[4+64*2] = 2_level1_tsr;
	levels[8+64*2] = 2_level2_tsr;
	levels[12+64*2] = 2_level3_tsr;
	levels[16+64*2] = 2_level4_tsr;
	levels[20+64*2] = 2_level5_tsr;
	levels[24+64*2] = 2_level6_tsr;
	levels[28+64*2] = 2_level7_tsr;
	levels[32+64*2] = 2_level8_tsr;
	levels[36+64*2] = 2_level9_tsr;
	levels[40+64*2] = 2_level10_tsr;
	levels[44+64*2] = 2_level11_tsr;
	levels[48+64*2] = 2_level12_tsr;
	levels[52+64*2] = 2_level13_tsr;
	levels[56+64*2] = 2_level14_tsr;
	levels[60+64*2] = 2_level15_tsr;
	backGroundLevel0 = loadLevel(background0_tsr);
	backGroundLevel1 = loadLevel(background1_tsr);
	ddddd = 1;
	ArrayList:add(entities, 0, player);
	reset();
	aspect = 4.0/3;
}
function void update(double t, int width, int height) {
	.if((finalDialgTimr > 0) & final) {
		finalDialgTimr = finalDialgTimr-t°float;
		.if(finalDialgTimr < 0) {
			finalDialgTimr = -100;
		}
	}
	.if((finalDialgTimr < 0) & final) {
			Entity e = Entity:new((random()*3)°int+1);
			e.x = random()*30+35;
			e.y = random()*5+1;
			ArrayList:add(entities, 0, e);
			finalDialgTimr = finalDialgTimr+1;
			.if(finalDialgTimr = 0) {
				finalDialgTimr = 60;
				final = 0;
			}
	}
	.if(finalDialgTimr > 40) {
		.if((finalDialgTimr = 50) & (final=0)) {
			reset();
			playSound(win_never_sfx_mp3, 0.1, 0.7+random()*0.6, 0);
			finalDialgTimr = 0;
			finalDialgTimr = 0;
		} .else {finalDialgTimr = max(finalDialgTimr-t°float, 50);}
	}
	time = time+t;
	glClearColor(0, 0, 0, 1);
	glClear(COLOR_BUFFER_BIT|DEPTH_BUFFER_BIT);
	float crat = min(width/aspect, height*aspect);
	float screen_xoff = width/2-(crat*aspect)/2;
	float screen_yoff = height/2-(crat)/2;
	float screen_xsiz =  (crat*aspect);
	float screen_ysiz = (crat);
	float mX = (mouseX()-screen_xoff)/screen_xsiz*2-1;
	float mY = 1-(mouseY()-screen_yoff)/screen_ysiz*2;
	float adawdsa = min((player.health>0=0)*levelTrans*4, 1);
	float ffgaf = (player.health>0=0)*0.5;
	drawScore(totalScore, levelScore, (100*(1-adawdsa)+adawdsa*width/2)°int, (100*(1-adawdsa)+adawdsa*height/2)°int, ffgaf, 1500*(depth+1));
	glViewport(screen_xoff°int, screen_yoff°int, screen_xsiz°int, screen_ysiz°int);
	glBindShader(shader);
	glSetUniform2f(u_level, currentLevel.levelWidth, currentLevel.levelHeight);
	glSetUniform1f(u_depth, 1);
	glSetUniform4f(u_camera, (max(min(player.x, currentLevel.levelWidth°float), 0)), (max(min(player.y, currentLevel.levelHeight°float), 0)), playerSize/7, playerSize/7/aspect);
	
	glSetUniform1i(u_texture, 0);
	glSetUniform3f(u_color, 1*(1-levelTrans), 1*(1-levelTrans), 1*(1-levelTrans));
	glSetUniform4f(u_position, 0, 0, 1, 1);
	glSetUniform4f(u_tposition, 0, 0, 1, 1);
	glBindTexture(tileSet, 0);
	glSetUniform1f(u_depth, 1.7);
	drawLevel(backGroundLevel1);
	glSetUniform1f(u_depth, 1.3);
	drawLevel(backGroundLevel0);
	glSetUniform1f(u_depth, 1);
	drawLevel(currentLevel);
	glSetUniform3f(u_color, 1, 1, 1);
	glSetUniform1f(u_depth, 1);
	#entities
	.if(isMouseDown(0)) {
		.if(click = 0) {
			
		}
		click = 1;
	} .else {click = 0;}
	.if(levelTrans ! 0) {
		levelTrans = max(levelTrans+t°float*2*transMul, 0);
		.if(levelTrans > 1) {
			levelTrans = 0;
			.if(player.health > 0) {
				onAdvanced();
			} .else {
				reset();
			}
		}
	}
	glBindTexture(entitySet, 0);
	glSetUniform4f(u_tposition, 0, 0, 1, 1);
	int c = 0;
	.if(c < ArrayList:size(entities)) {
		.while(c < ArrayList:size(entities)) {
			Entity e = ArrayList:get(entities, c);
			stepAI(e, t);
			e.internal = e.internal+t;
			e.slideTime = e.slideTime*0.9;
			e.onGround = 0;
			e.onWall = 0;
			e.my = e.my-t*32*e.gravity;
			e.x = e.x+e.mx*t;
			int cc = checkEntityCol(currentLevel, e);
			.if(cc) { #Collision
				e.onWall = 1;
				e.x = e.x-e.mx*t;
				e.mx = 0-e.mx*0.2;
			}
			e.y = e.y+e.my*t;
			int cc = checkEntityCol(currentLevel, e);
			.if(cc) { #Collision
				.if(e.my < 0) {
					e.onGround = 1;
				}
				e.y = e.y-e.my*t;
				e.my = 0-e.my*0.0;
				e.mx = e.mx*(e.slideTime*0.2+0.8);
			}
			e.ssx = e.rsx*0.1+e.ssx*0.9;
			e.ssy = e.rsy*0.1+e.ssy*0.9;
			c=c+1;
			.if(e.type = 0) {
				glSetUniform3f(u_color, 1, 1*e.health/3.0, 1*e.health/3.0);
			} .else {
				glSetUniform3f(u_color, 1*(1-levelTrans)*e.health/3.0, 1*(1-levelTrans)*e.health/3.0, 1*(1-levelTrans));
			}
			glSetUniform4f(u_tposition, e.tx/etileWidth, e.ty/etileHeight, e.tw/etileWidth, e.th/etileHeight);
			drawQuad(e.x-0.5+e.tpx, e.y-0.5+e.tpy, 0.5*e.sx*e.ssx*e.tsx, 0.5*e.sy*e.ssy*e.tsy);
		}
	}
	
}

function void drawQuad(float x, float y, float w, float h) {
	glSetUniform4f(u_position, x, y, w, h);
	glDrawQuad();
}