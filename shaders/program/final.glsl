#include "/include/settings.glsl"

#ifdef vsh

out vec2 texCoord;

void main() {
	gl_Position = ftransform();
	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}

#endif

//==============================================================================================================================

#ifdef fsh

#define DRAW_TEXTURE colortex0 // [colortex0 colortex1 colortex2 colortex3 shadowtex0 shadowtex1 shadowcolor0 depthtex0 depthtex1 depthtex2]

uniform sampler2D DRAW_TEXTURE;

in vec2 texCoord;

#include "/lib/util.glsl"

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor;

void main(){
  outColor = texture(DRAW_TEXTURE, texCoord);
}

#endif