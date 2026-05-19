Shader "Custom/Surface/Advanced/VertexDisplacement" 
{
	// This surface shader creates and inflation effect over time

	Properties
	{
		_MainTexture("Texture", 2D) = "white"{}

		_DispTexture("Displacement texture", 2D) = "white"{}
		_Displacement("Displacement", Range(0, 2)) = 1
		_Speed("Speed", Range(-2, 2)) = 1
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert vertex:vert addshadow	// Here we've specified a new function that we'll use below

		sampler2D _MainTexture;

		sampler2D _DispTexture;
		half _Displacement;
		half _Speed;

		struct Input
		{
			float3 worldPos;
			float2 uv_MainTexture;
		};

		// This function has to be added manually when we want to touch vertices in a surface shader
		void vert(inout appdata_full v, out Input o)
		{
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

			half d = tex2Dlod(_DispTexture, float4(worldPos.x, worldPos.y + (_Time.y * _Speed), 0, 0));
			UNITY_INITIALIZE_OUTPUT(Input, o);
			v.vertex.xyz += _Displacement * v.normal * d;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Emission = tex2D(_MainTexture,  IN.uv_MainTexture).rgb;	// Can write o.Emssion instead of Albedo for unlit colors
		}
		ENDCG
	}
	FallBack "Diffuse"
}
