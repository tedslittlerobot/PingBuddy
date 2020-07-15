import SwiftUI
import Combine

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

            HStack {
                VStack {
                    Text("Interval:")
                    TextField("Interval", text: $settings.interval)
                }
                .onReceive(Just(self.settings.interval)) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        self.settings.interval = filtered
                    }
                }
                VStack {
                    Text("Timeout:")
                    TextField("Timeout", text: $settings.timeout)
                }
                .onReceive(Just(self.settings.timeout)) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        self.settings.timeout = filtered
                    }
                }
            }.padding()

            HStack {
                VStack {
                    Text("Slow Time:")
                    TextField("Slow Time", text: $settings.slowTime)
                }
                .onReceive(Just(self.settings.slowTime)) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        self.settings.slowTime = filtered
                    }
                }
                VStack {
                    Text("OK Time:")
                    TextField("OK Time", text: $settings.okTime)
                }
                .onReceive(Just(self.settings.okTime)) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        self.settings.okTime = filtered
                    }
                }
                VStack {
                    Text("Fast Time:")
                    TextField("Fast Time", text: $settings.fastTime)
                }
                .onReceive(Just(self.settings.fastTime)) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        self.settings.fastTime = filtered
                    }
                }
            }.padding()

            Button(action: {
                self.settings.reset()
            }) {
                Text("Reset Settings")
                }.padding()

            Divider()


            HStack {
                Toggle(isOn: $settings.startAtLogin) {
                    Text("Start App at Startup / Login")
                }
            }.padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: .sample)
    }
}
