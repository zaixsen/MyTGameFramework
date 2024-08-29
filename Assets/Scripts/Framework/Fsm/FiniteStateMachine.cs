using System;
using System.Collections.Generic;
using UnityEngine;

namespace TGame.Fsm
{
    /// <summary>
    /// 状态机
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class FiniteStateMachine<T> where T : FiniteStateMachine<T>
    {
        public FiniteState<T> CurrentState { get; private set; }
        public bool IsRunning { get; private set; }

        private List<FiniteState<T>> states;
        private FiniteState<T> defaultState;
        private Stack<FiniteState<T>> stateStack;

        public FiniteStateMachine()
        {
            states = new List<FiniteState<T>>();
            stateStack = new Stack<FiniteState<T>>();
            transitions = new Queue<Transition<T>>();
        }

        /// <summary>
        /// 添加状态
        /// </summary>
        /// <param name="state">状态</param>
        /// <param name="isDefault">是否为默认状态</param>
        public void AddState(FiniteState<T> state, bool isDefault = false)
        {
            if (state == null)
            {
                throw new Exception("不能添加空状态");
            }
            if (GetType() != typeof(T))
            {
                throw new Exception("状态机类型不匹配,无法添加状态");
            }
            state.Fsm = this as T;
            states.Add(state);
            if (isDefault)
            {
                defaultState = state;
            }
        }

        /// <summary>
        /// 启动状态机
        /// </summary>
        public void StartFsm(object[] args = null)
        {
            if (IsRunning)
                return;

            if (defaultState == null)
            {
                throw new Exception("状态机没有设置默认状态");
            }

            IsRunning = true;
            ChangeState(defaultState, args);
        }

        /// <summary>
        /// 关闭状态机
        /// </summary>
        public void StopFsm()
        {
            if (!IsRunning)
                return;

            IsRunning = false;
            while (stateStack.Count > 0)
            {
                stateStack.Pop().Leave();
            }
            OnStop();
        }
        protected virtual void OnStop() { }


        /// <summary>
        /// 更新状态机
        /// </summary>
        public void UpdateFsm(float deltaTime)
        {
            if (!IsRunning)
                return;

            CurrentState?.Update(deltaTime);
        }

        /// <summary>
        /// 发送消息
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="args"></param>
        public void SendMessageToCurrentState(string msg, params object[] args)
        {
            CurrentState?.HandleMessage(msg, args);
        }

        /// <summary>
        /// 切换状态
        /// </summary>
        /// <typeparam name="TState"></typeparam>
        public void ChangeState<TState>(params object[] args) where TState : FiniteState<T>
        {
            for (int i = 0; i < states.Count; i++)
            {
                if (states[i].GetType() == typeof(TState))
                {
                    ChangeState(states[i], args);
                    return;
                }
            }
            Debug.LogError($"ChangeState失败,找不到状态:`{typeof(TState).FullName}`");
        }

        private bool isChangingState;
        private Queue<Transition<T>> transitions;

        /// <summary>
        /// 转换状态
        /// </summary>
        /// <param name="newState"></param>
        private void ChangeState(FiniteState<T> newState, object[] args)
        {
            if (newState == null)
                return;

            transitions.Enqueue(new Transition<T>(newState, args));    //加入转换队列

            if (isChangingState)
                return;

            int transiteCount = 0;
            isChangingState = true;
            while (transitions.Count > 0)
            {
                if (CurrentState != null)
                {
                    CurrentState.Leave();
                }
                Transition<T> transition = transitions.Dequeue();
                CurrentState = transition.TargetState;
                stateStack.Push(CurrentState);
                CurrentState.Enter(transition.Arguments);

                //为了防止无限跳转,例如A->B,B->A
                transiteCount++;
                if (transiteCount >= 100)
                    throw new StackOverflowException("状态跳转出现死循环");
            }
            isChangingState = false;
        }
    }
}