Shader "Custom/HLSL/ParticleHDR"
{
    Properties
    {
        [Header(PRIMARY)]

        [HDR]
        _Color("Primary Color", Color) = (1,1,1,1)        
        _MainTex("Primary (RGB)", 2D) = "white" {}

        [Header(TRANSPARENCY)]

        _AlphaThreshold("Transparency", Range(0,1)) = 0.5

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlendMode("Src Blend mode", Float) = 3

        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlendMode("Dst Blend mode", Float) = 3
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalRenderPipeline"
        }

        ZWrite Off
        Blend [_SrcBlendMode][_DstBlendMode]

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            half4 _Color;
            fixed _AlphaThreshold;
            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {                
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                clip(col.a >= _AlphaThreshold ? 1 : -1);
                return col;
            }

            ENDHLSL
        }
    }
}
