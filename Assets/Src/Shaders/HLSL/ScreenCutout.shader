Shader "_ViriantoTem/HLSL/ScreenCutout"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Lighting Off
		Cull Back
		ZWrite On
		ZTest Less
		
		Pass
		{
			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			struct appdata
			{
				min16float4 vertex : POSITION;				
			};

			struct v2f
			{		
				min16float4 vertex : SV_POSITION;
				min16float4 screenPos : TEXCOORD0;				
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = TransformObjectToHClip(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			sampler2D _MainTex;

			min16float4 frag (v2f i) : SV_Target
			{
				i.screenPos /= i.screenPos.w;
				min16float4 col = tex2D(_MainTex, min16float2(i.screenPos.x, i.screenPos.y));
				
				return col;
			}
			
			ENDHLSL
		}
	}
}