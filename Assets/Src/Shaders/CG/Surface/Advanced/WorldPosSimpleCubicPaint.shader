Shader "Custom/Surface/Advanced/WorldPosSimpleCubicPaint" 
{
	Properties
	{
		_Color("Primary Color", Color) = (1,1,1,1)
		_MainTex("Primary (RGB)", 2D) = "white" {}
		_Color2("Secondary Color", Color) = (1,1,1,1)
		_SecondTex("Secondary (RGB)", 2D) = "white" {}
		_Radius("Radius", Range(0, 4)) = 0
		_DisLineWidth("Line Width", Range(0, 0.5)) = 0
		_DisLineColor("Line Tint", Color) = (1,1,1,1)
	}

	SubShader
	{
		Tags { "RenderType" = "Transparent" }
		LOD 200

		CGPROGRAM

		#pragma surface surf Lambert exclude_path:prepass

		float3 _Position;

		sampler2D _MainTex, _SecondTex;
		float4 _Color, _Color2;
		float _DisLineWidth;
		float4 _DisLineColor;
		float _Radius;

		// Data structure for surface method (catching only built in values needed like worldPos)
		struct Input
		{
			float2 uv_MainTex : TEXCOORD0;
			float3 worldPos;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			half4 c2 = tex2D(_SecondTex, IN.uv_MainTex) * _Color2;
			
			// distance influencer position to world position
			fixed difX = abs(IN.worldPos.x - _Position.x);
			fixed difY = abs(IN.worldPos.y - _Position.y);
			fixed difZ = abs(IN.worldPos.z - _Position.z);

			if (difX < _Radius && difY < _Radius && difZ < _Radius)
			{				
				o.Albedo = c2.rgb;
			}
			else if (difX < (_Radius + _DisLineWidth) && difY < (_Radius + _DisLineWidth) && difZ < (_Radius + _DisLineWidth))
			{
				o.Emission = _DisLineColor.rgb;
			}
			else
			{
				o.Albedo = c.rgb;				
			}

			o.Alpha = c.a;
		}
		ENDCG
	}
	Fallback "Diffuse"
}