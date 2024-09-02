using Config;
using FMOD;
using FMOD.Studio;
using FMODUnity;
using TGame;
using UnityEngine;

namespace Koakuma.Game.Audio
{
    public class AudioModule : BaseGameModule
    {
        private EventInstance? bgmInstance;

        public void PlayBGM(int id)
        {
            EventInstance? instance = PlaySFX(id, null);
            if (!instance.HasValue)
            {
                UnityLog.Error($"PlayBGMÊ§°Ü, id:{id}");
                return;
            }

            StopBGM();
            bgmInstance = instance;
        }

        public void StopBGM()
        {
            if (!bgmInstance.HasValue)
                return;

            bgmInstance.Value.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
            bgmInstance = null;
        }

        public EventInstance? PlaySFX(int audio, Rigidbody rigidbody)
        {
            if (audio <= 0)
                return null;

            AudioConfig audioConfig = AudioConfig.ByID(audio);
            return PlaySFX(audioConfig.Asset, rigidbody);
        }

        public EventInstance? PlaySFX(string eventName, Rigidbody rigidbody)
        {
            if (string.IsNullOrEmpty(eventName))
                return null;

            EventInstance eventInstance = RuntimeManager.CreateInstance(eventName);
            if (rigidbody != null)
            {
                eventInstance.set3DAttributes(RuntimeUtils.To3DAttributes(gameObject, rigidbody));
                RuntimeManager.AttachInstanceToGameObject(eventInstance, rigidbody.transform, rigidbody);
            }
            RESULT result = eventInstance.start();
            return result == RESULT.OK ? eventInstance : default;
        }
    }
}
