Shader "Custom/Surface/Rim/GradientRim" 
{
	// This surface shader works as an advanced version of the "DarkRim" and "ColorRim" shaders, enabling 
	// several options of modifying the way the rim is painted
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569300?start=0

	Properties
	{
		// For deeper property drawer knowledge: https://docs.unity3d.com/ScriptReference/MaterialPropertyDrawer.html

		[Toggle]
		_DarkRim("Darken edge", Float) = 0
		_Color("Color", Color) = (1,1,1,1)
		_Softening("Softening", Range(0.2, 5)) = 2
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		float _DarkRim;
		float4 _Color;
		half _Softening;

		struct Input
		{
			float3 viewDir;
		};		

		void surf(Input IN, inout SurfaceOutput o)
		{
			half rim = saturate(dot(normalize(IN.viewDir), o.Normal));
			rim = _DarkRim ? rim : 1 - rim;
			o.Emission = _Color.rgb * pow(rim, _Softening);	// Can write o.Albedo instead of Emission for light responsive color
		}
		ENDCG
	}
	FallBack "Diffuse"
}
