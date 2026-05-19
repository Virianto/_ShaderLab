Shader "Custom/LaserBeam"
{
    Properties
	{
		_MainTexture("Texture", 2D) = "white"{}

		_DispTexture("Displacement texture", 2D) = "white"{}
		_Displacement("Displacement", Range(0, 2)) = 1
		_Speed("Speed", Range(-2, 2)) = 1

		_ContainerColor("Container Color", Color) = (1,1,1,1)
		_Softening("Softening", Range(0.2, 5)) = 2
	}

	// Vertex Displacement
	SubShader
	{
		// This will automatically tell the GPU to process this shader after Geometry has been rendered (shadows will be seen behind)
		Tags{"Queue" = "Transparent"}

		//Cull Off
		ZWrite Off

		CGPROGRAM		

		#pragma surface surf Lambert vertex:vert addshadow alpha:fade	// Here we've specified a new function that we'll use below

		sampler2D _MainTexture;

		sampler2D _DispTexture;
		half _Displacement;
		half _Speed;

		float4 _ContainerColor;
		half _Softening;

		struct Input
		{
			float3 viewDir;
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
			half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
			half grad = pow(rim, _Softening);

			if (rim > 0.4)
			{
				o.Albedo = _ContainerColor.rgb * grad;	// Can write o.Albedo instead of Emission for light responsive color

				o.Alpha = pow(rim, _Softening);
			}

			o.Emission = tex2D(_MainTexture,  IN.uv_MainTexture).rgb;	// Can write o.Emssion instead of Albedo for unlit colors
		}
		ENDCG
	}


	// Filled Rim
	SubShader
	{		
		CGPROGRAM		

		#pragma surface surf Lambert alpha:fade

		

		half _FillRate;
		float4 _LiquidColor;

		struct Input
		{
			
			float3 worldPos;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			
			
		}
		ENDCG
		}
	FallBack "Diffuse"
}