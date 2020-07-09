//
//  SettingsView.swift
//  PingBuddy
//
//  Created by Stefan Horner on 09/07/2020.
//  Copyright © 2020 Stefan Horner. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: PlainSettingsVM

    var body: some View {
        VStack {
            Text("Settings")
                .padding()
                .font(.title)

            HStack {
                Button(action: {
                    self.settings.target = "1.1.1.1"
                }) {
                    Text("Cloudflare")
                }.padding()
                Button(action: {
                    self.settings.target = "208.67.222.222"
                }) {
                    Text("OpenDNS")
                }.padding()
                Button(action: {
                    self.settings.target = "8.8.8.8"
                }) {
                    Text("Google")
                }.padding()
            }

            HStack {
                Text("Custom Ping Target:")
                    .padding()
                TextField("Ping Target", text: $settings.target)
                    .padding()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: PlainSettingsVM(target: "foobar"))
    }
}
