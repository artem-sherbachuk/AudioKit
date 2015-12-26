//
//  AKOscillator.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

/// Reads from the table sequentially and repeatedly at given frequency. Linear
/// interpolation is applied for table look up from internal phase values.
///
/// - parameter frequency: Frequency in cycles per second
/// - parameter amplitude: Amplitude of the output
/// - parameter phase: Initial phase of waveform in functionTable, expressed as a fraction of a cycle (0 to 1).
///
public struct AKOscillator: AKNode {

    // MARK: - Properties

    /// Required property for AKNode
    public var avAudioNode: AVAudioNode

    internal var internalAU: AKOscillatorAudioUnit?
    internal var token: AUParameterObserverToken?

    private var frequencyParameter: AUParameter?
    private var amplitudeParameter: AUParameter?

    /// Frequency in cycles per second
    public var frequency: Double = 440 {
        didSet {
            frequencyParameter?.setValue(Float(frequency), originator: token!)
        }
    }
    /// Amplitude of the output
    public var amplitude: Double = 1 {
        didSet {
            amplitudeParameter?.setValue(Float(amplitude), originator: token!)
        }
    }

    // MARK: - Initialization

    /// Initialize this oscillator node
    ///
    /// - parameter frequency: Frequency in cycles per second
    /// - parameter amplitude: Amplitude of the output
    /// - parameter phase: Initial phase of waveform in functionTable, expressed as a fraction of a cycle (0 to 1).
    ///
    public init(
        table: AKTable = AKTable(.Sine),
        frequency: Double = 440,
        amplitude: Double = 0.5) {

        self.frequency = frequency
        self.amplitude = amplitude

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Generator
        description.componentSubType      = 0x6f73636c /*'oscl'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKOscillatorAudioUnit.self,
            asComponentDescription: description,
            name: "Local AKOscillator",
            version: UInt32.max)

        self.avAudioNode = AVAudioNode()
        AVAudioUnit.instantiateWithComponentDescription(description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitGenerator = avAudioUnit else { return }

            self.avAudioNode = avAudioUnitGenerator
            self.internalAU = avAudioUnitGenerator.AUAudioUnit as? AKOscillatorAudioUnit

            AKManager.sharedInstance.engine.attachNode(self.avAudioNode)
            self.internalAU?.setupTable(Int32(table.size))
            for var i = 0; i < table.size; i++ {
                self.internalAU?.setTableValue(table.values[i], atIndex: UInt32(i))
            }
        }

        guard let tree = internalAU?.parameterTree else { return }

        frequencyParameter = tree.valueForKey("frequency") as? AUParameter
        amplitudeParameter = tree.valueForKey("amplitude") as? AUParameter

        token = tree.tokenByAddingParameterObserver {
            address, value in

            dispatch_async(dispatch_get_main_queue()) {
                if address == self.frequencyParameter!.address {
                    self.frequency = Double(value)
                } else if address == self.amplitudeParameter!.address {
                    self.amplitude = Double(value)
                }
            }
        }
        frequencyParameter?.setValue(Float(frequency), originator: token!)
        amplitudeParameter?.setValue(Float(amplitude), originator: token!)
    }
}
