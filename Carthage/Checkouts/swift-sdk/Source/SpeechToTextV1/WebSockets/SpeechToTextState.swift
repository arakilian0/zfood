/**
 * (C) Copyright IBM Corp. 2016, 2018.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation

/** The state of a `SpeechToTextSession`. */
internal enum SpeechToTextState {

    /// The session is connecting to the Speech to Text service.
    case connecting

    /// The session is connected to the Speech to Text service. The service is waiting
    /// for a recognition request to be initiated.
    case connected

    /// A recognition request was initiated. The Speech to Text service is waiting to
    /// receive audio data for transcription.
    case listening

    /// Audio data for the recognition request was sent to the Speech to Text service. The
    /// service is processing the audio data. (No transcription results have yet been received.)
    case sentAudio

    /// A recognition request is being processed. The Speech to Text service is receiving audio
    /// data and transcribing it to text. (At least one transcription result has been received.)
    case transcribing

    /// The session is disconnected from the Speech to Text service.
    case disconnected

}
