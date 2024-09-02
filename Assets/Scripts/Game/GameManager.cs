using Koakuma.Game.Audio;
using Koakuma.Game.Times;
using System;
using System.Collections.Generic;
using System.Reflection;
using TGame;
using TGame.Asset;
using TGame.ECS;
using TGame.Message;
using TGame.Procedure;
using TGame.Save;
using TGame.Schedule;
using TGame.UI;
using UnityEngine;

namespace Koakuma.Game
{
    public class GameManager : MonoBehaviour
    {
        [Module(1)]
        public static AssetModule Asset { get => TGameFramework.Instance.GetModule<AssetModule>(); }
        [Module(2)]
        public static ProcedureModule Procedure { get => TGameFramework.Instance.GetModule<ProcedureModule>(); }
        [Module(3)]
        public static UIModule UI { get => TGameFramework.Instance.GetModule<UIModule>(); }
        [Module(4)]
        public static TimeModule Time { get => TGameFramework.Instance.GetModule<TimeModule>(); }
        [Module(5)]
        public static AudioModule Audio { get => TGameFramework.Instance.GetModule<AudioModule>(); }
        [Module(6)]
        public static MessageModule Message { get => TGameFramework.Instance.GetModule<MessageModule>(); }
        [Module(7)]
        public static ECSModule ECS { get => TGameFramework.Instance.GetModule<ECSModule>(); }
        [Module(98)]
        public static SaveModule Save { get => TGameFramework.Instance.GetModule<SaveModule>(); }
        [Module(99)]
        public static ScheduleModule Schedule { get => TGameFramework.Instance.GetModule<ScheduleModule>(); }

        private bool activing;

        private void Awake()
        {
            if (TGameFramework.Instance != null)
            {
                Destroy(gameObject);
                return;
            }

            activing = true;
            DontDestroyOnLoad(gameObject);
#if UNITY_EDITOR
            UnityLog.StartupEditor();
#else
            UnityLog.Startup();
#endif

            Application.logMessageReceived += OnReceiveLog;
            TGameFramework.Initialize();
            StartupModules();
            TGameFramework.Instance.InitModules();
        }

        private void Start()
        {
            TGameFramework.Instance.StartModules();
            Procedure.StartProcedure().Coroutine();
        }

        private void Update()
        {
            TGameFramework.Instance.Update();
        }

        private void LateUpdate()
        {
            TGameFramework.Instance.LateUpdate();
        }

        private void FixedUpdate()
        {
            TGameFramework.Instance.FixedUpdate();
        }

        private void OnDestroy()
        {
            if (activing)
            {
                Application.logMessageReceived -= OnReceiveLog;
                TGameFramework.Instance.Destroy();
            }
        }

        private void OnApplicationQuit()
        {
            //UnityLog.Teardown();
        }

        /// <summary>
        /// ��ʼ��ģ��
        /// </summary>
        public void StartupModules()
        {
            List<ModuleAttribute> moduleAttrs = new List<ModuleAttribute>();
            PropertyInfo[] propertyInfos = GetType().GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
            Type baseCompType = typeof(BaseGameModule);
            for (int i = 0; i < propertyInfos.Length; i++)
            {
                PropertyInfo property = propertyInfos[i];
                if (!baseCompType.IsAssignableFrom(property.PropertyType))
                    continue;

                object[] attrs = property.GetCustomAttributes(typeof(ModuleAttribute), false);
                if (attrs.Length == 0)
                    continue;

                Component comp = GetComponentInChildren(property.PropertyType);
                if (comp == null)
                {
                    Debug.LogError($"Can't Find GameModule:{property.PropertyType}");
                    continue;
                }

                ModuleAttribute moduleAttr = attrs[0] as ModuleAttribute;
                moduleAttr.Module = comp as BaseGameModule;
                moduleAttrs.Add(moduleAttr);
            }

            moduleAttrs.Sort();
            for (int i = 0; i < moduleAttrs.Count; i++)
            {
                TGameFramework.Instance.AddModule(moduleAttrs[i].Module);
            }
        }

        [AttributeUsage(AttributeTargets.Property, Inherited = false, AllowMultiple = false)]
        public sealed class ModuleAttribute : Attribute, IComparable<ModuleAttribute>
        {
            /// <summary>
            /// ���ȼ�
            /// </summary>
            public int Priority { get; private set; }
            /// <summary>
            /// ģ��
            /// </summary>
            public BaseGameModule Module { get; set; }

            /// <summary>
            /// ��Ӹ����ԲŻᱻ����ģ��
            /// </summary>
            /// <param name="priority">���������ȼ�,��ֵԽСԽ��ִ��</param>
            public ModuleAttribute(int priority)
            {
                Priority = priority;
            }

            int IComparable<ModuleAttribute>.CompareTo(ModuleAttribute other)
            {
                return Priority.CompareTo(other.Priority);
            }
        }

        private void OnReceiveLog(string condition, string stackTrace, LogType type)
        {
#if !UNITY_EDITOR
            if (type == LogType.Exception)
            {
                UnityLog.Fatal($"{condition}\n{stackTrace}");
            }
#endif
        }
    }
}
