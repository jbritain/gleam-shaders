#include "/include/settings.glsl"

#ifdef vsh

in vec3 mc_Entity;

uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;

out vec2 texCoord;
out vec2 lmCoord;
out vec4 glColor;

#include "/lib/shadows.glsl"

void main(){
  texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmCoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glColor = gl_Color;

  #ifdef EXCLUDE_FOLIAGE
		if (mc_Entity.x == 10000.0) {
			gl_Position = vec4(10.0);
		}
		else {
	#endif
			gl_Position = ftransform();
			gl_Position.xyz = distort(gl_Position.xyz);
	#ifdef EXCLUDE_FOLIAGE
		}
	#endif
}

#endif

//==============================================================================================================================

#ifdef fsh

uniform sampler2D lightmap;
uniform sampler2D texture;

in vec2 lmCoord;
in vec2 texCoord;
in vec4 glColor;

void main() {
	vec4 color = texture2D(texture, texCoord) * glColor;

	gl_FragData[0] = color;
}

#endif