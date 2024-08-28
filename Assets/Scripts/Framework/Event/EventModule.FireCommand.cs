using System;
using System.Collections.Generic;

namespace TGame.Event
{
	public partial class EventModule : BaseGameModule
    {
        internal class FireCommand : ICommand
        {
            private Type messageType;
            private BaseEventType arg;

            public FireCommand(Type messageType, BaseEventType arg)
            {
                this.messageType = messageType;
                this.arg = arg;
            }

            void ICommand.Do()
            {
                List<EventHandler> handlers = ListPool<EventHandler>.Obtain();
                handlers.AddRangeNonAlloc(TGameFramework.Instance.GetModule<EventModule>().FindHandlerList(messageType));
                foreach (var handler in handlers)
                {
                    handler?.Invoke(arg);
                }
                ListPool<EventHandler>.Release(handlers);
            }
        }
    }
}