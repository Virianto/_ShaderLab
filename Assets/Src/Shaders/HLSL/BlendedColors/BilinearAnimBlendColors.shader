Shader "_ViriantoTem/HLSL/BilinearAnimBlendColors"
{
	// C ---- D
	// |      |
	// |      |
	// A ---- B

	Properties
	{				
		_ColorA("Color A", Color) = (1, 0, 0, 1)
		_ColorB("Color B", Color) = (0, 1, 0, 1)
		_ColorC("Color C", Color) = (0, 0, 1, 1)
		_ColorD("Color D", Color) = (1, 0, 1, 1)

		_Speed("Speed", Range(-5, 5)) = 1

		[Toggle]
		_Vertical("Vertical gradient", Float) = 1
	}

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
				min16float2 uv : TEXCOORD0;
			};
			
			// UNIFORMS: External parameters
			
			min16float4 _ColorA;
			min16float4 _ColorB;
			min16float4 _ColorC;
			min16float4 _ColorD;
			min16float _Speed;
			min16float _Vertical;

			v2p vertexShader(vertexInfo v)
			{
				v2p o;

				o.vertexPos = TransformObjectToHClip(v.vertexPos);
				o.uv = v.texCoord;

				return o;
			}

			min16float4 pixelShader(v2p i) : SV_Target
			{
				min16float4 finalColorRGBA;

				min16float moveDir = _Vertical ? i.uv.x : i.uv.y;
				min16float gradDir = _Vertical ? i.uv.y : i.uv.x;

				min16float4 colorY1 = (1.0 - gradDir) * _ColorA.rgba + gradDir * _ColorB.rgba;
				min16float4 colorY2 = (1.0 - gradDir) * _ColorC.rgba + gradDir * _ColorD.rgba;

				min16float stripe = frac(((moveDir + (_Time.y * _Speed)) * 0.5));
				min16float smoothedStripe = saturate((1 - (smoothstep(0.5, 1, stripe) + smoothstep(0.5, 1, (1 - stripe)))));

				finalColorRGBA = lerp(colorY1.rgba, colorY2.rgba, smoothedStripe);					
					
				return finalColorRGBA;
			}
			ENDHLSL
		}
	}
}