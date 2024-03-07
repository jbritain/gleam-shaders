float attenuateArtificial(float light){
  const float K = 2.0;
  const float P = 5.06;
  return K * pow(light, P);
}

float attenuateSky(float light){
  float light_2 = light * light;
  return light * light;
}

vec3 getLightmapColor(vec2 lightmap){

  vec3 artificalLighting = artificialLightColor * attenuateArtificial(lightmap.r);
  vec3 skyLighting = skyLightColor * attenuateSky(lightmap.g);

  return skyLighting + artificalLighting;
}