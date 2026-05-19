Shader "Custom/Surface/VertexExtrussion/GazeFreezeExt" 
{
	// This surface shader works as an advanced version of GazedExtrussion by adding noise
	// and selective vertices extrussion

	Properties
	{
		[Header(General properties)]

		_MainColor("Main Color", Color) = (1,1,1,1)
		_MainTexture("Main Texture", 2D) = "white" {}

		[Header(Gaze properties)]

		_GazeColor("Gaze Color", Color) = (1,1,1,1)

		_X("X", Range(-1, 1)) = 0
		_Y("Y", Range(-1, 1)) = 0
		_Z("Z", Range(-1, 1)) = 0

		_Tolerance("Tolerance", Range(-1,1)) = 0

		[Header(Freezing properties)]

		_IceColor("Ice Color", Color) = (1,1,1,1)
		_IceLength("Ice Length", Range(-3, 3)) = 0
		_IceWidth("Ice Width", Range(0, 1)) = 0.1
		_NoiseTexture("Noise Texture", 2D) = "white" {}		
	}

	SubShader 
	{	 
		Tags { "Queue" = "Transparent" }
		LOD 200

		CGPROGRAM

			#pragma vertex vert
			#pragma surface surf Lambert			
			
			#include "UnityCG.cginc"

			fixed _X;
			fixed _Y;
			fixed _Z;

			half _Tolerance;
			half _IceLength;
			half _IceWidth;

			fixed3 gazeDir;

			fixed4 _MainColor;
			fixed4 _GazeColor;

			sampler2D _NoiseTexture;
			
			// VERTEX MANAGEMENT -

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
			};			
			
			void vert(inout appdata v)
			{				
				gazeDir = fixed3(_X, _Y, _Z);
				
				// Get a value which tells us if myVector and v.normal are facing each other (-><-) = -1 or not (<-<-) = 1	
				fixed d = dot(gazeDir, v.normal);
				half noiseExtrussion = tex2Dlod(_NoiseTexture, v.uv) * _IceLength;

				//v.vertex.xyz += d > _Tolerance ? (gazeDir * noiseExtrussion) : 0;
				//v.vertex.xyz += (d < (_Tolerance - _IceWidth) || d >= (_Tolerance + _IceWidth)) ? 0 : (gazeDir * noiseExtrussion);
				v.vertex.xyz += abs(d) < _IceWidth ? (gazeDir * noiseExtrussion) : 0;
			}

			// VERTEX MANAGEMENT -

			// SURFACE MANAGEMENT -			

			sampler2D _MainTexture;
			
			struct Input 
			{	
				float2 uv_MainTexture;
				half3 worldPos;
				half3 worldNormal;
			};
								   
			void surf (Input IN, inout SurfaceOutput o) 
			{
				gazeDir = fixed3(_X, _Y, _Z);
				fixed d = dot(gazeDir, IN.worldNormal);

				o.Albedo = abs(d) < _IceWidth ? _GazeColor : _MainColor;
			}

			// SURFACE MANAGEMENT -
		ENDCG
	}
	FallBack "Diffuse"
}