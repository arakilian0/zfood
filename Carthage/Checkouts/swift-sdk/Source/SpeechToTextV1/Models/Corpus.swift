/**
 * (C) Copyright IBM Corp. 2017, 2019.
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
 Information about a corpus from a custom language model.
 */
public struct Corpus: Codable, Equatable {

    /**
     The status of the corpus:
     * `analyzed`: The service successfully analyzed the corpus. The custom model can be trained with data from the
     corpus.
     * `being_processed`: The service is still analyzing the corpus. The service cannot accept requests to add new
     resources or to train the custom model.
     * `undetermined`: The service encountered an error while processing the corpus. The `error` field describes the
     failure.
     */
    public enum Status: String {
        case analyzed = "analyzed"
        case beingProcessed = "being_processed"
        case undetermined = "undetermined"
    }

    /**
     The name of the corpus.
     */
    public var name: String

    /**
     The total number of words in the corpus. The value is `0` while the corpus is being processed.
     */
    public var totalWords: Int

    /**
     The number of OOV words in the corpus. The value is `0` while the corpus is being processed.
     */
    public var outOfVocabularyWords: Int

    /**
     The status of the corpus:
     * `analyzed`: The service successfully analyzed the corpus. The custom model can be trained with data from the
     corpus.
     * `being_processed`: The service is still analyzing the corpus. The service cannot accept requests to add new
     resources or to train the custom model.
     * `undetermined`: The service encountered an error while processing the corpus. The `error` field describes the
     failure.
     */
    public var status: String

    /**
     If the status of the corpus is `undetermined`, the following message: `Analysis of corpus 'name' failed. Please try
     adding the corpus again by setting the 'allow_overwrite' flag to 'true'`.
     */
    public var error: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case totalWords = "total_words"
        case outOfVocabularyWords = "out_of_vocabulary_words"
        case status = "status"
        case error = "error"
    }

}
