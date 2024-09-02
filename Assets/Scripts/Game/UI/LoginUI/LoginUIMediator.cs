
using System;
using System.Threading.Tasks;
using TGame.UI;
using UnityEditor;
using UnityEngine;

namespace Koakuma.Game.UI
{
    public class LoginUIMediator : UIMediator<LoginUIView>
    {
        protected override void OnInit(LoginUIView view)
        {
            base.OnInit(view);
        }

        protected override void OnShow(object arg)
        {
            base.OnShow(arg);
            RenderTexture renderTexture = RenderTexture.GetTemporary(new RenderTextureDescriptor(Screen.width, Screen.height, RenderTextureFormat.ARGB32));
            view.videoPlayer.targetTexture = renderTexture;
            view.rawImage.texture = renderTexture;
            view.btnLogin.onClick.AddListener(OnLogin);
        }

        protected override void OnHide()
        {
            if (view.videoPlayer.targetTexture != null)
            {
                view.videoPlayer.targetTexture.Release();
                view.videoPlayer.targetTexture = null;
            }
            view.btnLogin.onClick.RemoveListener(OnLogin);
            base.OnHide();
        }

        private void OnLogin()
        {
            //GameManager.Message.Post(new MessageType.Login()).Coroutine();
        }

    }
}
