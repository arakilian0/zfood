/**
 * (C) Copyright IBM Corp. 2018.
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
 Request payload to classify.
 */
public struct ClassifyInput: Codable, Equatable {

    /**
     The submitted phrase. The maximum length is 2048 characters.
     */
    public var text: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
    }

    /**
     Initialize a `ClassifyInput` with member variables.

     - parameter text: The submitted phrase. The maximum length is 2048 characters.

     - returns: An initialized `ClassifyInput`.
    */
    public init(
        text: String
    )
    {
        self.text = text
    }

}
