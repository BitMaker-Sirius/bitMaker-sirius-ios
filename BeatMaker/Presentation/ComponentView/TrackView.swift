//
//  SoundView.swift
//  BeatMaker
//
//  Created by Тася Галкина on 25.03.2024.
//

import Foundation
import SwiftUI

struct TrackView: View {
    @State var sound:Sound
    var buttonClicked: (() -> Void)?
    var body: some View {
        VStack {
            Text(sound.emoji ?? "")
            Text(sound.name)
                .font(customFont: .subtitle, size: 11)
                .foregroundColor(Color.onBackgroundColor)
        }
    }
}
