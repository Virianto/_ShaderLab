Shader "_ViriantoTem/HLSL/CartoonFX/ToonBasicOutline"
{
	Properties
	{
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_Outline ("Outline width", Range (.002, 0.03)) = .005
		_MainTex ("Base (RGB)", 2D) = "white" { }
		_ToonShade ("ToonShader Cubemap(RGB)", CUBE) = "" { }
	}

	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"			
		}
		
		UsePass "ToonBasic/BASE"
		
		Pass
		{
			Name "OUTLINE"
			
			Tags
			{
				"LightMode" = "Always"				
			}
			
			Cull Front
			ZWrite On
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha

			HLSLPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	
			uniform float _Outline;
			uniform float4 _OutlineColor;
			
			struct appdata 
			{
				half4 vertex : POSITION;
				half3 normal : NORMAL;
			};

			struct v2f 
			{
				half4 pos : SV_POSITION;
				half4 color : COLOR;
			};
	
			v2f vert(appdata v) 
			{
				v2f o;
				o.pos = TransformObjectToHClip(v.vertex.xyz);

				float3 normalWS = TransformObjectToWorldNormal(v.normal);
				float3 normalVS = TransformWorldToViewDir(normalWS);
				float2 offset = mul((float2x2)UNITY_MATRIX_P, normalVS.xy);

				o.pos.xy += offset * o.pos.w * _Outline;
				o.color = _OutlineColor;
				return o;
			}
			
			half4 frag(v2f i) : SV_Target
			{
				return i.color;
			}
			
			ENDHLSL
		}
	}
	
	Fallback "VertexLit"
}
