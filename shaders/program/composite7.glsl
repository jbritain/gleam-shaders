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

uniform sampler2D colortex0;

in vec2 texCoord;

#include "/lib/util.glsl"

void tonemap(inout vec3 x){
  const float a = 2.51;
  const float b = 0.03;
  const float c = 2.43;
  const float d = 0.59;
  const float e = 0.14;
  x = clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor;

void main(){
  outColor = texture(colortex0, texCoord);

  tonemap(outColor.rgb);
  outColor.rgb = pow(outColor.rgb, vec3(1.0/GAMMA)); // gamma correction

  vec4 hsvColor = hsv(outColor);
  hsvColor.y *= SATURATION;
  outColor = rgb(hsvColor);
}

#endif