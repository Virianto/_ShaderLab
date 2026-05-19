Shader "Custom/HLSL/StencilFX/SimpleStencilMask"
{
    Properties 
    {
       _StencilRef("Stencil Ref", Int) = 1

       // More information here: https://docs.unity3d.com/ScriptReference/Rendering.CompareFunction.html
       [Enum(UnityEngine.Rendering.CompareFunction)]
       _StencilComp("Stencil Comp", Int) = 8

        // More information here: https://docs.unity3d.com/ScriptReference/Rendering.StencilOp.html
        [Enum(UnityEngine.Rendering.StencilOp)]
        _StencilOp("Stencil Op", Int) = 2
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
            Ref[_StencilRef]	// ID of this shader in Stencil buffer (several shaders can have the same for comparisons)
            Comp[_StencilComp]	// Look for other "Ref" with the same value as this one
            Pass[_StencilOp]	// Remove those fragments from that geometry

            // For usual stencil masking use these options:
            // Comp always
            // Pass replace
        }        
        
        Pass 
        {
            
        }
    }
}
