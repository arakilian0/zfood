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
 The original labeling from the input document, without the submitted feedback.
 */
public struct OriginalLabelsOut: Codable, Equatable {

    /**
     A string identifying the type of modification the feedback entry in the `updated_labels` array. Possible values are
     `added`, `not_changed`, and `removed`.
     */
    public enum Modification: String {
        case added = "added"
        case notChanged = "not_changed"
        case removed = "removed"
    }

    /**
     Description of the action specified by the element and whom it affects.
     */
    public var types: [TypeLabel]?

    /**
     List of functional categories into which the element falls; in other words, the subject matter of the element.
     */
    public var categories: [Category]?

    /**
     A string identifying the type of modification the feedback entry in the `updated_labels` array. Possible values are
     `added`, `not_changed`, and `removed`.
     */
    public var modification: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case types = "types"
        case categories = "categories"
        case modification = "modification"
    }

}
