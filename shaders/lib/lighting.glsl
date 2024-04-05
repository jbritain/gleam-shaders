#include "/lib/sky_colors.glsl"


float attenuateArtificial(float light){
  const float K = 2.0;
  const float P = 5.06;
  return K * pow(light, P);
}

float attenuateSky(float light){
  //return pow4(light);
  return light;
}

vec3 skylightColor = vec3(0.2, 0.2, 0.4);

float getSpecularShadingFactor(vec3 lightVector, vec3 viewPos, vec3 normal, float shininess, float specularStrength){
  vec3 viewVector = normalize(viewPos); // vector pointing towards fragment
  vec3 reflectionVector = reflect(-lightVector, normal); // reflected vector from the sun

  return pow(max(dot(viewVector, reflectionVector), 0.0), shininess) * specularStrength;
}
vec3 getDiffuse(vec3 albedo, vec3 dir, float nDotL, vec2 lightmap, float shadow, vec4 shadowColor){
  vec3 skylight = getSkyColor(dir, mat3(gbufferModelViewInverse) * normalize(sunPosition)) * lightmap.g;
  vec3 sunlight = getSunColor(mat3(gbufferModelViewInverse) * normalize(sunPosition));

  if (shadowColor != vec4(0.0)){
    sunlight = shadowColor.rgb * (shadowColor.a);
  }

  return albedo * (skylight * SKY_INTENSITY + sunlight * SUN_INTENSITY * nDotL * (1.0 - shadow) + artificialLightColor * attenuateArtificial(lightmap.r));
}

