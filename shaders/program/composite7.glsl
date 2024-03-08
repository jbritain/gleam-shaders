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

void tonemap(inout vec3 col){
  col = col / (col + vec3(1.0));
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