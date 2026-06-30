Shader "_ViriantoTem/HLSL/ScreenCutout"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
	}
	
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"RenderPipeline" = "UniversalPipeline"
		}
		
		Lighting Off
		Cull Back
		ZWrite On
		ZTest Less
		
		Pass
		{
			HLSLPROGRAM

			#pragma vertex vertexShader
			#pragma fragment pixelShader			
			
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			// UNIFORMS: External parameters
			// This macro declares _MainTex as a Texture2D object
			Texture2D<min16float2> _MainTex;
			min16float4 _MainTex_ST;
			
			// Data structure: Before vertex shader (mesh info)
			struct vertexInfo
			{
				min16float4 vertex : POSITION;				
			};

			// Data structure: Vertex shader to Pixel shader
			// (Also called interpolants because values interpolates through the triangle
			// from one vertex to another)
			struct v2p
			{		
				min16float4 vertex : SV_POSITION;
				min16float4 screenPos : TEXCOORD0;				
			};

			v2p vertexShader (vertexInfo v)
			{
				v2p o;
				o.vertex = TransformObjectToHClip(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				return o;
			}

			min16float4 pixelShader (v2p i) : SV_Target
			{
				i.screenPos /= i.screenPos.w;
				min16float4 col = tex2D(_MainTex, min16float2(i.screenPos.x, i.screenPos.y));
				
				return col;
			}
			
			ENDHLSL
		}
	}
	// DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}