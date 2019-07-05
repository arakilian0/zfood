/**
 * (C) Copyright IBM Corp. 2018, 2019.
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

/**
 Information about an audio resource from a custom acoustic model.
 */
public struct AudioResource: Codable, Equatable {

    /**
     The status of the audio resource:
     * `ok`: The service successfully analyzed the audio data. The data can be used to train the custom model.
     * `being_processed`: The service is still analyzing the audio data. The service cannot accept requests to add new
     audio resources or to train the custom model until its analysis is complete.
     * `invalid`: The audio data is not valid for training the custom model (possibly because it has the wrong format or
     sampling rate, or because it is corrupted). For an archive file, the entire archive is invalid if any of its audio
     files are invalid.
     */
    public enum Status: String {
        case ok = "ok"
        case beingProcessed = "being_processed"
        case invalid = "invalid"
    }

    /**
     The total seconds of audio in the audio resource.
     */
    public var duration: Int

    /**
     **For an archive-type resource,** the user-specified name of the resource.
     **For an audio-type resource,** the user-specified name of the resource or the name of the audio file that the user
     added for the resource. The value depends on the method that is called.
     */
    public var name: String

    /**
     An `AudioDetails` object that provides detailed information about the audio resource. The object is empty until the
     service finishes processing the audio.
     */
    public var details: AudioDetails

    /**
     The status of the audio resource:
     * `ok`: The service successfully analyzed the audio data. The data can be used to train the custom model.
     * `being_processed`: The service is still analyzing the audio data. The service cannot accept requests to add new
     audio resources or to train the custom model until its analysis is complete.
     * `invalid`: The audio data is not valid for training the custom model (possibly because it has the wrong format or
     sampling rate, or because it is corrupted). For an archive file, the entire archive is invalid if any of its audio
     files are invalid.
     */
    public var status: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case duration = "duration"
        case name = "name"
        case details = "details"
        case status = "status"
    }

}
