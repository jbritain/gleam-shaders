void calculateFog(inout vec3 color, vec3 viewPos){
  float depth = length(viewPos) / (far * 1.1);
  if(depth <= 1.0){
    color = mix(color, fogColor, pow(depth, 4));
  }
}