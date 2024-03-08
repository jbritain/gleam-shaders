void calculateFog(inout vec3 color, vec3 viewPos){
  #ifdef FOG
  float depth = length(viewPos) / far;
  if(depth <= 1.0){
    color = mix(color, fogColor, pow(depth, 8));
  }
  #endif
}