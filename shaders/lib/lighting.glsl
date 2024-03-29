float attenuateArtificial(float light){
  const float K = 2.0;
  const float P = 5.06;
  return K * pow(light, P);
}

float attenuateSky(float light){
  return pow4(light);
}

vec3 skylightColor = vec3(0.2, 0.2, 0.4);



vec3 getDiffuseShading(vec3 albedo, vec3 normal, vec2 lightmap){
  vec3 artificalLighting = artificialLightColor * attenuateArtificial(lightmap.r);
  vec3 skyLighting = skylightColor * attenuateSky(lightmap.g);

  float nDotL = max(dot(normal, normalize(shadowLightPosition)), 0.0);

  return (nDotL * skyLighting) + artificalLighting + AMBIENT_LIGHT;
}