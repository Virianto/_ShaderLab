Shader "_ViriantoTem/HLSL/Unlit/UVDisplayer"
{
	// Paints the object following the UV coordinates, this way we can
	// know how textures will fit on its surface.
	// Only green and red are shown since UV corresponds to the first
	// two variables of half4 : COLOR --> R G B A
	SubShader
	{
		Tags
		{
			"RenderPipeline" = "UniversalPipeline"			
		}
		
		Pass
		{
			HLSLPROGRAM

			#pragma vertex vertexShader
			#pragma fragment pixelShader	
			
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			// Data structure: Before vertex shader (mesh info)
			struct vertexInfo
			{
				min16float4 vertexPos : POSITION;
				min16float2 texCoord : TEXCOORD0;	
			};

			// Data structure: Vertex shader to Pixel shader
			// (Also called interpolants because values interpolates through the triangle
			// from one vertex to another)
			struct v2p
			{
				min16float4 vertexPos : SV_POSITION;
				min16float4 uv : TEXCOORD0;
			};

			v2p vertexShader (vertexInfo v)
			{
				v2p o;
				o.vertexPos = TransformObjectToHClip(v.vertexPos);
				o.uv = min16float4(v.texCoord.xy, 0, 0);					

				return o;
			}
			
			
			min16float4 pixelShader (v2p i) : SV_Target
			{
				min16float4 c = frac(i.uv);									
				return c;
			}
			
			ENDHLSL
		}
	}
	// DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^	
}