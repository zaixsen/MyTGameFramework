using Config;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TGame.UI
{
    /// <summary>
    /// 具体泛型UI中介者
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class UIMediator<T> : UIMediator where T : UIView
    {
        protected T view;

        protected override void OnShow(object arg)
        {
            base.OnShow(arg);
            view = ViewObject.GetComponent<T>();
        }
        protected override void OnHide()
        {
            view = default;
            base.OnHide();
        }

        protected void Close()
        {
            TGameFramework.Instance.GetModule<UIModule>().CloseUI(this);
        }

        public override void InitMediator(UIView view)
        {
            base.InitMediator(view);
            OnInit(view as T);
        }

        protected virtual void OnInit(T view) { }
    }
    /// <summary>
    /// 抽象基类 主要提出了Mediator的公共属性 行为 
    /// </summary>
    public abstract class UIMediator
    {
        public event System.Action OnMediatorHide;
        public GameObject ViewObject { get; set; }
        public int SortingOrder { get; set; }
        public UIMode UIMode { get; set; }

        public virtual void InitMediator(UIView view) { }

        public void Show(GameObject viewObject, object arg)
        {
            ViewObject = viewObject;
            OnShow(arg);
        }

        protected virtual void OnShow(object arg) { }

        public void Hide()
        {
            OnHide();
            OnMediatorHide?.Invoke();
            OnMediatorHide = null;
            ViewObject = default;
        }

        protected virtual void OnHide() { }

        public void Update(float deltaTime)
        {
            OnUpdate(deltaTime);
        }

        protected virtual void OnUpdate(float deltaTime) { }
    }
}