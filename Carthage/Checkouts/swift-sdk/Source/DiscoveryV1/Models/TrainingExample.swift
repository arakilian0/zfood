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

/** TrainingExample. */
public struct TrainingExample: Codable, Equatable {

    /**
     The document ID associated with this training example.
     */
    public var documentID: String?

    /**
     The cross reference associated with this training example.
     */
    public var crossReference: String?

    /**
     The relevance of the training example.
     */
    public var relevance: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case crossReference = "cross_reference"
        case relevance = "relevance"
    }

    /**
     Initialize a `TrainingExample` with member variables.

     - parameter documentID: The document ID associated with this training example.
     - parameter crossReference: The cross reference associated with this training example.
     - parameter relevance: The relevance of the training example.

     - returns: An initialized `TrainingExample`.
    */
    public init(
        documentID: String? = nil,
        crossReference: String? = nil,
        relevance: Int? = nil
    )
    {
        self.documentID = documentID
        self.crossReference = crossReference
        self.relevance = relevance
    }

}
