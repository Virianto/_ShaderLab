Shader "Custom/Surface/Advanced/WorldPosNoisyCubicPaint" 
{
	Properties 
	{
        _Color ("Primary Color", Color) = (1,1,1,1)
        _MainTex ("Primary (RGB)", 2D) = "white" {}
        _Color2 ("Secondary Color", Color) = (1,1,1,1)
        _SecondTex ("Secondary (RGB)", 2D) = "white" {}
        _NoiseTex("Dissolve Noise", 2D) = "white"{}
        _NScale ("Noise Scale", Range(0, 10)) = 1
        _DisAmount("Noise Texture Opacity", Range(0.00, 1)) =0.01
        _Radius("Radius", Range(0, 4)) = 0
        _DisLineWidth("Line Width", Range(0, 8)) = 0
        _DisLineColor("Line Tint", Color) = (1,1,1,1)  
    }
 
    SubShader
	{
        Tags { "RenderType" = "Transparent" }
        LOD 200            
       
		CGPROGRAM
 
		#pragma surface surf Lambert exclude_path:prepass
  
		float3 _Position;
 
		sampler2D _MainTex, _SecondTex;
		float4 _Color, _Color2;
		sampler2D _NoiseTex;
		float _DisAmount, _NScale;
		float _DisLineWidth;
		float4 _DisLineColor;
		float _Radius;
 
		// Data structure for surface method (catching only built in values needed like worldPos or worldNormal)
		struct Input 
		{
			float2 uv_MainTex : TEXCOORD0;
			float3 worldPos;				
			float3 worldNormal;				
		};
 
		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			half4 c2 = tex2D(_SecondTex, IN.uv_MainTex) * _Color2;
 
			// distance influencer position to world position
			fixed difX = abs(IN.worldPos.x - _Position.x);
			fixed difY = abs(IN.worldPos.y - _Position.y);
			fixed difZ = abs(IN.worldPos.z - _Position.z);
			
			fixed edge = _Radius + _DisLineWidth;

			if (difX <= (edge - _DisLineWidth) && difY <= (edge - _DisLineWidth) && difZ <= (edge - _DisLineWidth))
			{
				// triplanar noise
				float3 blendNormal = saturate(pow(IN.worldNormal * 1.4, 4));
				half4 nSide1 = tex2D(_NoiseTex, (IN.worldPos.xy + _Time.x) * _NScale);
				half4 nSide2 = tex2D(_NoiseTex, (IN.worldPos.xz + _Time.x) * _NScale);
				half4 nTop = tex2D(_NoiseTex, (IN.worldPos.yz + _Time.x) * _NScale);

				float3 noisetexture = nSide1;
				noisetexture = lerp(noisetexture, nTop, blendNormal.x);
				noisetexture = lerp(noisetexture, nSide2, blendNormal.y);

				float3 dis = distance(_Position, IN.worldPos);
				fixed3 globalDis = (difX, difY, difZ);

				float3 sphere = 1 - saturate(dis / _Radius);

				//float3 sphereNoise = noisetexture.r * sphere;
				//float3 sphereNoise = noisetexture.r * difY;
				float3 sphereNoise;
				sphereNoise.x = noisetexture.r * difX;
				sphereNoise.y = noisetexture.r * difY;
				sphereNoise.z = noisetexture.r * difZ;

				// Line between two textures
				//float3 DissolveLine = step(sphere - _DisLineWidth, _DisAmount) * step(_DisAmount, sphere);
				fixed ar = step(difX, _DisAmount) * step(_DisAmount, difX);
				fixed br = step(difY, _DisAmount) * step(_DisAmount, difY);
				fixed cr = step(difZ, _DisAmount) * step(_DisAmount, difZ);
				float3 DissolveLine = (ar, br, cr);

				// Color the line
				DissolveLine *= _DisLineColor;

				float3 primaryTex = (step(sphereNoise - _DisLineWidth, _DisAmount) * c.rgb);
				float3 secondaryTex = (step(_DisAmount, sphereNoise) * c2.rgb);
				float3 resultTex = primaryTex + secondaryTex + DissolveLine;

				//o.Albedo = resultTex;
				o.Albedo = ((resultTex.r == c.r)&&(resultTex.g == c.g)&&(resultTex.b == c.b)) ? c2.rgb : c.rgb;
				o.Emission = DissolveLine;
				o.Alpha = c.a;

				//o.Albedo = noisetexture.r > 0.6 ? c : noisetexture.r < 0.55 ? c2 : _DisLineColor;
				//o.Albedo = cross(c2, noisetexture);
			}
			else
			{
				o.Albedo = c2.rgb;
			}

			//if (difX < _Radius && difY < _Radius && difZ < _Radius)
			//{
			//	o.Albedo = c.rgb;
			//}
			//else if (difX < edge && difY < edge && difZ < edge)
			//{
			//	// triplanar noise
			//	float3 blendNormal = saturate(pow(IN.worldNormal * 1.4, 4));
			//	half4 nSide1 = tex2D(_NoiseTex, (IN.worldPos.xy + _Time.x) * _NScale);
			//	half4 nSide2 = tex2D(_NoiseTex, (IN.worldPos.xz + _Time.x) * _NScale);
			//	half4 nTop = tex2D(_NoiseTex, (IN.worldPos.yz + _Time.x) * _NScale);

			//	float3 noisetexture = nSide1;
			//	noisetexture = lerp(noisetexture, nTop, blendNormal.x);
			//	noisetexture = lerp(noisetexture, nSide2, blendNormal.y);

			//	float3 dis = distance(_Position, IN.worldPos);
			//	fixed3 globalDis = (difX , difY, difZ);
			//	//float3 dis = frac(distance(_Position, IN.worldPos));	// Cool ringed effect			
			//	//float3 dis = (distance(_Position.x, IN.worldPos), distance(_Position.y, IN.worldPos), distance(_Position.z, IN.worldPos));
			//	//float3 dis = (_Position.x + IN.worldPos.x, _Position.y + IN.worldPos.y, _Position.z + IN.worldPos.z);
			//	//float3 dis = (difX + _DisLineWidth, difY + _DisLineWidth, difZ + _DisLineWidth);

			//	//float3 sphere = 1 - saturate(dis / _Radius);
			//	float3 sphere = 1 - saturate(dis / _Radius);

			//	float3 sphereNoise = noisetexture.r * sphere;
			//	//float3 sphereNoise = sphere;

			//	// Line between two textures
			//	//float3 DissolveLine = step(sphere - _DisLineWidth, _DisAmount) * step(_DisAmount, sphere) ;
			//	float3 DissolveLine = step(sphere - _DisLineWidth, _DisAmount) * step(_DisAmount, sphere);

			//	// Color the line
			//	DissolveLine *= _DisLineColor;

			//	float3 primaryTex = (step(sphereNoise - _DisLineWidth, _DisAmount) * c.rgb);
			//	float3 secondaryTex = (step(_DisAmount, sphereNoise) * c2.rgb);
			//	float3 resultTex = primaryTex + secondaryTex + DissolveLine;

			//	o.Albedo = resultTex;
			//	o.Emission = DissolveLine;
			//	o.Alpha = c.a;

			//	//o.Albedo = noisetexture.r > 0.6 ? c : noisetexture.r < 0.55 ? c2 : _DisLineColor;
			//	//o.Albedo = cross(c2, noisetexture);
			//}
			//else 
			//{				
			//	o.Albedo = c2.rgb;				
			//}

			//o.Alpha = c.a;
		}
		ENDCG 
	} 
	Fallback "Diffuse"
}
