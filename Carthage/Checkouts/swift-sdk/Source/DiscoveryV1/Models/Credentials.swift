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
 Object containing credential information.
 */
public struct Credentials: Codable, Equatable {

    /**
     The source that this credentials object connects to.
     -  `box` indicates the credentials are used to connect an instance of Enterprise Box.
     -  `salesforce` indicates the credentials are used to connect to Salesforce.
     -  `sharepoint` indicates the credentials are used to connect to Microsoft SharePoint Online.
     -  `web_crawl` indicates the credentials are used to perform a web crawl.
     =  `cloud_object_storage` indicates the credentials are used to connect to an IBM Cloud Object Store.
     */
    public enum SourceType: String {
        case box = "box"
        case salesforce = "salesforce"
        case sharepoint = "sharepoint"
        case webCrawl = "web_crawl"
        case cloudObjectStorage = "cloud_object_storage"
    }

    /**
     The current status of this set of credentials. `connected` indicates that the credentials are available to use with
     the source configuration of a collection. `invalid` refers to the credentials (for example, the password provided
     has expired) and must be corrected before they can be used with a collection.
     */
    public enum Status: String {
        case connected = "connected"
        case invalid = "invalid"
    }

    /**
     Unique identifier for this set of credentials.
     */
    public var credentialID: String?

    /**
     The source that this credentials object connects to.
     -  `box` indicates the credentials are used to connect an instance of Enterprise Box.
     -  `salesforce` indicates the credentials are used to connect to Salesforce.
     -  `sharepoint` indicates the credentials are used to connect to Microsoft SharePoint Online.
     -  `web_crawl` indicates the credentials are used to perform a web crawl.
     =  `cloud_object_storage` indicates the credentials are used to connect to an IBM Cloud Object Store.
     */
    public var sourceType: String?

    /**
     Object containing details of the stored credentials.
     Obtain credentials for your source from the administrator of the source.
     */
    public var credentialDetails: CredentialDetails?

    /**
     The current status of this set of credentials. `connected` indicates that the credentials are available to use with
     the source configuration of a collection. `invalid` refers to the credentials (for example, the password provided
     has expired) and must be corrected before they can be used with a collection.
     */
    public var status: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case credentialID = "credential_id"
        case sourceType = "source_type"
        case credentialDetails = "credential_details"
        case status = "status"
    }

    /**
     Initialize a `Credentials` with member variables.

     - parameter credentialID: Unique identifier for this set of credentials.
     - parameter sourceType: The source that this credentials object connects to.
       -  `box` indicates the credentials are used to connect an instance of Enterprise Box.
       -  `salesforce` indicates the credentials are used to connect to Salesforce.
       -  `sharepoint` indicates the credentials are used to connect to Microsoft SharePoint Online.
       -  `web_crawl` indicates the credentials are used to perform a web crawl.
       =  `cloud_object_storage` indicates the credentials are used to connect to an IBM Cloud Object Store.
     - parameter credentialDetails: Object containing details of the stored credentials.
       Obtain credentials for your source from the administrator of the source.
     - parameter status: The current status of this set of credentials. `connected` indicates that the credentials
       are available to use with the source configuration of a collection. `invalid` refers to the credentials (for
       example, the password provided has expired) and must be corrected before they can be used with a collection.

     - returns: An initialized `Credentials`.
    */
    public init(
        credentialID: String? = nil,
        sourceType: String? = nil,
        credentialDetails: CredentialDetails? = nil,
        status: String? = nil
    )
    {
        self.credentialID = credentialID
        self.sourceType = sourceType
        self.credentialDetails = credentialDetails
        self.status = status
    }

}
