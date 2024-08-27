using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TGameFramework
{
    public static TGameFramework Instace { get; private set; }

    public static bool Initialized { get; private set; }
    /// <summary>
    /// 所有的module
    /// </summary>
    private Dictionary<Type, BaseGameModule> _modules = new Dictionary<Type, BaseGameModule>();

    public static void Initialize()
    {
        Instace = new TGameFramework();
    }

    //获取module
    public T GetModule<T>() where T : BaseGameModule
    {
        if (_modules.TryGetValue(typeof(T), out BaseGameModule module))
        {
            return module as T;
        }
        return default(T);
    }

    //添加module
    public void AddModule(BaseGameModule module)
    {
        Type moduleType = module.GetType();

        if (_modules.ContainsKey(moduleType))
        {
            UnityLog.Info($"重复添加模组{moduleType.Name}");
            return;
        }
        _modules.Add(moduleType, module);
    }


    //执行声明周期函数
    public void InitModules()
    {
        //避免再次初始化
        if (!Initialized)
            return;

        Initialized = true;

        foreach (var module in _modules.Values)
        {
            module.OnModuleInit();
        }
    }

    public void StartModules()
    {
        if (_modules == null)
            return;

        if (!Initialized)
            return;

        foreach (var module in _modules.Values)
        {
            module.OnModuleStart();
        }
    }
    public void Update()
    {

    }
    public void LateUpdate()
    {

    }
    public void FixedUpdate()
    {

    }
    public void Destroy()
    {

    }

}
