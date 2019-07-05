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

/** DocumentAccepted. */
public struct DocumentAccepted: Codable, Equatable {

    /**
     Status of the document in the ingestion process. A status of `processing` is returned for documents that are
     ingested with a *version* date before `2019-01-01`. The `pending` status is returned for all others.
     */
    public enum Status: String {
        case processing = "processing"
        case pending = "pending"
    }

    /**
     The unique identifier of the ingested document.
     */
    public var documentID: String?

    /**
     Status of the document in the ingestion process. A status of `processing` is returned for documents that are
     ingested with a *version* date before `2019-01-01`. The `pending` status is returned for all others.
     */
    public var status: String?

    /**
     Array of notices produced by the document-ingestion process.
     */
    public var notices: [Notice]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case status = "status"
        case notices = "notices"
    }

}
