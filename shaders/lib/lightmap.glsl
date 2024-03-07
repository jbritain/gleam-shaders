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
  const vec3 artificialLightColor = vec3(0.8, 0.25, 0.08);
  const vec3 skyLightColor = vec3(1, 1, 0.9);

  vec3 artificalLighting = artificialLightColor * attenuateArtificial(lightmap.r);
  vec3 skyLighting = skyLightColor * attenuateSky(lightmap.g);

  return skyLighting + artificalLighting;
}