Shader "Custom/HLSL/WorldPosDissolve"
{
    Properties
    {
        [Header(GENERAL)]

        [Toggle]
        _ShouldAppear("Should appear?", Float) = 0

        [Toggle(ALPHA)]
        _ALPHA("No Shadows on Transparent", Float) = 0

        [Header(PRIMARY)]

        _Color("Primary Color", Color) = (1,1,1,1)
        _MainTex("Primary (RGB)", 2D) = "white" {}

        [Header(DISSOLVE)]

        _Position("Dissolve center", Vector) = (0,0,0,0)
        _ParticlesCount("Particles count", Float) = 1
        //_PositionsArray("Positions array", float3Array) = {}

        _NoiseTex("Dissolve Noise", 2D) = "white"{}
        _NScale("Noise Scale", Range(0, 10)) = 1
        _DisAmount("Noise Texture Opacity", Range(0.01, 1)) = 0.01
        _Radius("Radius", Range(0, 10)) = 0
        _DisLineWidth("Line Width", Range(0, 2)) = 0
        _DisLineColor("Line Tint", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalRenderPipeline"
        }

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                half4 vertex : POSITION;                
                half2 uv : TEXCOORD0;
                half3 normal : NORMAL;
            };

            struct v2f
            {
                half2 uv : TEXCOORD0;                
                half4 vertex : SV_POSITION;
                half3 worldPos : TEXCOORD1; // Sirve para obtener la posición en el mundo
            };


            half3 _Position;
            half _ParticlesCount;
            half _ParticlesRadius[100];
            half3 _ParticlesPositions[100];

            fixed _ShouldAppear;

            sampler2D _MainTex;
            half4 _Color;
            sampler2D _NoiseTex;
            half _DisAmount, _NScale;
            half _DisLineWidth;
            half4 _DisLineColor;
            half _Radius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;
               
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.uv) * _Color;
                float dis;

                c.a = 0;

                for (int p = 0; p < _ParticlesCount; ++p) 
                {
                    dis = distance(i.worldPos, _ParticlesPositions[p]);

                    if (dis < _ParticlesRadius[p])
                    {
                        c.a = 1;
                        break;
                    }
                }                

                //// triplanar noise
                //float3 blendNormal = saturate(pow(IN.worldNormal * 1.4,4));
                //half4 nSide1 = tex2D(_NoiseTex, (IN.worldPos.xy + _Time.x) * _NScale);
                //half4 nSide2 = tex2D(_NoiseTex, (IN.worldPos.xz + _Time.x) * _NScale);
                //half4 nTop = tex2D(_NoiseTex, (IN.worldPos.yz + _Time.x) * _NScale);

                //float3 noisetexture = nSide1;
                //noisetexture = lerp(noisetexture, nTop, blendNormal.x);
                //noisetexture = lerp(noisetexture, nSide2, blendNormal.y);

                //// distance influencer position to world position
                //float3 dis = distance(_Position, IN.worldPos);
                //float3 sphere = 1 - saturate(dis / _Radius);

                //float3 sphereNoise = noisetexture.r * sphere;

                //// Line between two textures
                //float3 DissolveLine = step(sphereNoise - _DisLineWidth, _DisAmount) * step(_DisAmount,sphereNoise);

                //// Color the line
                //DissolveLine *= _DisLineColor;

                //float3 primaryTex = (step(sphereNoise - _DisLineWidth,_DisAmount) * c.rgb);
                //float3 resultTex = primaryTex + DissolveLine;

                //o.Emission = DissolveLine;

                //c.a = 1 - step(_DisAmount, sphereNoise);

                //o.Albedo = resultTex;

                //o.Alpha = c.a;

                //clip(c.a == 0 ? 1 : -1);

                return c;
            }
            ENDHLSL
        }
    }
}
