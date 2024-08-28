using System;
using System.Collections.Generic;
using TGame.Asset;
using UnityEngine;
using UnityEngine.AddressableAssets;

public class GameObjectPool<T> where T : GameObjectPoolAsset
{
    private readonly Dictionary<int, Queue<T>> gameObjectPool = new Dictionary<int, Queue<T>>();
    private readonly List<GameObjectLoadRequest<T>> requests = new List<GameObjectLoadRequest<T>>();
    private readonly Dictionary<int, GameObject> usingObjects = new Dictionary<int, GameObject>();


    public T LoadGameObject(string path, Action<GameObject> createNewCallback = null)
    {
        int hash = path.GetHashCode();

        if (!gameObjectPool.TryGetValue(hash, out Queue<T> q))
        {
            q = new Queue<T>();
            gameObjectPool.Add(hash, q);
        }

        if (q.Count == 0)
        {
            GameObject prefab = Addressables.LoadAssetAsync<GameObject>(path).WaitForCompletion();
            GameObject go = UnityEngine.Object.Instantiate(prefab);
            T asset = go.AddComponent<T>();
            createNewCallback?.Invoke(go);
            asset.ID = hash;
            go.SetActive(false);
            q.Enqueue(asset);
        }
        {
            T asset = q.Dequeue();
            OnGameObjectLoaded(asset);
            return asset;
        }
    }
    public void LoadGameObjectAsync(string path, Action<T> callback, Action<GameObject> createNewCallback = null)
    {
        GameObjectLoadRequest<T> request = new GameObjectLoadRequest<T>(path, callback, createNewCallback);
        requests.Add(request);
    }

    private void OnGameObjectLoaded(T asset)
    {
        asset.transform.SetParent(TGameFramework.Instance.GetModule<AssetModule>().usingObjectRoot);
        int id = asset.gameObject.GetInstanceID();
        usingObjects.Add(id, asset.gameObject);
    }
}
