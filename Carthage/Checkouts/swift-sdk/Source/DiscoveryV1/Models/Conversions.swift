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
 Document conversion settings.
 */
public struct Conversions: Codable, Equatable {

    /**
     A list of PDF conversion settings.
     */
    public var pdf: PDFSettings?

    /**
     A list of Word conversion settings.
     */
    public var word: WordSettings?

    /**
     A list of HTML conversion settings.
     */
    public var html: HTMLSettings?

    /**
     A list of Document Segmentation settings.
     */
    public var segment: SegmentSettings?

    /**
     Defines operations that can be used to transform the final output JSON into a normalized form. Operations are
     executed in the order that they appear in the array.
     */
    public var jsonNormalizations: [NormalizationOperation]?

    /**
     When `true`, automatic text extraction from images (this includes images embedded in supported document formats,
     for example PDF, and suppported image formats, for example TIFF) is performed on documents uploaded to the
     collection. This field is supported on **Advanced** and higher plans only. **Lite** plans do not support image text
     recognition.
     */
    public var imageTextRecognition: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case pdf = "pdf"
        case word = "word"
        case html = "html"
        case segment = "segment"
        case jsonNormalizations = "json_normalizations"
        case imageTextRecognition = "image_text_recognition"
    }

    /**
     Initialize a `Conversions` with member variables.

     - parameter pdf: A list of PDF conversion settings.
     - parameter word: A list of Word conversion settings.
     - parameter html: A list of HTML conversion settings.
     - parameter segment: A list of Document Segmentation settings.
     - parameter jsonNormalizations: Defines operations that can be used to transform the final output JSON into a
       normalized form. Operations are executed in the order that they appear in the array.
     - parameter imageTextRecognition: When `true`, automatic text extraction from images (this includes images
       embedded in supported document formats, for example PDF, and suppported image formats, for example TIFF) is
       performed on documents uploaded to the collection. This field is supported on **Advanced** and higher plans only.
       **Lite** plans do not support image text recognition.

     - returns: An initialized `Conversions`.
    */
    public init(
        pdf: PDFSettings? = nil,
        word: WordSettings? = nil,
        html: HTMLSettings? = nil,
        segment: SegmentSettings? = nil,
        jsonNormalizations: [NormalizationOperation]? = nil,
        imageTextRecognition: Bool? = nil
    )
    {
        self.pdf = pdf
        self.word = word
        self.html = html
        self.segment = segment
        self.jsonNormalizations = jsonNormalizations
        self.imageTextRecognition = imageTextRecognition
    }

}
