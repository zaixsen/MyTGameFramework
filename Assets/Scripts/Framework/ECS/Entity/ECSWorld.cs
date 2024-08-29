using UnityEngine;

namespace TGame.ECS
{

    public class ECSWorld : MonoBehaviour
    {
        public ECSScene GameScene { get; set; } = new ECSScene();
    }
}
