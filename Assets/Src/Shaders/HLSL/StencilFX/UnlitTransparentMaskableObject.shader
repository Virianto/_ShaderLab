Shader "_ViriantoTem/HLSL/StencilFX/UnlitTransparentMaskableObject"
{
    Properties
    {
        [Header(Stencil reference)]

        _StencilRef("Stencil Reference", Int) = 0

        [Header(Regular material properties)]

        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
            "RenderType"="Transparent" 
            "RenderPipeline" = "UniversalRenderPipeline"
        }

        Blend SrcAlpha OneMinusSrcAlpha

        Stencil 
        {
            Ref[_StencilRef]
            Comp equal
            Pass keep
            Fail keep
        }

        Pass 
        {
            // The HLSL code block. Unity URP uses the HLSL language.
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "HLSLSupport.cginc"
            // The Core.hlsl file contains definitions of frequently used HLSL
            // macros and functions, and also contains #include references to other
            // HLSL files (for example, Common.hlsl, SpaceTransforms.hlsl, etc.).
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            // This macro declares _BaseMap as a Texture2D object.
            TEXTURE2D(_MainTex);

            // This macro declares the sampler for the _BaseMap texture.
            SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)

                // The following line declares the _BaseMap_ST variable, so that you
                // can use the _BaseMap variable in the fragment shader. The _ST 
                // suffix is necessary for the tiling and offset function to work.
                half4 _MainTex_ST;

            CBUFFER_END

            half4 _Color;

            struct appdata
            {
                half4 positionOS   : POSITION;
                fixed2 uv           : TEXCOORD0;
            };

            struct v2f
            {
                half4 positionHCS  : SV_POSITION;
                fixed2 uv           : TEXCOORD0;
            };

            v2f vert(appdata IN)
            {
                v2f OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                // The TRANSFORM_TEX macro performs the tiling and offset transformation.
                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                return OUT;
            }

            half4 frag(v2f IN) : SV_Target
            {
                // The SAMPLE_TEXTURE2D marco samples the texture with the given sampler.
                half4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv) * _Color;
                return color;
            }

            ENDHLSL
        }
    }
}
