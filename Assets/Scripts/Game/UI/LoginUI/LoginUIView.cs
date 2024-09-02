using TGame.UI;
using UnityEngine.UI;
using UnityEngine.Video;

namespace Koakuma.Game.UI
{
    [UIView(typeof(LoginUIMediator), UIViewID.LoginUI)]
    public class LoginUIView : UIView
    {
        public Button btnLogin;
        public Button btnTest;
        public VideoPlayer videoPlayer;
        public RawImage rawImage;
    }
}
