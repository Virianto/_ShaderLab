using System;
using System.Collections.Generic;
using UnityEngine;

public class ParticleSystemToShader : MonoBehaviour
{
    #region ATTRIBUTES

    [SerializeField] Material myMaterial;
    
    ParticleSystem _myParticleSystem;
    ParticleSystem.Particle[] _particles;
    
    #endregion
    
    #region METHODS

    void Start()
    {
        _myParticleSystem = GetComponent<ParticleSystem>();
        _particles = new ParticleSystem.Particle[_myParticleSystem.main.maxParticles];
        
        myMaterial.SetFloat("_ParticlesCount", _particles.Length);
    }

    private void Update()
    {
        List<Vector4> newParticlesPositionList = new List<Vector4>();
        
        // Get the number of alive particles
        int aliveCount = _myParticleSystem.GetParticles(_particles);
        
        for (int i = 0; i < aliveCount; i++)
        {
            newParticlesPositionList.Add(new Vector4(_particles[i].position.x, _particles[i].position.y, _particles[i].position.z, 0));
        }
        
        //Vector3[] particlesPositions = new Vector3[_myParticleSystem.particleCount];
        //_myParticleSystem.GetParticles(particlesPositions);
        
        myMaterial.SetVectorArray("_ParticlesPositions", newParticlesPositionList.ToArray());
        
    }

    #endregion
}
