float attenuateArtificial(float light){
  const float K = 2.0;
  const float P = 5.06;
  return K * pow(light, P);
}

float attenuateSky(float light){
  return pow(light, 4);
}

vec3 getLightmapColor(vec2 lightmap){
  const vec3 artificialLightColor = vec3(1.0, 0.64, 0.4);;
  const vec3 skyLightColor = vec3(0.15, 0.15, 0.15);

  vec3 artificalLighting = artificialLightColor * attenuateArtificial(lightmap.r);
  vec3 skyLighting = skyLightColor * attenuateSky(lightmap.g);

  return skyLighting + artificalLighting;
}