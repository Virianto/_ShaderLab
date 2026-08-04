using UnityEngine;

public class CParticlesShader : MonoBehaviour
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

        Vector4 x = currentParticlesInScene[5].position;
        Vector4 y = mainParticleSystem.transform.InverseTransformPoint(currentParticlesInScene[5].position);
        
        Debug.LogFormat("Partícula 1 local: {0} y global: {1}", x, y);
        
        RefreshShaderData();        
    }


    void GetAllShaderData()
    {
        float[] radius = stencilShaderMaterial.GetFloatArray("_ParticlesRadius");
        Vector4[] positions = stencilShaderMaterial.GetVectorArray("_ParticlesPositions");
    }
    void RefreshShaderData()
    {                 
        stencilShaderMaterial.SetVectorArray("_ParticlesPositions", particlePositions);
        stencilShaderMaterial.SetFloatArray("_ParticlesRadius", particleRadius);
        stencilShaderMaterial.SetFloat("_Radius", stencilRadius);                
    }

    #endregion
}