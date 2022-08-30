//
//  ByteConverterView+.swift
//  DevToys
//
//  Created by Mubai Li on 2022/4/13.
//
//

import CoreUtil
import Foundation

typealias ByteType = Double

enum ByteFormate {
    case GB
    case MB
    case KB
    case Byte
    case Bit
    
    func rawValue(value :ByteType) -> RawByteFormate {
        switch self {
        case .GB:
            return RawByteFormate.init(value: value * 1024 * 1024 * 1024 * 1024);
        case .MB:
            return RawByteFormate.init(value: value * 1024 * 1024 * 1024);
        case .KB:
            return RawByteFormate.init(value: value * 1024 * 1024);
        case .Byte:
            return RawByteFormate.init(value: value * 1024);
        case .Bit:
            return RawByteFormate.init(value: value);
        }
    }
}

class RawByteFormate {
    
    let value : ByteType
    
    init(value :ByteType) {
        self.value = value;
    }
    
    func toGB() -> ByteType {
        return value / (1024 * 1024 * 1024 * 1024)
    }
    func toMB() -> ByteType {
        return value / (1024 * 1024 * 1024)
    }
    func toKB() -> ByteType {
        return value / (1024 * 1024)
    }
    func toByte() -> ByteType {
        return value / 1024
    }
    func toBit() -> ByteType {
        return value
        
    }
}

final class ByteConverterViewController: NSViewController {
    private let cell = NumberBaseConverterView()
    
    @RestorableState("byte.gb") private var valueGB = "1"
    @RestorableState("byte.mb") private var valueMB = "1024"
    @RestorableState("byte.kb") private var valueKB = "1048576"
    @RestorableState("byte.byte") private var valueByte = "1073741824"
    @RestorableState("byte.bit") private var valueBit = "8589934592"
    
    override func loadView() { self.view = cell }
    
    override func viewDidLoad() {
        self.$valueGB
            .sink{[unowned self] in cell.gbSection.string = $0 }.store(in: &objectBag)
        self.$valueMB
            .sink{[unowned self] in cell.mbSection.string = $0 }.store(in: &objectBag)
        self.$valueKB
            .sink{[unowned self] in cell.kbSection.string = $0 }.store(in: &objectBag)
        self.$valueByte
            .sink{[unowned self] in cell.byteSection.string = $0 }.store(in: &objectBag)
        self.$valueBit
            .sink{[unowned self] in cell.bitSection.string = $0 }.store(in: &objectBag)
        
        self.cell.gbSection.stringPublisher
            .sink{[unowned self] in self.updateValue(string: $0, formate: ByteFormate.GB) }.store(in: &objectBag)
        self.cell.mbSection.stringPublisher
            .sink{[unowned self] in self.updateValue(string: $0, formate: ByteFormate.MB) }.store(in: &objectBag)
        self.cell.kbSection.stringPublisher
            .sink{[unowned self] in self.updateValue(string: $0, formate: ByteFormate.KB) }.store(in: &objectBag)
        self.cell.byteSection.stringPublisher
            .sink{[unowned self] in self.updateValue(string: $0, formate: ByteFormate.Byte) }.store(in: &objectBag)
        self.cell.bitSection.stringPublisher
            .sink{[unowned self] in self.updateValue(string: $0, formate: ByteFormate.Bit) }.store(in: &objectBag)
        
    }
    
    private func updateValue(string: String, formate: ByteFormate) {
        let raw = formate.rawValue(value: NSString.init(string: string).doubleValue)
        self.valueGB = "\(raw.toGB())"
        self.valueMB = "\(raw.toMB())"
        self.valueKB = "\(raw.toKB())"
        self.valueByte = "\(raw.toByte())"
        self.valueBit = "\(raw.toBit())"
        
    }
    
    
}

final private class NumberBaseConverterView: Page {
    let formatSwitch = NSSwitch()
    
    let gbSection = TextFieldSection(title: "GB")
    let mbSection = TextFieldSection(title: "MB")
    let kbSection = TextFieldSection(title: "KB")
    let byteSection = TextFieldSection(title: "Byte")
    let bitSection = TextFieldSection(title: "Bit")
        
    override func onAwake() {
        
        self.addSection(gbSection)
        self.addSection(mbSection)
        self.addSection(kbSection)
        self.addSection(byteSection)
        self.addSection(bitSection)
    }
}
