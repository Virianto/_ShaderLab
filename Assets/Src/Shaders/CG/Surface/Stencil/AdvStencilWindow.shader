Shader "Custom/Surface/Stencil/AdvStencilWindow" 
{
	// This surface shader is an advanced version of "Hole" shader but works in a very similar way
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8602726?start=23

	Properties
	{
		_Color("Color", Color) = (1,1,1,1)

		_StencilRef ("Stencil Ref", Float) = 1

		// More information here: https://docs.unity3d.com/ScriptReference/Rendering.CompareFunction.html
		[Enum(UnityEngine.Rendering.CompareFunction)]
		_StencilComp ("Stencil Comp", Float) = 8

		// More information here: https://docs.unity3d.com/ScriptReference/Rendering.StencilOp.html
		[Enum(UnityEngine.Rendering.StencilOp)]
		_StencilOp("Stencil Op", Float) = 2
	}

	SubShader
	{
		// This will automatically tell the GPU to process this shader right before geometry so it knows what to hide
		Tags{"Queue" = "Geometry-1"}

		ZWrite Off

		// This turns off any coloring being written to the frame buffer
		ColorMask 0

		// Always place Stencil options between Tags and CGPROGRAM block
		Stencil
		{
			Ref [_StencilRef]	// ID of this shader in Stencil buffer (several shaders can have the same for comparisons)
			Comp [_StencilComp]	// Look for other "Ref" with the same value as this one
			Pass [_StencilOp]	// Remove those fragments from that geometry
		}

		CGPROGRAM

		// We have added "alpha : fade" after de usual Lambert pragma in order to process transparency
		#pragma surface surf Lambert //alpha:fade

		float4 _Color;

		struct Input
		{
			float3 viewDir;
		};		

		void surf(Input IN, inout SurfaceOutput o)
		{			
			o.Albedo = _Color.rgb;				
		}
		ENDCG
	}
	FallBack "Diffuse"
}
