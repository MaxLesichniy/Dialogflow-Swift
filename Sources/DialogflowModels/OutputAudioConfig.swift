//
//  OutputAudioConfig.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 27.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation

//#if !WEBHOOK_MODELS

public struct OutputAudioConfig: Codable {
    /// Required. Audio encoding of the synthesized audio content.
    public var audioEncoding: OutputAudioEncoding
    
    /// The synthesis sample rate (in hertz) for this audio. If not provided, then the synthesizer will use the default sample rate based on the audio encoding. If this is different from the voice's natural sample rate, then the synthesizer will honor this request by converting to the desired sample rate (which might result in worse audio quality).
    public var sampleRateHertz: Int
    
    /// Configuration of how speech should be synthesized.
    public var synthesizeSpeechConfig: SynthesizeSpeechConfig?

    public init(audioEncoding: OutputAudioEncoding, sampleRateHertz: Int, synthesizeSpeechConfig: SynthesizeSpeechConfig?) {
        self.audioEncoding = audioEncoding
        self.sampleRateHertz = sampleRateHertz
        self.synthesizeSpeechConfig = synthesizeSpeechConfig
    }
}

public extension OutputAudioConfig {
    
    /// Audio encoding of the output audio format in Text-To-Speech.
    enum OutputAudioEncoding: String, Codable {
        /// Not specified.
        case unspecified = "OUTPUT_AUDIO_ENCODING_UNSPECIFIED"
        /// Uncompressed 16-bit signed little-endian samples (Linear PCM). Audio content returned as LINEAR16 also contains a WAV header.
        case linear16 = "OUTPUT_AUDIO_ENCODING_LINEAR_16"
        /// MP3 audio at 32kbps.
        case mp3 = "OUTPUT_AUDIO_ENCODING_MP3"
        /// Opus encoded audio wrapped in an ogg container. The result will be a file which can be played natively on Android, and in browsers (at least Chrome and Firefox). The quality of the encoding is considerably higher than MP3 while using approximately the same bitrate.
        case oggOpus = "OUTPUT_AUDIO_ENCODING_OGG_OPUS"
    }
    
    struct SynthesizeSpeechConfig: Codable {
        /// Optional. Speaking rate/speed, in the range [0.25, 4.0]. 1.0 is the normal native speed supported by the specific voice. 2.0 is twice as fast, and 0.5 is half as fast. If unset(0.0), defaults to the native 1.0 speed. Any other values < 0.25 or > 4.0 will return an error.
        public var speakingRate: Double?
        
        /// Optional. Speaking pitch, in the range [-20.0, 20.0]. 20 means increase 20 semitones from the original pitch. -20 means decrease 20 semitones from the original pitch.
        public var pitch: Double?
        
        /// Optional. Volume gain (in dB) of the normal native volume supported by the specific voice, in the range [-96.0, 16.0]. If unset, or set to a value of 0.0 (dB), will play at normal native signal amplitude. A value of -6.0 (dB) will play at approximately half the amplitude of the normal native signal amplitude. A value of +6.0 (dB) will play at approximately twice the amplitude of the normal native signal amplitude. We strongly recommend not to exceed +10 (dB) as there's usually no effective increase in loudness for any value greater than that.
        public var volumeGainDb: Double?


        /// Optional. An identifier which selects 'audio effects' profiles that are applied on (post synthesized) text to speech. Effects are applied on top of each other in the order they are given.
        public var effectsProfileId: [String]?

        /// Optional. The desired voice of the synthesized audio.
        public var voice: VoiceSelectionParams?

        public init(speakingRate: Double?, pitch: Double?, volumeGainDb: Double?, effectsProfileId: [String]?, voice: VoiceSelectionParams?) {
            self.speakingRate = speakingRate
            self.pitch = pitch
            self.volumeGainDb = volumeGainDb
            self.effectsProfileId = effectsProfileId
            self.voice = voice
        }
    }
    
}

public extension OutputAudioConfig.SynthesizeSpeechConfig {
    
    /// gender of the voice as described in SSML voice element.
    struct VoiceSelectionParams: Codable {
        /// Optional. The name of the voice. If not set, the service will choose a voice based on the other parameters such as languageCode and ssmlGender.
        public var name: String?
        
        /// Optional. The preferred gender of the voice. If not set, the service will choose a voice based on the other parameters such as languageCode and name. Note that this is only a preference, not requirement. If a voice of the appropriate gender is not available, the synthesizer should substitute a voice with a different gender rather than failing the request.
        public var ssmlGender: SsmlVoiceGender?

        public init(name: String?, ssmlGender: SsmlVoiceGender?) {
            self.name = name
            self.ssmlGender = ssmlGender
        }
        
        
        public enum SsmlVoiceGender: String, Codable {
            /// An unspecified gender, which means that the client doesn't care which gender the selected voice will have.
            case unspecified = "SSML_VOICE_GENDER_UNSPECIFIED"
            /// A male voice.
            case male = "SSML_VOICE_GENDER_MALE"
            /// A female voice.
            case female = "SSML_VOICE_GENDER_FEMALE"
            /// A gender-neutral voice.
            case neutral = "SSML_VOICE_GENDER_NEUTRAL"
        }
    }
    
    
}

//#endif
