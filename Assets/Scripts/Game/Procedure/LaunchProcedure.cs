using Config;
using Koakuma.Game;
using System.Threading.Tasks;
using TGame.Procedure;
using TGame.UI;

public class LaunchProcedure : BaseProcedure
{
    public override async Task OnEnterProcedure(object value)
    {
        UnityLog.Info("��ʼ������");
        await LoadConfigs();
        await GameManager.UI.OpenUIAsync(UIViewID.LoginUI);

    }

    private async Task LoadConfigs()
    {
        UnityLog.Info("===>��������");
        ConfigManager.LoadAllConfigsByAddressable("Assets/BundleAssets/Config");
        //#if UNITY_EDITOR
        //            string path = "Assets/BundleAssets/Config";
        //            ConfigManager.LoadAllConfigsByFile(path);
        //            await Task.Yield();
        //#else
        //            string path = $"{UnityEngine.Application.streamingAssetsPath}/AssetBundles";
        //            string subFolder = $"Datas/Config";
        //            await ConfigManager.LoadAllConfigsByBundle(path, subFolder);
        //#endif
        GlobalConfig.InitGlobalConfig();
        BuffConfig.ParseConfig();
        SkillConfig.ParseConfig();
        BulletConfig.ParseConfig();
        SpellFieldConfig.ParseConfig();
        I18NConfig.ParseConfig();

        await Task.Yield();
        UnityLog.Info("<===���ü������");
    }
}
