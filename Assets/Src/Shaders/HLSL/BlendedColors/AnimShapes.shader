Shader "_ViriantoTem/HLSL/BlendedColors/AnimShapes"
{
    Properties
    {
		_Zoom("Zoom", Float) = 6
		_Scale("Scale", Float) = .5
		_Exposure("Exposure", Float) = 2
		_Speed("Speed", Float) = .75
		_Iterations("Iterations", Int) = 6
		_Saturation("Saturation", Float) = .5
		_Power("Power", Float) = 1.75
		_ColorInterval("ColorInterval", Float) = .4
		_Shift("Shift", Float) = 1.5
    }

    SubShader
    {
		Tags
		{
			"RenderType" = "Opaque"
			"RenderPipeline" = "UniversalRenderPipeline"
		}

        Pass
        {
			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "HLSLSupport.cginc"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"			

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

			float _Zoom;
			float _Scale;
			float _Exposure;
			float _Speed;
			int _Iterations;
			float _Saturation;
			float _Power;
			float _ColorInterval;
			float _Shift;

			half3 gradientGenerator(float t) 
			{
				half3 a = half3(0.5, 0.5, 0.5);
				half3 b = half3(0.5, 0.5, 0.5);
				half3 c = half3(1.0, 1.0, 1.0);
				half3 d = half3(0.263, 0.416, 0.557);

				return a + b * cos(6.28318 * (c * t + d));
			}

			v2f vert(appdata v)
			{
				v2f o;

				o.vertexPos = TransformObjectToHClip(v.vertexPos);
				o.uv = v.texCoord;

				return o;
			}

			fixed4 frag(v2f inData) : SV_Target
			{
				fixed4 c;

				fixed2 u = (inData.uv * 2 - 1) * _Scale;
				float l = length(u);
				float t = _Time.y * _Speed;

				for (int i = 0; i <= _Iterations; i++)
				{
					u = frac(u * _Shift) - .5;
					c += pow(
						abs(
							_Exposure * .01 / sin(
								length(u) * exp(-l) * _Zoom + t
							)
						), _Power
					) * (
						.5 + .5 * cos(
							_Saturation * 3.14159 * 4 * (
								l + (i + t) * _ColorInterval + half4(.26, .42, .56, 0)
							)
						)
					);
				}
				return c;
			}
			ENDHLSL
        }
    }
}
