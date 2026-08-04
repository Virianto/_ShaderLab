using UnityEngine;

/// <summary>
/// Make sure the Particle System is in "World" Simulated Space. Otherwise the position of
/// each particle won't be correct unless the system is placed in (0,0,0)
/// </summary>
public class M_PSystemToShader : MonoBehaviour
{
    #region ATTRIBUTES

    [Header("External references")]

    [SerializeField] ParticleSystem mainParticleSystem;
    [SerializeField] Material stencilShaderMaterial;

    [Header("Editable values")]

    [SerializeField] [Range(0.1f, 6)] float stencilRadius = 1;

    ParticleSystem.Particle[] currentParticlesInScene;
    Vector4[] particlePositions;
    float[] particleRadius;

    int maxParticlesCount;

    #endregion

    #region METHODS

    void Awake()
    {
        maxParticlesCount = mainParticleSystem.main.maxParticles;
        currentParticlesInScene = new ParticleSystem.Particle[maxParticlesCount];                       
    }

    void Start()
    {
        particlePositions = new Vector4[maxParticlesCount];
        particleRadius = new float[maxParticlesCount];
        stencilShaderMaterial.SetFloat("_ParticlesCount", maxParticlesCount);
    }

    void LateUpdate()
    {
        mainParticleSystem.GetParticles(currentParticlesInScene);
        
        for (int p = 0; p < maxParticlesCount; ++p)
        {
            particlePositions[p] = currentParticlesInScene[p].position;
            particleRadius[p] = currentParticlesInScene[p].GetCurrentSize(mainParticleSystem);
        }
        
        RefreshShaderData();        
    }
    
    void RefreshShaderData()
    {                 
        stencilShaderMaterial.SetVectorArray("_ParticlesPositions", particlePositions);
        stencilShaderMaterial.SetFloatArray("_ParticlesRadius", particleRadius);
        stencilShaderMaterial.SetFloat("_Radius", stencilRadius);                
    }

    #endregion
}