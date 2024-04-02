#ifdef SHADOW_DISTORT_ENABLED
	vec3 distort(vec3 pos) {
		float factor = length(pos.xy) + SHADOW_DISTORT_FACTOR;
		return vec3(pos.xy / factor, pos.z * 0.5);
	}

#else
	vec3 distort(vec3 pos) {
		return vec3(pos.xy, pos.z * 0.5);
	}
#endif

#ifdef vsh
vec4 getShadowPos(){
	vec4 shadowPos;

	float lightDot = dot(normalize(shadowLightPosition), normalize(gl_NormalMatrix * gl_Normal));
	#ifdef EXCLUDE_FOLIAGE
		//when EXCLUDE_FOLIAGE is enabled, act as if foliage is always facing towards the sun.
		//in other words, don't darken the back side of it unless something else is casting a shadow on it.
		if (mc_Entity.x == 10000.0) lightDot = 1.0;
	#endif

	vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
	// if (lightDot > 0.0) { //vertex is facing towards the sun
		vec4 playerPos = gbufferModelViewInverse * viewPos;
		shadowPos = shadowProjection * (shadowModelView * playerPos); //convert to shadow ndc space.
		shadowPos.xyz = distort(shadowPos.xyz); //apply shadow distortion
		shadowPos.xyz = shadowPos.xyz * 0.5 + 0.5; //convert from -1 ~ +1 to 0 ~ 1
	// }
	// else { //vertex is facing away from the sun
	// 	shadowPos = vec4(0.0); //mark that this vertex does not need to check the shadow map.
	// }
	shadowPos.w = lightDot;

	return shadowPos;
}
#endif

#ifdef fsh
float isInShadow(vec4 shadowPos, sampler2D shadowMap){
	if(shadowPos.xyz == vec3(0.0)){ // definitely in shadow
		return 1.0;
	}
	if (shadowPos.w > 0.0) {
		return step(texture(shadowMap, shadowPos.xy).r, shadowPos.z - SHADOW_BIAS); // check if depth is greater than in shadow map
	}
	return 1.0;
}

float getPCFShadow (vec4 shadowPos, sampler2D shadowMap, float rAngle){

	float cosT = cos(rAngle);
	float sinT = sin(rAngle);
	mat2 rot = mat2(cosT, -sinT, sinT, cosT) / shadowMapResolution;

	int samples = 0;
	float shadowAccum = 0;

	for (int x = -PCF_SAMPLE_COUNT; x <= PCF_SAMPLE_COUNT; x++){
		for (int y = -PCF_SAMPLE_COUNT; y <= PCF_SAMPLE_COUNT; y++){
			vec2 offset = rot * vec2(x, y);
			shadowAccum += isInShadow(shadowPos + vec4(offset, 0, 0), shadowMap);
			samples++;
		}
	}

	return shadowAccum / samples;
}
#endif