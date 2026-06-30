Shader "_ViriantoTem/HLSL/CartoonFX/ToonLit"
{
	Properties
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Ramp ("Toon Ramp (RGB)", 2D) = "gray" {} 
	}

	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
			"RenderPipeline" = "UniversalPipeline"
		}
		
		Pass
		{
			Name "FORWARD"
			
			Tags
			{
				"LightMode" = "UniversalForward"
				"RenderPipeline" = "UniversalPipeline"
			}
			
			HLSLPROGRAM
			
			#pragma vertex vertexShader
			#pragma fragment pixelShader	

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			struct vertexInfo
			{
				min16float4 positionOS : POSITION;
				min16float2 uv : TEXCOORD0;
				min16float3 normalOS : NORMAL;
			};

			struct v2p
			{
				min16float4 positionCS : SV_POSITION;
				min16float2 uv : TEXCOORD0;
				min16float3 normalWS : TEXCOORD1;
			};
			
			// UNIFORMS: External parameters
			
			TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
			TEXTURE2D(_Ramp); SAMPLER(sampler_Ramp);
			
			CBUFFER_START(UnityPerMaterial)
				min16float4 _Color;
				min16float4 _MainTex_ST;
			CBUFFER_END

			v2p vertexShader (vertexInfo v)
			{
				v2p o;
				o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normalWS = TransformObjectToWorldNormal(v.normalOS);
				return o;
			}

			min16float4 pixelShader (v2p i) : SV_Target
			{
				min16float4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv) * _Color;
				
				Light light = GetMainLight();
				
				half d = dot(normalize(i.normalWS), light.direction) * 0.5 + 0.5;
				min16float3 ramp = SAMPLE_TEXTURE2D(_Ramp, sampler_Ramp, min16float2(d, d)).rgb;
				
				min16float3 finalColor = texColor.rgb * light.color * ramp * (light.distanceAttenuation * light.shadowAttenuation);
				return min16float4(finalColor, texColor.a);
			}
			
			ENDHLSL
		}
	}
	// DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}
