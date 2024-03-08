#ifdef SHADOW_DISTORT_ENABLED
	vec3 distort(vec3 pos) {
		float factor = length(pos.xy) + SHADOW_DISTORT_FACTOR;
		return vec3(pos.xy / factor, pos.z * 0.5);
	}

	//returns the reciprocal of the derivative of our distort function,
	//multiplied by SHADOW_BIAS.
	//if a texel in the shadow map contains a bigger area,
	//then we need more bias. therefore, we need to know how much
	//bigger or smaller a pixel gets as a result of applying sistortion.
	float computeBias(vec3 pos) {
		//square(length(pos.xy) + SHADOW_DISTORT_FACTOR) / SHADOW_DISTORT_FACTOR
		float numerator = length(pos.xy) + SHADOW_DISTORT_FACTOR;
		numerator *= numerator;
		return SHADOW_BIAS / shadowMapResolution * numerator / SHADOW_DISTORT_FACTOR;
	}
#else
	vec3 distort(vec3 pos) {
		return vec3(pos.xy, pos.z * 0.5);
	}

	float computeBias(vec3 pos) {
		return SHADOW_BIAS / shadowMapResolution;
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
	if (lightDot > 0.0) { //vertex is facing towards the sun
		vec4 playerPos = gbufferModelViewInverse * viewPos;
		shadowPos = shadowProjection * (shadowModelView * playerPos); //convert to shadow ndc space.
		float bias = computeBias(shadowPos.xyz);
		shadowPos.xyz = distort(shadowPos.xyz); //apply shadow distortion
		shadowPos.xyz = shadowPos.xyz * 0.5 + 0.5; //convert from -1 ~ +1 to 0 ~ 1
		//apply shadow bias.
		#ifdef NORMAL_BIAS
			//we are allowed to project the normal because shadowProjection is purely a scalar matrix.
			//a faster way to apply the same operation would be to multiply by shadowProjection[0][0].
			vec4 normal = shadowProjection * vec4(mat3(shadowModelView) * (mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal)), 1.0);
			shadowPos.xyz += normal.xyz / normal.w * bias;
		#else
			shadowPos.z -= bias / abs(lightDot);
		#endif
	}
	else { //vertex is facing away from the sun
		lmCoord.y *= SHADOW_INTENSITY; //guaranteed to be in shadows. reduce light level immediately.
		shadowPos = vec4(0.0); //mark that this vertex does not need to check the shadow map.
	}
	shadowPos.w = lightDot;

	return shadowPos;
}
#endif

#ifdef fsh
bool isInShadow(vec4 shadowPos, sampler2D shadowMap){
	if (shadowPos.w > 0.0) {
		return (texture(shadowMap, shadowPos.xy).r < shadowPos.z);
	}
}
#endif