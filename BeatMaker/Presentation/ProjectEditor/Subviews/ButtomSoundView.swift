//
//  ButtomSoundView.swift
//  BeatMaker
//
//  Created by Тася Галкина on 25.03.2024.
//

import Foundation
import SwiftUI

struct ButtomSoundView: View {
    @State var sound:Sound
    var buttonClicked: (() -> Void)?
    var body: some View {
        Button(action: {
            buttonClicked?()
        }) {
            Text(sound.emoji ?? "")
        }
        .padding()
        .background(Color.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.onBackgroundColor, radius: 1)
    }
}
