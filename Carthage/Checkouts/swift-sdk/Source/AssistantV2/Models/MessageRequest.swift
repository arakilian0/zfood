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
 A request formatted for the Watson Assistant service.
 */
internal struct MessageRequest: Codable, Equatable {

    /**
     An input object that includes the input text.
     */
    public var input: MessageInput?

    /**
     State information for the conversation. The context is stored by the assistant on a per-session basis. You can use
     this property to set or modify context variables, which can also be accessed by dialog nodes.
     */
    public var context: MessageContext?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case input = "input"
        case context = "context"
    }

    /**
     Initialize a `MessageRequest` with member variables.

     - parameter input: An input object that includes the input text.
     - parameter context: State information for the conversation. The context is stored by the assistant on a
       per-session basis. You can use this property to set or modify context variables, which can also be accessed by
       dialog nodes.

     - returns: An initialized `MessageRequest`.
    */
    public init(
        input: MessageInput? = nil,
        context: MessageContext? = nil
    )
    {
        self.input = input
        self.context = context
    }

}
