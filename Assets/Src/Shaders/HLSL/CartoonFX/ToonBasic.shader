Shader "_ViriantoTem/HLSL/CartoonFX/ToonBasic"
{
	Properties
	{
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ToonShade ("ToonShader Cubemap(RGB)", CUBE) = "" { }
	}

	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"			
		}
		
		Pass
		{
			Name "BASE"
			Cull Off
			
			HLSLPROGRAM
			
			#pragma vertex vertexShader
			#pragma fragment pixelShader

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			struct vertexInfo 
			{
				min16float4 vertex : POSITION;
				min16float2 uv : TEXCOORD0;
				min16float3 normal : NORMAL;
			};
			
			struct v2p 
			{
				min16float4 pos : SV_POSITION;
				min16float2 uv : TEXCOORD0;
				min16float3 normal : TEXCOORD1;
			};
			
			// UNIFORMS: External parameters
			
			sampler2D _MainTex;
			min16float4 _MainTex_ST;
			
			samplerCUBE _ToonShade;			
			min16float4 _Color;

			v2p vertexShader (vertexInfo v)
			{
				v2p o;
				o.pos = TransformObjectToHClip(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = normalize(mul((min16float3x3)unity_WorldToObject, v.normal));
				return o;
			}

			min16float4 pixelShader (v2p i) : SV_Target
			{
				min16float4 col = _Color * tex2D(_MainTex, i.uv);
				min16float4 cube = texCUBE(_ToonShade, i.normal);
				min16float4 c = min16float4(2.0f * cube.rgb * col.rgb, col.a);
				return c;
			}
			
			ENDHLSL			
		}
	} 
	// DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}
