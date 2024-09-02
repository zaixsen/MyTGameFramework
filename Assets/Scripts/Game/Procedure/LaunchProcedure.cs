using Config;
using Koakuma.Game;
using System.Threading.Tasks;
using TGame.Procedure;
using TGame.UI;

public class LaunchProcedure : BaseProcedure
{
    public override async Task OnEnterProcedure(object value)
    {
        UnityLog.Info("初始化界面");
        await LoadConfigs();
        await GameManager.UI.OpenUIAsync(UIViewID.LoginUI);

    }

    private async Task LoadConfigs()
    {
        UnityLog.Info("===>加载配置");
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
        UnityLog.Info("<===配置加载完毕");
    }
}
