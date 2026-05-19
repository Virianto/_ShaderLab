Shader "Custom/Surface/Advanced/FilledRim" 
{
	Properties
	{
		// For deeper property drawer knowledge: https://docs.unity3d.com/ScriptReference/MaterialPropertyDrawer.html

		_ContainerColor("Container Color", Color) = (1,1,1,1)
		_Softening("Softening", Range(0.2, 5)) = 2

		_LiquidColor("Liquid Color", Color) = (1,1,1,1)
		_FillRate("Fill", Range(0, 2)) = 2
	}

	SubShader
	{

		// This will automatically tell the GPU to process this shader after Geometry has been rendered (shadows will be seen behind)
		Tags{"Queue" = "Transparent"}

		//Cull Off
		ZWrite Off

		CGPROGRAM		

		#pragma surface surf Lambert alpha:fade

		float4 _ContainerColor;
		half _Softening;

		half _FillRate;
		float4 _LiquidColor;

		struct Input
		{
			float3 viewDir;
			float3 worldPos;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
			half grad = pow(rim, _Softening);

			if (rim > 0.4) 
			{
				o.Albedo = _ContainerColor.rgb * grad;	// Can write o.Albedo instead of Emission for light responsive color

				o.Alpha = pow(rim, _Softening);
			}
			else
			{
				o.Albedo = _LiquidColor.rgb;	// Can write o.Albedo instead of Emission for light responsive color

				o.Alpha = IN.worldPos.y < _FillRate ? 0.5 : 0;
			}
			
		}
		ENDCG
		}
	FallBack "Diffuse"
}
