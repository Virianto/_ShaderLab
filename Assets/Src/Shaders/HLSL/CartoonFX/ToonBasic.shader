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
			
			#pragma vertex vert
			#pragma fragment frag

			#include "HLSLSupport.cginc"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			sampler2D _MainTex;
			samplerCUBE _ToonShade;
			float4 _MainTex_ST;
			float4 _Color;

			struct appdata 
			{
				half4 vertex : POSITION;
				half2 uv : TEXCOORD0;
				half3 normal : NORMAL;
			};
			
			struct v2f 
			{
				half4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				half3 normal : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = TransformObjectToHClip(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = normalize(mul((half3x3)unity_WorldToObject, v.normal));
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = _Color * tex2D(_MainTex, i.uv);
				fixed4 cube = texCUBE(_ToonShade, i.normal);
				fixed4 c = fixed4(2.0f * cube.rgb * col.rgb, col.a);
				return c;
			}
			ENDHLSL			
		}
	} 

	Fallback "VertexLit"
}
