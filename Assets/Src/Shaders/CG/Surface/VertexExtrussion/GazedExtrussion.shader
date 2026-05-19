Shader "Custom/Surface/VertexExtrussion/GazedExtrussion" 
{
	// This surface shader generates a vertex displacement depending on the vector received

	Properties
	{
		[Header(General properties)]

		[Header(Freezing properties)]

		_RegionColor("Region Color", Color) = (1,1,1,1)
		_IceLength("Ice Length", Range(-3, 3)) = 0

		[Header(Gaze properties)]

		_GazedColor("Gazed Color", Color) = (1,1,1,1)

		_X("X", Range(-1, 1)) = 0
		_Y("Y", Range(-1, 1)) = 0
		_Z("Z", Range(-1, 1)) = 0

		_Tolerance("Tolerance", Range(-1,1)) = 0
	}

	SubShader 
	{
		Tags { "RenderType" = "Transparent" }
		LOD 200

		CGPROGRAM

			#pragma surface surf Lambert
			#pragma vertex vert

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			#include "UnityCG.cginc"

			fixed _X;
			fixed _Y;
			fixed _Z;

			half _Tolerance;
			half _IceLength;

			fixed4 _RegionColor;
			fixed4 _GazedColor;

			// VERTEX MANAGEMENT -

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			void vert(inout appdata v)
			{
				fixed3 myVector;
				myVector = fixed3(_X, _Y, _Z);
				
				// Get a value which tells us if myVector and v.normal are facing each other (-><-) = -1 or not (<-<-) = 1	
				fixed d = dot(myVector, v.normal);								

				v.vertex.xyz += d >	_Tolerance ? (myVector * _IceLength) : 0;
			}

			// VERTEX MANAGEMENT -

			// SURFACE MANAGEMENT -

			struct Input 
			{
				half3 worldPos;
				fixed3 normal;
				half4 color : COLOR;
			};
					   
			void surf (Input IN, inout SurfaceOutput o) 
			{
				o.Albedo = _GazedColor;
			}

			// SURFACE MANAGEMENT -
		ENDCG
	}
	FallBack "Diffuse"
}