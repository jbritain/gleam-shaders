// SHADOWS AND LIGHTING

#include "/include/settings.glsl"

#ifdef vsh

uniform vec3 shadowLightPosition;
uniform vec3 mc_Entity;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;
uniform mat4 gbufferProjectionInverse;

out vec2 texCoord;
out vec3 dir;

void main() {
	gl_Position = ftransform();
  dir = mat3(gbufferModelViewInverse) * normalize(gbufferProjectionInverse * gl_Position).xyz;
	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}

#endif

//==============================================================================================================================

#ifdef fsh

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

uniform sampler2D depthtex0;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D shadowtex1;
uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor0;
uniform sampler2D noisetex;

uniform vec3 shadowLightPosition;
uniform vec3 sunPosition;
uniform int worldTime;

#include "/lib/util.glsl"
#include "/lib/lighting.glsl"
#include "/lib/encoding.glsl"
#include "/lib/shadows.glsl"

in vec2 texCoord;
in vec3 dir;

/* DRAWBUFFERS:04 */
layout(location = 0) out vec4 outColor;

void main() {
  vec3 albedo = texture(colortex0, texCoord).rgb;
  vec4 shadowPosition = texture(colortex3, texCoord);
  vec3 viewPos = fragmentViewSpacePos(texCoord);

  albedo = pow(albedo, vec3(GAMMA));

  float depth = texture(depthtex0, texCoord).r;
  if(depth >= 1.0){ // sky
    outColor.rgb = albedo;
    return;
  }

  

  vec2 lightmap = texture(colortex2, texCoord).rg;
  vec3 normal = decodeNormal(texture(colortex1, texCoord).xyz);

  float shadow = 0;
  vec4 shadowColor = vec4(0);

  #ifdef SHADOWS
  float rAngle = texture2D(noisetex, texCoord * 20.0).r * 100.0;
  shadow = getPCFShadow(shadowPosition, shadowtex1, rAngle);

  #ifdef COLORED_SHADOWS

  if (shadow != 1.0){
    if(getPCFShadow(shadowPosition, shadowtex0, rAngle) != 0){
      shadowColor = getPCFShadowColor(shadowPosition, shadowtex0, shadowcolor0, rAngle);
    }
  }
  #endif
  #endif

  float nDotL = max(dot(normal, normalize(shadowLightPosition)), 0.0);

  vec3 playerSpaceNormal = mat3(gbufferModelViewInverse) * normal;

  vec3 diffuse = getDiffuse(albedo, playerSpaceNormal, nDotL, lightmap, shadow, shadowColor);

  outColor.rgb = diffuse;
  



}

#endif