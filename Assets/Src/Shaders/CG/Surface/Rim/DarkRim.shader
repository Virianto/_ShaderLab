Shader "Custom/Surface/Rim/DarkRim" 
{
	// This surface shader creates te effect of darkening the edges of an object with the given color
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569300?start=0

	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		struct Input
		{
			float3 viewDir;
		};

		float4 _Color;

		void surf(Input IN, inout SurfaceOutput o)
		{
			half rim = dot(normalize(IN.viewDir), o.Normal);
			o.Emission = _Color.rgb * rim;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
