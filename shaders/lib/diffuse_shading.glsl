vec3 getDiffuseShading(vec3 albedo, vec3 normal, vec3 lighting){
  float nDotL = max(dot(normal, normalize(sunPosition)), 0.0);

  return albedo * (nDotL + AMBIENT_LIGHT + lighting);
}