namespace TGame.Event
{

	public partial class EventModule : BaseGameModule
    {
        internal interface ICommand
        {
            void Do();
        }
    }
}