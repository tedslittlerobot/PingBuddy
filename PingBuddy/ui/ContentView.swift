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
            SettingsView(settings: settings)

            Divider()

            StatusView(pinger: pinger)

            Divider()

            ToolbarView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(pinger: PingerVM(settings: PlainSettingsVM(target: "8.8.8.8")))
    }
}
