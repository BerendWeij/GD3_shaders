using UnityEngine;

[ExecuteInEditMode]
public class ViewportDisplacement : MonoBehaviour
{
    public Material EffectMaterial;

    // standaard method van Unity, zoals Update en Start
    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (EffectMaterial == null)
        {
            return;
        }
        
        // unity wil eigenlijk een bepaald beeld laten zien (src) maar we geven
        // dit beeld eerst door aan onze material die er weer wat mee kan uitspoken
        Graphics.Blit(src, dst, EffectMaterial);
    }
}