namespace TGame.Fsm
{
    /// <summary>
    /// 状态转换
    /// </summary>
    /// <typeparam name="T"></typeparam>
    internal class Transition<T> where T : FiniteStateMachine<T>
    {
        /// <summary>
        /// 目标状态
        /// </summary>
        public FiniteState<T> TargetState { get; private set; }
        /// <summary>
        /// 参数
        /// </summary>
        public object[] Arguments { get; private set; }

        public Transition(FiniteState<T> targetState, object[] args)
        {
            TargetState = targetState;
            Arguments = args;
        }
    }
}