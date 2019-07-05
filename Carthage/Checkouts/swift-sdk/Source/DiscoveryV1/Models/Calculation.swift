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

/** Calculation. */
public struct Calculation: Codable, Equatable {

    /**
     The type of aggregation command used. For example: term, filter, max, min, etc.
     */
    public var type: String?

    /**
     Array of aggregation results.
     */
    public var results: [AggregationResult]?

    /**
     Number of matching results.
     */
    public var matchingResults: Int?

    /**
     Aggregations returned by Discovery.
     */
    public var aggregations: [QueryAggregation]?

    /**
     The field where the aggregation is located in the document.
     */
    public var field: String?

    /**
     Value of the aggregation.
     */
    public var value: Double?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case results = "results"
        case matchingResults = "matching_results"
        case aggregations = "aggregations"
        case field = "field"
        case value = "value"
    }

}
