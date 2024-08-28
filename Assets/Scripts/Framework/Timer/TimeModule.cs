using TGame;
using UnityEngine;

namespace Koakuma.Game.Times
{
    public class TimeModule : BaseGameModule
    {
        public float timeScale;
        public AnimationCurve weakCurve;
        public AnimationCurve midCurve;
        public AnimationCurve strongCurve;

        private float freezeTime;
        private FreezeType freezeType;

        public enum FreezeType
        {
            None = 0,
            Weak = 1,
            Mid = 2,
            Strong = 3,
            RebornFreeze,
        }

        protected internal override void OnModuleUpdate(float deltaTime)
        {
            base.OnModuleUpdate(deltaTime);
            UpdateTimeFreeze();

            timeScale = Time.timeScale;
        }

        public void PauseTime()
        {
            Time.timeScale = 0;
        }

        public void ResumeTime()
        {
            Time.timeScale = 1;
        }

        public void StartFreeze(FreezeType type)
        {
            if (type == FreezeType.None)
                return;

            freezeType = type;
            freezeTime = 0;
        }

        private AnimationCurve GetCurve()
        {
            switch (freezeType)
            {
                case FreezeType.Weak:
                    return weakCurve;
                case FreezeType.Mid:
                    return midCurve;
                case FreezeType.Strong:
                    return strongCurve;
                default:
                    return null;
            }
        }

        private void UpdateTimeFreeze()
        {
            if (freezeType != FreezeType.None)
            {
                AnimationCurve curve = GetCurve();
                Keyframe lastFrame = curve.keys[curve.length - 1];
                if (freezeTime >= lastFrame.time)
                {
                    freezeType = FreezeType.None;
                    Time.timeScale = 1;
                    return;
                }

                Time.timeScale = curve.Evaluate(freezeTime);
                freezeTime += Time.unscaledDeltaTime;
            }
        }
    }
}
