using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TGameFramework
{
    public static TGameFramework Instace { get; private set; }

    public static bool Initialized { get; private set; }
    /// <summary>
    /// ���е�module
    /// </summary>
    private Dictionary<Type, BaseGameModule> _modules = new Dictionary<Type, BaseGameModule>();

    public static void Initialize()
    {
        Instace = new TGameFramework();
    }

    //��ȡmodule
    public T GetModule<T>() where T : BaseGameModule
    {
        if (_modules.TryGetValue(typeof(T), out BaseGameModule module))
        {
            return module as T;
        }
        return default(T);
    }

    //���module
    public void AddModule(BaseGameModule module)
    {
        Type moduleType = module.GetType();

        if (_modules.ContainsKey(moduleType))
        {
            UnityLog.Info($"�ظ����ģ��{moduleType.Name}");
            return;
        }
        _modules.Add(moduleType, module);
    }


    //ִ���������ں���
    public void InitModules()
    {
        //�����ٴγ�ʼ��
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
