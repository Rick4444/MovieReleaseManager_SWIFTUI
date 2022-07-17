//
//  Alert&Toast.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import SwiftUI

func showAlert(alertMessage: String) {
    Alert(
        title: Text("Movie Release Manager"),
        message: Text(alertMessage),
        dismissButton: .default(Text("Got it!"))
    )
}
