using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TGame.Asset
{
    public partial class AssetModule : BaseGameModule
    {
        public readonly GameObjectPool<GameObjectAsset> gameObjectPool = new GameObjectPool<GameObjectAsset>();




    }
}
