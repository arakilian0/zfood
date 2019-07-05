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
 A list of HTML conversion settings.
 */
public struct HTMLSettings: Codable, Equatable {

    /**
     Array of HTML tags that are excluded completely.
     */
    public var excludeTagsCompletely: [String]?

    /**
     Array of HTML tags which are excluded but still retain content.
     */
    public var excludeTagsKeepContent: [String]?

    public var keepContent: XPathPatterns?

    public var excludeContent: XPathPatterns?

    /**
     An array of HTML tag attributes to keep in the converted document.
     */
    public var keepTagAttributes: [String]?

    /**
     Array of HTML tag attributes to exclude.
     */
    public var excludeTagAttributes: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case excludeTagsCompletely = "exclude_tags_completely"
        case excludeTagsKeepContent = "exclude_tags_keep_content"
        case keepContent = "keep_content"
        case excludeContent = "exclude_content"
        case keepTagAttributes = "keep_tag_attributes"
        case excludeTagAttributes = "exclude_tag_attributes"
    }

    /**
     Initialize a `HTMLSettings` with member variables.

     - parameter excludeTagsCompletely: Array of HTML tags that are excluded completely.
     - parameter excludeTagsKeepContent: Array of HTML tags which are excluded but still retain content.
     - parameter keepContent:
     - parameter excludeContent:
     - parameter keepTagAttributes: An array of HTML tag attributes to keep in the converted document.
     - parameter excludeTagAttributes: Array of HTML tag attributes to exclude.

     - returns: An initialized `HTMLSettings`.
    */
    public init(
        excludeTagsCompletely: [String]? = nil,
        excludeTagsKeepContent: [String]? = nil,
        keepContent: XPathPatterns? = nil,
        excludeContent: XPathPatterns? = nil,
        keepTagAttributes: [String]? = nil,
        excludeTagAttributes: [String]? = nil
    )
    {
        self.excludeTagsCompletely = excludeTagsCompletely
        self.excludeTagsKeepContent = excludeTagsKeepContent
        self.keepContent = keepContent
        self.excludeContent = excludeContent
        self.keepTagAttributes = keepTagAttributes
        self.excludeTagAttributes = excludeTagAttributes
    }

}
