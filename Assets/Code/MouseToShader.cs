using UnityEngine;

public class MouseToShader : MonoBehaviour
{
    #region ATTRIBUTES
    
    [SerializeField] private Material material;
    [SerializeField] private float radius = 0.1f;

    #endregion

    #region METHODS

    void Update()
    {
        Vector2 mousePos = Input.mousePosition;

        // Normalizado (0-1)
        Vector2 mouseUV = new Vector2(
            mousePos.x / Screen.width,
            mousePos.y / Screen.height
        );

        material.SetVector("_CursorPos", mouseUV);
        material.SetFloat("_Radius", radius);
    }

    #endregion
}
