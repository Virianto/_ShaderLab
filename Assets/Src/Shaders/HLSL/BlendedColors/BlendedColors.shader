Shader "_ViriantoTem/HLSL/BlendedColors"
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
		Pass
		{
			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "HLSLSupport.cginc"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			fixed4 _ColorA;
			fixed4 _ColorB;
			fixed _Horizontal;
			fixed _FlipAxis;

			struct appdata
			{
				float4 vertexPos : POSITION;
				fixed2 texCoord : TEXCOORD0;	// This could be float4, or half4, or fixed4... but fixed2 is the most optimus
			};

			struct v2f
			{
				float4 vertexPos : SV_POSITION;
				fixed2 uv : TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;

				o.vertexPos = TransformObjectToHClip(v.vertexPos);	
				o.uv = v.texCoord;

				return o;
			}
			
			// The returned value of this fragment function will be a half4 attribute related to the color hardware resource
			half4 frag (v2f i) : SV_Target
			{
				float direction = _Horizontal ? i.uv.x : i.uv.y;
				half4 c = _FlipAxis ? lerp(_ColorB, _ColorA, direction) : lerp(_ColorA, _ColorB, direction);

				return c;
			}
			ENDHLSL
		}
	}
}
