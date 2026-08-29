using UnityEngine;

public class MouseToShader : MonoBehaviour
{
    #region ATTRIBUTES
    
    [SerializeField] Material material;

    #endregion

    #region METHODS

    void Update()
    {
        Vector2 mousePos = Input.mousePosition;

        // Normalized (0-1)
        Vector2 mouseUV = new Vector2(
            mousePos.x / Screen.width,
            mousePos.y / Screen.height
        );

        material.SetVector("_CursorPos", mouseUV);
    }

    #endregion
}
