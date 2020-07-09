import SwiftUI

struct StatusView: View {
    @ObservedObject var pinger: PingerVM

    var body: some View {
        VStack {
            Text("Status")
                .padding()
                .font(.title)

            HStack {
                Text("Target: \(pinger.target ?? "n/a")")
                Text("Status: \(pinger.status != nil ? pinger.status!.rawValue : "n/a")")
            }.padding()

            Text("Duration: \(pinger.humanDuration)")
                .padding(.top)
            Text("Speed Class: \(pinger.speed != nil ? pinger.speed!.rawValue : "n/a")")
                .padding(.bottom)
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(pinger: PingerVM(settings: PlainSettingsVM(target: "foobar")))
    }
}
