/**
 * (C) Copyright IBM Corp. 2016, 2019.
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
 Information about a word for the custom voice model.
 */
public struct Word: Codable, Equatable {

    /**
     **Japanese only.** The part of speech for the word. The service uses the value to produce the correct intonation
     for the word. You can create only a single entry, with or without a single part of speech, for any word; you cannot
     create multiple entries with different parts of speech for the same word. For more information, see [Working with
     Japanese entries](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-rules#jaNotes).
     */
    public enum PartOfSpeech: String {
        case dosi = "Dosi"
        case fuku = "Fuku"
        case gobi = "Gobi"
        case hoka = "Hoka"
        case jodo = "Jodo"
        case josi = "Josi"
        case kato = "Kato"
        case kedo = "Kedo"
        case keyo = "Keyo"
        case kigo = "Kigo"
        case koyu = "Koyu"
        case mesi = "Mesi"
        case reta = "Reta"
        case stbi = "Stbi"
        case stto = "Stto"
        case stzo = "Stzo"
        case suji = "Suji"
    }

    /**
     The word for the custom voice model.
     */
    public var word: String

    /**
     The phonetic or sounds-like translation for the word. A phonetic translation is based on the SSML format for
     representing the phonetic string of a word either as an IPA or IBM SPR translation. A sounds-like translation
     consists of one or more words that, when combined, sound like the word.
     */
    public var translation: String

    /**
     **Japanese only.** The part of speech for the word. The service uses the value to produce the correct intonation
     for the word. You can create only a single entry, with or without a single part of speech, for any word; you cannot
     create multiple entries with different parts of speech for the same word. For more information, see [Working with
     Japanese entries](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-rules#jaNotes).
     */
    public var partOfSpeech: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case word = "word"
        case translation = "translation"
        case partOfSpeech = "part_of_speech"
    }

    /**
     Initialize a `Word` with member variables.

     - parameter word: The word for the custom voice model.
     - parameter translation: The phonetic or sounds-like translation for the word. A phonetic translation is based
       on the SSML format for representing the phonetic string of a word either as an IPA or IBM SPR translation. A
       sounds-like translation consists of one or more words that, when combined, sound like the word.
     - parameter partOfSpeech: **Japanese only.** The part of speech for the word. The service uses the value to
       produce the correct intonation for the word. You can create only a single entry, with or without a single part of
       speech, for any word; you cannot create multiple entries with different parts of speech for the same word. For
       more information, see [Working with Japanese
       entries](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-rules#jaNotes).

     - returns: An initialized `Word`.
    */
    public init(
        word: String,
        translation: String,
        partOfSpeech: String? = nil
    )
    {
        self.word = word
        self.translation = translation
        self.partOfSpeech = partOfSpeech
    }

}
