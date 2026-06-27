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
			}
			
			HLSLPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			struct Attributes
			{
				float4 positionOS : POSITION;
				float2 uv : TEXCOORD0;
				float3 normalOS : NORMAL;
			};

			struct Varyings
			{
				float4 positionCS : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normalWS : TEXCOORD1;
			};

			CBUFFER_START(UnityPerMaterial)
				half4 _Color;
				float4 _MainTex_ST;
			CBUFFER_END

			TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
			TEXTURE2D(_Ramp); SAMPLER(sampler_Ramp);

			Varyings vert (Attributes v)
			{
				Varyings o;
				o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normalWS = TransformObjectToWorldNormal(v.normalOS);
				return o;
			}

			half4 frag (Varyings i) : SV_Target
			{
				half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv) * _Color;
				
				Light light = GetMainLight();
				
				half d = dot(normalize(i.normalWS), light.direction) * 0.5 + 0.5;
				half3 ramp = SAMPLE_TEXTURE2D(_Ramp, sampler_Ramp, float2(d, d)).rgb;
				
				half3 finalColor = texColor.rgb * light.color * ramp * (light.distanceAttenuation * light.shadowAttenuation);
				return half4(finalColor, texColor.a);
			}
			ENDHLSL
		}
	}
	Fallback "Diffuse"
}
