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
 The text to synthesize. Specify either plain text or a subset of SSML. SSML is an XML-based markup language that
 provides text annotation for speech-synthesis applications. Pass a maximum of 5 KB of input text.
 */
internal struct Text: Codable, Equatable {

    /**
     The text to synthesize.
     */
    public var text: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
    }

    /**
     Initialize a `Text` with member variables.

     - parameter text: The text to synthesize.

     - returns: An initialized `Text`.
    */
    public init(
        text: String
    )
    {
        self.text = text
    }

}
