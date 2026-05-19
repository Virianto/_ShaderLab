Shader "Venat/Surface/WorldPosCubicStencil" 
{
	Properties
	{
		[Header(Main properties)]

		_OuterColor("Outer Color", Color) = (1,1,1,1)
		_MainTex("Texture (RGB)", 2D) = "white" {}

		_InnerColor("Inner Color", Color) = (1,1,1,1)
		
		[Header(Dissolving properties)]

		_DisLineWidth("Line Width", Range(0, 0.5)) = 0
		_DisLineColor("Line Tint", Color) = (1,1,1,1)

		[Header(World limits)]
		_MinX("MinX", Float) = 0
		_MaxX("MaxX", Float) = 0
		_MinY("MinY", Float) = 0
		_MaxY("MaxY", Float) = 0
		_MinZ("MinZ", Float) = 0
		_MaxZ("MaxZ", Float) = 0
	}

	SubShader
	{								
		Cull Off

		CGPROGRAM

		#pragma target 3.0
		#pragma surface surf Lambert alphatest:_ALPHA addshadow
		
		fixed3 _Position;

		sampler2D_half _MainTex;
		fixed4 _OuterColor, _InnerColor;
		fixed _DisLineWidth;
		fixed4 _DisLineColor;

		fixed _MinX;
		fixed _MaxX;
		fixed _MinY;
		fixed _MaxY;
		fixed _MinZ;
		fixed _MaxZ;

		// Data structure for surface method (catching only built in values needed like worldPos)
		struct Input
		{
			fixed2 uv_MainTex : TEXCOORD0;
			fixed3 worldPos;
			fixed IsFacing : VFACE;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _OuterColor;
			
			bool isInX = (IN.worldPos.x > _MinX + _DisLineWidth && IN.worldPos.x < _MaxX - _DisLineWidth);
			bool isInY = (IN.worldPos.y > _MinY + _DisLineWidth && IN.worldPos.y < _MaxY - _DisLineWidth);
			bool isInZ = (IN.worldPos.z > _MinZ + _DisLineWidth && IN.worldPos.z < _MaxZ - _DisLineWidth);

			bool isInLineX = (IN.worldPos.x > _MinX && IN.worldPos.x < _MaxX);
			bool isInLineY = (IN.worldPos.y > _MinY && IN.worldPos.y < _MaxY);
			bool isInLineZ = (IN.worldPos.z > _MinZ && IN.worldPos.z < _MaxZ);
			
			o.Alpha = 0;

			if (isInX && isInY && isInZ)
			{	
				if (IN.IsFacing < 0) 
				{
					o.Emission = c.rgb;
				}
				else 
				{
					o.Albedo = c.rgb;
				}											
			}
			else if (isInLineX && isInLineY && isInLineZ)
			{
				o.Emission = _DisLineColor.rgb;				
			}
			else
			{
				clip(-1);
			}				

			if (IN.IsFacing < 0)
			{
				o.Emission = _InnerColor;
			}			
		}
		ENDCG
	}
	Fallback "Diffuse"
}