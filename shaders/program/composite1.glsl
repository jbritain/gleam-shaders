#include "/include/settings.glsl"

#ifdef vsh

out vec2 texCoord;

uniform mat4 gbufferModelViewInverse;

void main() {
	gl_Position = ftransform();
	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}

#endif

//==============================================================================================================================

#ifdef fsh

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform vec3 skyColor;
uniform vec3 fogColor;
uniform float far;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

in vec2 texCoord;

#include "/lib/fog.glsl"
#include "/lib/util.glsl"

vec3 getViewSpacePosition(){
  vec3 screenPos = vec3(texCoord, texture(depthtex0, texCoord));
  vec3 ndcPos = screenPos * 2.0 - 1.0;
  return projectAndDivide(gbufferProjectionInverse, ndcPos);
}

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor;

void main(){

  vec3 viewPos = getViewSpacePosition();

  outColor = texture(colortex0, texCoord);

  calculateFog(outColor.rgb, viewPos);

  //outColor = texture(depthtex1, texCoord);
  
}

#endif