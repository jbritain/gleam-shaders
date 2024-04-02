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

uniform mat4 gbufferProjectionInverse;

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

in vec2 texCoord;

#include "/lib/util.glsl"

vec3 tonemap(vec3 v){
  v *= 0.6f;
  float a = 2.51f;
  float b = 0.03f;
  float c = 2.43f;
  float d = 0.59f;
  float e = 0.14f;
  return clamp((v*(a*v+b))/(v*(c*v+d)+e), 0.0f, 1.0f);
}

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor;

void main(){
  outColor = texture(colortex0, texCoord);

  outColor.rgb = tonemap(outColor.rgb);
  outColor.rgb = pow(outColor.rgb, vec3(1.0/GAMMA)); // gamma correction

  vec4 hsvColor = hsv(outColor);
  hsvColor.g *= SATURATION;
  hsvColor.b *= BRIGHTNESS;
  outColor = rgb(hsvColor);
}

#endif