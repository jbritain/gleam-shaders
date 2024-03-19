float attenuateArtificial(float light){
  const float K = 2.0;
  const float P = 5.06;
  return K * pow(light, P);
}

float attenuateSky(float light){
  return pow4(light);
}

vec3 skylightColor = vec3(0.2, 0.2, 0.4);

float getSpecularShadingFactor(vec3 lightVector, vec3 viewPos, vec3 normal, float shininess, float specularStrength){
  vec3 viewVector = normalize(viewPos); // vector pointing towards fragment
  vec3 reflectionVector = reflect(-lightVector, normal); // reflected vector from the sun

  return pow(max(dot(viewVector, reflectionVector), 0.0), shininess) * specularStrength;
}

vec3 getDiffuseShading(vec3 albedo, vec3 normal, vec2 lightmap){
  vec3 artificalLighting = artificialLightColor * attenuateArtificial(lightmap.r);
  vec3 skyLighting = skylightColor * attenuateSky(lightmap.g);

  float nDotL = max(dot(normal, normalize(shadowLightPosition)), 0.0);

  return (nDotL * skyLighting) + artificalLighting + AMBIENT_LIGHT;
}

