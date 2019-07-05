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

/** QueryNoticesResponse. */
public struct QueryNoticesResponse: Codable, Equatable {

    /**
     The number of matching results.
     */
    public var matchingResults: Int?

    /**
     Array of document results that match the query.
     */
    public var results: [QueryNoticesResult]?

    /**
     Array of aggregation results that match the query.
     */
    public var aggregations: [QueryAggregation]?

    /**
     Array of passage results that match the query.
     */
    public var passages: [QueryPassages]?

    /**
     The number of duplicates removed from this notices query.
     */
    public var duplicatesRemoved: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case matchingResults = "matching_results"
        case results = "results"
        case aggregations = "aggregations"
        case passages = "passages"
        case duplicatesRemoved = "duplicates_removed"
    }

}
