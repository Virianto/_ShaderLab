Shader "_ViriantoTem/HLSL/Unlit/BlendedColors"
{
	// This pixel shader paints a gradient between the given colors along the X axis in UVs
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8602852?start=0
	
	Properties
	{
		_ColorA("Color A", Color) = (0,0,0,1)
		_ColorB("Color B", Color) = (1,1,1,1)

		[Toggle]
		_Horizontal("Horizontal gradient", Float) = 1

		[Toggle]
		_FlipAxis("Flip axis", Float) = 0
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
			min16float _Horizontal;
			min16float _FlipAxis;

			v2p vertexShader (vertexInfo v)
			{
				v2p o;

				o.vertexPos = TransformObjectToHClip(v.vertexPos);	
				o.uv = v.texCoord;

				return o;
			}
			
			// The returned value of this fragment function will be a half4 attribute related to the color hardware resource
			min16float4 pixelShader (v2p i) : SV_Target
			{
				min16float direction = _Horizontal ? i.uv.x : i.uv.y;
				min16float4 c = _FlipAxis ? lerp(_ColorB, _ColorA, direction) : lerp(_ColorA, _ColorB, direction);

				return c;
			}
			
			ENDHLSL
		}
	}
	// DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}
