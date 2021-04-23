import SwiftUI

struct ContentView: View {
    @ObservedObject var settings: PlainSettingsVM
    @ObservedObject var pinger: PingerVM

    init(pinger: PingerVM) {
        self.settings = pinger.settings
        self.pinger = pinger
    }

    var body: some View {
        VStack {
            TabView {
                StatusView(pinger: pinger)
                    .tabItem {
                        Text("Status")
                    }

                SettingsView(settings: settings)
                    .tabItem {
                        Text("Settings")
                    }
                .onAppear {
                    let _ = self.pinger.subscribe()
                }
            }.padding()

            Divider()

            ToolbarView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(pinger: PingerVM(settings: .sample))
    }
}
