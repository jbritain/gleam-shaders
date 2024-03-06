vec3 encodeNormal(vec3 normal){
  return normal * 0.5 + 0.5;
}

vec3 decodeNormal(vec3 encodedNormal){
  return (encodedNormal - 0.5) * 2.0;
}