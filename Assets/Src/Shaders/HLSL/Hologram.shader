Shader "Custom/HLSL/Hologram"
{
    Properties
	{
		[Header(Main options)]

		_MainColor("Main Color", Color) = (0.4438857, 0.7075472, 0.4713053, 0)	
		[HDR]_RimColor("Rim Color", Color) = (1.498039, 0.5411765, 0, 0)
		_RimPower("RimPower", Float) = 0.5
		_Opacity("Opacity", Float) = 0.5

		[Header(Hologram options)]

		_HologramTex("Hologram Texture", 2D) = "white" {}
		_TexStrength("Texture strength", Float) = 0.5		
		_ScrollSpeed("Scroll Speed", Float) = 0.1
	}
		
	SubShader
	{
		Tags
		{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
			"RenderPipeline" = "UniversalRenderPipeline"
		}

		Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha

		Pass
		{
			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "HLSLSupport.cginc"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			float4 _MainColor, _RimColor;
			sampler2D_half _HologramTex;
			float _RimPower, _Opacity, _ScrollSpeed, _TexStrength;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 positionWS : TEXCOORD1;
				float3 normalWS : TEXCOORD2;
				float3 viewDir: TEXCOORD3;
			};

			v2f vert(appdata v)
			{
				v2f o;

				o.vertex = TransformObjectToHClip(v.vertex);
				o.uv = v.uv;
				o.positionWS = TransformObjectToWorld(v.vertex.xyz);
				o.normalWS = TransformObjectToWorldNormal(v.normal.xyz);
				o.viewDir = normalize(_WorldSpaceCameraPos - o.positionWS);				

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float rimAmount = (1 - max(0, dot(i.normalWS, i.viewDir))) * _RimPower;
				float3 rimColor = rimAmount * _RimColor;

				float insideRim = 1 - rimAmount;
				float4 insideColor = (insideRim * _MainColor) + float4(0, 0, 0, _Opacity);

				float2 scrolledUV = i.uv + float2(0, _ScrollSpeed * _Time.y * 0.01);

				float4 finalColor = lerp(insideColor, float4(rimColor, 1), rimAmount);

				finalColor = lerp(finalColor, tex2D(_HologramTex, scrolledUV), _TexStrength);

				finalColor.a *= _Opacity;				

				return finalColor;
			}

				ENDHLSL
		}
	}
}