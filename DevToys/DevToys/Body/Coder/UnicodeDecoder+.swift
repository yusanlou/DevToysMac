//
//  UnicodeConverterView.swift
//  DevToys
//
//  Created by Mubai Li on 2022/6/22.
//

import CoreUtil
import Foundation

extension String {
    var unicodeStr:String {
        if let utf = self.data(using: String.Encoding.utf8) {
            return String.init(data: utf, encoding: String.Encoding.nonLossyASCII) ?? ""
        }
        return "";
    }
    
    var codeStr:String {
        if let res = self.data(using: String.Encoding.nonLossyASCII) {
            return String.init(data: res, encoding: String.Encoding.utf8) ?? ""
        }
        return "";
    }
}

final class UnicodeDecoderViewController: NSViewController {
    private let cell = UnicodeDecoderView()

    @RestorableState("uni.rawString") var rawString = #"\u4eba\u751f\u4e0d\u5982\u610f\u4e4b\u4e8b\uff0c\u5341\u4e4b\u516b\u4e5d"#
    @RestorableState("uni.formattedString") var formattedString = "人生不如意之事，十之八九"

    override func loadView() { view = cell }

    override func viewDidLoad() {
        cell.decodeTextSection.stringPublisher
            .sink { [unowned self] in
                self.rawString = $0;
                self.formattedString = $0.unicodeStr
            }.store(in: &objectBag)
        cell.encodeTextSection.stringPublisher
            .sink { [unowned self] in
                self.formattedString = $0;
                self.rawString = $0.codeStr
                
            }.store(in: &objectBag)

        $rawString
            .sink { [unowned self] in self.cell.decodeTextSection.string = $0 }.store(in: &objectBag)
        $formattedString
            .sink { [unowned self] in self.cell.encodeTextSection.string = $0 }.store(in: &objectBag)
    }
}

private final class UnicodeDecoderView: Page {
    let decodeTextSection = TextViewSection(title: "Encoded".localized(), options: [.all])
    let encodeTextSection = TextViewSection(title: "Decoded".localized(), options: [.all])

    override func layout() {
        super.layout()
        let halfHeight = max(200, (frame.height - 100) / 2)

        decodeTextSection.snp.remakeConstraints { make in
            make.height.equalTo(halfHeight)
        }
        encodeTextSection.snp.remakeConstraints { make in
            make.height.equalTo(halfHeight)
        }
    }

    override func onAwake() {
        addSection(encodeTextSection)
        addSection(decodeTextSection)
    }
}
