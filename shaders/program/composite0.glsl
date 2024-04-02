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

uniform mat4 gbufferProjectionInverse;

uniform sampler2D depthtex0;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D shadowtex1;
uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor0;

uniform vec3 shadowLightPosition;
uniform int worldTime;

#include "/lib/util.glsl"
#include "/lib/lighting.glsl"
#include "/lib/encoding.glsl"
#include "/lib/shadows.glsl"

in vec2 texCoord;
in vec4 lmCoord;

/* DRAWBUFFERS:04 */
layout(location = 0) out vec4 outColor;
layout(location = 1) out vec4 outPenumbra;

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

  vec3 sunlightColor = vec3(1, 0.95, 0.9);
  if ((worldTime > 23000) || (worldTime < 1000)){
    sunlightColor = vec3(0.4, 0.3, 0.2);
  } else if (worldTime < 12000){
    sunlightColor = vec3(1, 0.95, 0.9);
  } else if (worldTime < 13000) {
    sunlightColor = vec3(0.4, 0.3, 0.2);
  } else {
    sunlightColor = vec3(0.01, 0.01, 0.01);
  }


  #ifndef SHADOWS
  vec3 sunlight = sunlightColor;
  #else
  vec3 sunlight = vec3(0.0);

  // check for transparent shadows
  float transparentPenumbraSize = getPenumbraSize(shadowPosition, shadowtex0);
  float transparentShadowAmount = getPCFShadow(shadowPosition, shadowtex0, max(transparentPenumbraSize, pow2(PCF_SAMPLE_COUNT)/shadowMapResolution));
  transparentShadowAmount = clamp(transparentShadowAmount, 0, 1);

  // check for non transparent shadows
  float opaquePenumbraSize = getPenumbraSize(shadowPosition, shadowtex1);
  float opaqueShadowAmount = getPCFShadow(shadowPosition, shadowtex1, max(opaquePenumbraSize, pow2(PCF_SAMPLE_COUNT)/shadowMapResolution));
  opaqueShadowAmount = clamp(opaqueShadowAmount, 0, 1);

  float shadowAmount = max(opaqueShadowAmount, transparentShadowAmount);

  if (opaqueShadowAmount < transparentShadowAmount){
    vec4 shadowColor = texture(shadowcolor0, shadowPosition.xy);
    sunlightColor = mix(sunlightColor, shadowColor.rgb, transparentShadowAmount);
    shadowAmount = 0;
  }

  #endif

  vec2 lightmap = texture(colortex2, texCoord).rg;
  vec3 normal = decodeNormal(texture(colortex1, texCoord).xyz);

  float nDotL = max(dot(normal, normalize(shadowLightPosition)), 0.0);

  vec3 skyDiffuse = getSkyDiffuse(albedo, nDotL, lightmap, sunlightColor, shadowAmount);
  vec3 artificialDiffuse = getArtificialDiffuse(albedo, lightmap);

  outColor.rgb = skyDiffuse + artificialDiffuse + (AMBIENT_LIGHT * albedo);


}

#endif