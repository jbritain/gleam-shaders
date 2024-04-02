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

vec3 getSkyDiffuse(vec3 albedo, float nDotL, vec2 lightmap, vec3 sunlightColor, float shadow){
  vec3 skyLighting = sunlightColor * attenuateSky(lightmap.g);

  return albedo * (nDotL * skyLighting) * (1.0 - shadow);
}

vec3 getArtificialDiffuse(vec3 albedo, vec2 lightmap){
  vec3 artificalLighting = artificialLightColor * attenuateArtificial(lightmap.r);

  return albedo * artificalLighting;
}