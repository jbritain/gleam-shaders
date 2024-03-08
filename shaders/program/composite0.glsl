#include "/include/settings.glsl"

#ifdef vsh

uniform vec3 shadowLightPosition;
uniform vec3 mc_Entity;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;

out vec2 texCoord;
out vec4 lmCoord;

void main() {
	gl_Position = ftransform();
	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}

#endif

//==============================================================================================================================

#ifdef fsh

uniform sampler2D depthtex0;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D shadowtex1;

uniform vec3 sunPosition;

#include "/lib/util.glsl"
#include "/lib/lighting.glsl"
#include "/lib/encoding.glsl"
#include "/lib/shadows.glsl"

in vec2 texCoord;
in vec4 lmCoord;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor;

void main() {
  vec3 albedo = texture(colortex0, texCoord).rgb;
  vec4 shadowPosition = texture(colortex3, texCoord);

  float depth = texture(depthtex0, texCoord).r;
  if(depth >= 1.0){ // sky
    outColor.rgb = albedo;
    return;
  }

  vec2 lightmap = texture(colortex2, texCoord).rg;

  albedo = pow(albedo, vec3(GAMMA));

  vec3 normal = decodeNormal(texture(colortex1, texCoord).xyz);
  vec3 diffuse = getDiffuseShading(albedo, normal, lightmap);

  vec3 sunlight = vec3(0.0);

  if(!isInShadow(shadowPosition)){
    sunlight = sunlightColor;
  }

  outColor.rgb = albedo * (diffuse + sunlight);


}

#endif