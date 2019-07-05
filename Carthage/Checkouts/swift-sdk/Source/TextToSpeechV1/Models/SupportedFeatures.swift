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
 Additional service features that are supported with the voice.
 */
public struct SupportedFeatures: Codable, Equatable {

    /**
     If `true`, the voice can be customized; if `false`, the voice cannot be customized. (Same as `customizable`.).
     */
    public var customPronunciation: Bool

    /**
     If `true`, the voice can be transformed by using the SSML &lt;voice-transformation&gt; element; if `false`, the
     voice cannot be transformed.
     */
    public var voiceTransformation: Bool

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case customPronunciation = "custom_pronunciation"
        case voiceTransformation = "voice_transformation"
    }

}
