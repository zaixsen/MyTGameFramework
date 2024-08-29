using System.Collections.Generic;

namespace TGame.Fsm
{
    public abstract class FiniteState<T> where T : FiniteStateMachine<T>
    {
        public delegate void HandleMessageCallback(string msg, object[] args);

        private Dictionary<string, HandleMessageCallback> messageHandlers;

        /// <summary>
        /// 状态机
        /// </summary>
        public T Fsm { get; internal set; }

        /// <summary>
        /// 进入状态
        /// </summary>
        public void Enter(object[] args)
        {
            OnEnter(args);
        }

        /// <summary>
        /// 离开状态
        /// </summary>
        public void Leave()
        {
            OnLeave();
        }

        /// <summary>
        /// 更新状态
        /// </summary>
        public void Update(float deltaTime)
        {
            OnUpdate(deltaTime);
        }

        /// <summary>
        /// 注册消息
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="callback"></param>
        protected void RegisterMessage(string msg, HandleMessageCallback callback)
        {
            if (messageHandlers == null)
            {
                messageHandlers = new Dictionary<string, HandleMessageCallback>();
            }

            if (callback == null)
                return;

            if (messageHandlers.ContainsKey(msg))
            {
                messageHandlers[msg] += callback;
            }
            else
            {
                messageHandlers.Add(msg, callback);
            }
        }

        /// <summary>
        /// 注销消息
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="callback"></param>
        protected void UnregisterMessage(string msg, HandleMessageCallback callback)
        {
            if (messageHandlers == null)
                return;

            if (callback == null)
                return;

            if (messageHandlers.ContainsKey(msg))
            {
                messageHandlers[msg] -= callback;
                if (messageHandlers[msg] == null)
                {
                    messageHandlers.Remove(msg);
                }
            }
        }

        /// <summary>
        /// 处理消息
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="args"></param>
        internal void HandleMessage(string msg, object[] args)
        {
            if (messageHandlers == null)
                return;

            HandleMessageCallback callback;
            messageHandlers.TryGetValue(msg, out callback);
            callback?.Invoke(msg, args);
        }

        protected virtual void OnEnter(object[] args) { }
        protected virtual void OnLeave() { }
        protected virtual void OnUpdate(float deltaTime) { }
    }
}