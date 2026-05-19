Shader "Custom/Surface/Transparencies/HolographicRim" 
{
	// This surface shader is similar to Rim ones but works with transparency with the purpose of generating a holographic effect
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569484?start=0

	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Softening("Softening", Range(0.2, 5)) = 2
	}

	SubShader
	{
		// This will automatically tell the GPU to process this shader after Geometry has been rendered (shadows will be seen behind)
		Tags{"Queue" = "Transparent"}

		CGPROGRAM

		// We have added "alpha : fade" after de usual Lambert pragma in order to process transparency
		#pragma surface surf Lambert alpha:fade

		float4 _Color;
		half _Softening;

		struct Input
		{
			float3 viewDir;
		};		

		void surf(Input IN, inout SurfaceOutput o)
		{
			half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
			
			o.Albedo = _Color.rgb * pow(rim, _Softening);	// Can write o.Albedo instead of Emission for light responsive color
			o.Alpha = pow(rim, _Softening);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
