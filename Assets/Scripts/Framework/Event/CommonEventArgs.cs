namespace TGame.Event
{
  
    public class CommonEventArgs<T> : BaseEventType
    {
        public T Data { get; private set; }

        public CommonEventArgs(T data)
        {
            Data = data;
        }
    }
}