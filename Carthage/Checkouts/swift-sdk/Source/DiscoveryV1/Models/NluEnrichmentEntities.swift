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
 An object speficying the Entities enrichment and related parameters.
 */
public struct NluEnrichmentEntities: Codable, Equatable {

    /**
     When `true`, sentiment analysis of entities will be performed on the specified field.
     */
    public var sentiment: Bool?

    /**
     When `true`, emotion detection of entities will be performed on the specified field.
     */
    public var emotion: Bool?

    /**
     The maximum number of entities to extract for each instance of the specified field.
     */
    public var limit: Int?

    /**
     When `true`, the number of mentions of each identified entity is recorded. The default is `false`.
     */
    public var mentions: Bool?

    /**
     When `true`, the types of mentions for each idetifieid entity is recorded. The default is `false`.
     */
    public var mentionTypes: Bool?

    /**
     When `true`, a list of sentence locations for each instance of each identified entity is recorded. The default is
     `false`.
     */
    public var sentenceLocations: Bool?

    /**
     The enrichement model to use with entity extraction. May be a custom model provided by Watson Knowledge Studio, the
     public model for use with Knowledge Graph `en-news`, or the default public model `alchemy`.
     */
    public var model: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case sentiment = "sentiment"
        case emotion = "emotion"
        case limit = "limit"
        case mentions = "mentions"
        case mentionTypes = "mention_types"
        case sentenceLocations = "sentence_locations"
        case model = "model"
    }

    /**
     Initialize a `NluEnrichmentEntities` with member variables.

     - parameter sentiment: When `true`, sentiment analysis of entities will be performed on the specified field.
     - parameter emotion: When `true`, emotion detection of entities will be performed on the specified field.
     - parameter limit: The maximum number of entities to extract for each instance of the specified field.
     - parameter mentions: When `true`, the number of mentions of each identified entity is recorded. The default is
       `false`.
     - parameter mentionTypes: When `true`, the types of mentions for each idetifieid entity is recorded. The default
       is `false`.
     - parameter sentenceLocations: When `true`, a list of sentence locations for each instance of each identified
       entity is recorded. The default is `false`.
     - parameter model: The enrichement model to use with entity extraction. May be a custom model provided by Watson
       Knowledge Studio, the public model for use with Knowledge Graph `en-news`, or the default public model `alchemy`.

     - returns: An initialized `NluEnrichmentEntities`.
    */
    public init(
        sentiment: Bool? = nil,
        emotion: Bool? = nil,
        limit: Int? = nil,
        mentions: Bool? = nil,
        mentionTypes: Bool? = nil,
        sentenceLocations: Bool? = nil,
        model: String? = nil
    )
    {
        self.sentiment = sentiment
        self.emotion = emotion
        self.limit = limit
        self.mentions = mentions
        self.mentionTypes = mentionTypes
        self.sentenceLocations = sentenceLocations
        self.model = model
    }

}
