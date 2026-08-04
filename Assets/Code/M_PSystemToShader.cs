using System.Collections.Generic;
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

    [SerializeField] List<Material> stencilShaderMaterialList = new();

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

        foreach (Material m in stencilShaderMaterialList)
        {
            m.SetFloat("_ParticlesCount", maxParticlesCount);
        }
        
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
        foreach (Material m in stencilShaderMaterialList)
        {
            m.SetVectorArray("_ParticlesPositions", particlePositions);
            m.SetFloatArray("_ParticlesRadius", particleRadius);
            m.SetFloat("_Radius", stencilRadius);   
        }
    }

    #endregion
}