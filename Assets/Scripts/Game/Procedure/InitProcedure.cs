using Koakuma.Game.ECS;
using Koakuma.Game.Items;
using Koakuma.Game.Scenes;
using System.Threading.Tasks;
using TGame.Procedure;

namespace Koakuma.Game.Procedure
{
    public class InitProcedure : BaseProcedure
    {
        public override async Task OnEnterProcedure(object value)
        {
            UnityLog.Info("enter init procedure");
            GameManager.ECS.World.AddComponent<KnapsackComponent>();
            GameManager.ECS.World.AddComponent<GameSceneComponent>();
            GameManager.ECS.World.AddNewComponent<PlayerComponent>();
            await GameManager.UI.OpenUIAsync(UI.UIViewID.LoginUI);
            GameManager.Audio.PlayBGM(1);
            await Task.Yield();
        }
    }
}
