//
//  AKPinkNoise.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

/// Faust-based pink noise generator
///
/// - parameter amplitude: Amplitude. (Value between 0-1).
///
public struct AKPinkNoise: AKNode {

    // MARK: - Properties

    /// Required property for AKNode
    public var avAudioNode: AVAudioNode

    internal var internalAU: AKPinkNoiseAudioUnit?
    internal var token: AUParameterObserverToken?

    private var amplitudeParameter: AUParameter?

    /// Amplitude. (Value between 0-1).
    public var amplitude: Double = 1.0 {
        didSet {
            amplitudeParameter?.setValue(Float(amplitude), originator: token!)
        }
    }

    // MARK: - Initialization

    /// Initialize this noise node
    ///
    /// - parameter amplitude: Amplitude. (Value between 0-1).
    ///
    public init(amplitude: Double = 1.0) {

        self.amplitude = amplitude

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Generator
        description.componentSubType      = 0x70696e6b /*'pink'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKPinkNoiseAudioUnit.self,
            asComponentDescription: description,
            name: "Local AKPinkNoise",
            version: UInt32.max)

        self.avAudioNode = AVAudioNode()
        AVAudioUnit.instantiateWithComponentDescription(description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitGenerator = avAudioUnit else { return }

            self.avAudioNode = avAudioUnitGenerator
            self.internalAU = avAudioUnitGenerator.AUAudioUnit as? AKPinkNoiseAudioUnit

            AKManager.sharedInstance.engine.attachNode(self.avAudioNode)
        }

        guard let tree = internalAU?.parameterTree else { return }

        amplitudeParameter = tree.valueForKey("amplitude") as? AUParameter

        token = tree.tokenByAddingParameterObserver {
            address, value in

            dispatch_async(dispatch_get_main_queue()) {
                if address == self.amplitudeParameter!.address {
                    self.amplitude = Double(value)
                }
            }
        }
        amplitudeParameter?.setValue(Float(amplitude), originator: token!)
    }
}
