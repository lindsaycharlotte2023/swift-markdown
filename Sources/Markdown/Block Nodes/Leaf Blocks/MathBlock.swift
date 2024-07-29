/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
 See https://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

/// A code block.
public struct MathBlock: BlockMarkup {
    public var _data: _MarkupData
    init(_ raw: RawMarkup) throws {
        guard case .mathBlock = raw.data else {
            throw RawMarkup.Error.concreteConversionError(from: raw, to: MathBlock.self)
        }
        let absoluteRaw = AbsoluteRawMarkup(markup: raw, metadata: MarkupMetadata(id: .newRoot(), indexInParent: 0))
        self.init(_MarkupData(absoluteRaw))
    }

    init(_ data: _MarkupData) {
        self._data = data
    }
}

// MARK: - Public API

public extension MathBlock {
    /// Create a code block with raw `code` and optional `language`.
    init(_ math: String) {
        try! self.init(RawMarkup.mathBlock(parsedRange: nil, math: math))
    }
    
    /// The raw text representing the code of this block.
    var math: String {
        get {
            guard case let .mathBlock(math) = _data.raw.markup.data else {
                fatalError("\(self) markup wrapped unexpected \(_data.raw)")
            }
            return math
        }
        set {
            _data = _data.replacingSelf(.mathBlock(parsedRange: nil, math: newValue))
        }
    }

    // MARK: Visitation
    
    func accept<V: MarkupVisitor>(_ visitor: inout V) -> V.Result {
        return visitor.visitMathBlock(self)
    }
}
