vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

// https://github.com/WhyFenceCode/Saturus/blob/07bf00890435fc6b35570b4a15c789dc4da68a88/shaders/common_programs/common.glsl

vec4 hsv(vec4 color) {
   vec3 rgb = color.rgb;
   float r = rgb.r, g = rgb.g, b = rgb.b;
   float maxComponent = max(max(r, g), b);
   float minComponent = min(min(r, g), b);
   float delta = maxComponent - minComponent;

   vec4 hsv = vec4(0.0, 0.0, maxComponent, color.a);

   if (delta != 0.0) {
       hsv.y = delta / maxComponent;
       if (r == maxComponent) {
           hsv.x = (g - b) / delta;
       } else if (g == maxComponent) {
           hsv.x = 2.0 + (b - r) / delta;
       } else {
           hsv.x = 4.0 + (r - g) / delta;
       }
       hsv.x *= 60.0;
       if (hsv.x < 0.0) {
           hsv.x += 360.0;
       }
   }

   return hsv;
}

vec4 rgb(vec4 color){
  vec3 hsv = color.rgb;
   float h = hsv.x, s = hsv.y, v = hsv.z;
   float r, g, b;

   int i = int(floor(h / 60.0));
   float f = h / 60.0 - float(i);
   float p = v * (1.0 - s);
   float q = v * (1.0 - s * f);
   float t = v * (1.0 - s * (1.0 - f));

   switch (i % 6) {
       case 0: r = v; g = t; b = p; break;
       case 1: r = q; g = v; b = p; break;
       case 2: r = p; g = v; b = t; break;
       case 3: r = p; g = q; b = v; break;
       case 4: r = t; g = p; b = v; break;
       case 5: r = v; g = p; b = q; break;
   }

   return vec4(r, g, b, color.a);
}

float pow2(float x){
    return x * x;
}

float pow3(float x){
    return x * x * x;
}

float pow4(float x){
    return x * x * x * x;
}

#ifdef fsh
vec3 fragmentViewSpacePos(vec2 texCoord){
    vec3 screenPos = vec3(texCoord, texture2D(depthtex0, texCoord));
    vec3 ndcPos = screenPos * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, ndcPos);
    return viewPos;
}
#endif