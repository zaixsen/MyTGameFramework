using System;

namespace TGame.Event
{
  
	public partial class EventModule : BaseGameModule
    {
        internal class UnsubscribeCommand : ICommand
        {
            private Type messageType;
            private EventHandler handler;

            public UnsubscribeCommand(Type messageType, EventHandler handler)
            {
                this.messageType = messageType;
                this.handler = handler;
            }

            void ICommand.Do()
            {
                if (handler == null)
                    return;

                if (!TGameFramework.Initialized)
                    return;

                TGameFramework.Instance.GetModule<EventModule>().FindHandlerList(messageType).Remove(handler);
            }
        }
    }
}