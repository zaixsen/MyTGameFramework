using TGame.Asset;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    
    public static AssetModule Assets { get => TGameFramework.Instace.GetModule<AssetModule>(); }



}
