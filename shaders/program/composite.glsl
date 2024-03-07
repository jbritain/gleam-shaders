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

uniform sampler2D depthtex0;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

uniform vec3 sunPosition;

#include "/lib/diffuse_shading.glsl"
#include "/lib/encoding.glsl"
#include "/lib/lightmap.glsl"

in vec2 texCoord;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor;

void main() {
  vec3 albedo = texture(colortex0, texCoord).rgb;
  albedo = pow(albedo, vec3(2.2)); // gamma correction

  float depth = texture(depthtex0, texCoord).r;
  if(depth == 1.0){
    outColor.rgb = albedo;
    return;
  }

  vec2 lightmap = texture(colortex2, texCoord).rg;
  vec3 lighting = getLightmapColor(lightmap);

	

  vec3 normal = decodeNormal(texture(colortex1, texCoord).xyz);
  outColor.rgb = getDiffuseShading(albedo, normal, lighting);
}

#endif