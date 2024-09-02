using Koakuma.Game.Procedure;
using System;
using System.Threading.Tasks;
using TGame.UI;
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

            GameManager.Message.Subscribe<MessageType.EnterLobby>(OnHandleEnterLobby);
            GameManager.Message.Subscribe<MessageType.LoginResp>(OnHandleLoginResp);
        }

        private void OnTest()
        {
            GameManager.UI.OpenUI(UIViewID.TestUI);
        }

        protected override void OnHide()
        {
            GameManager.Message.Unsubscribe<MessageType.EnterLobby>(OnHandleEnterLobby);
            GameManager.Message.Unsubscribe<MessageType.LoginResp>(OnHandleLoginResp);

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
            //UnityLog.Info("<color=red>发送事件 Login </color>");
            GameManager.Message.Post(new MessageType.Login()).Coroutine();
        }

        private async Task OnHandleLoginResp(MessageType.LoginResp arg)
        {
            ////UnityLog.Info("<color=red>执行回调 OnHandleLoginResp </color>");
            GameManager.Procedure.ChangeProcedure<LobbyProcedure>().Coroutine();
            await Task.Yield();
        }

        private async Task OnHandleEnterLobby(MessageType.EnterLobby arg)
        {
            Close();
            await Task.Yield();
        }
    }
}
