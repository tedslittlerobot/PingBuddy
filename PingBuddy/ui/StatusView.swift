import SwiftUI

struct StatusView: View {
    @ObservedObject var pinger: PingerVM

    var body: some View {
        VStack {
            Text("Status")
                .padding()
                .font(.title)

            if pinger.pong == nil {
                Text("No Response")
            } else {
                VStack {
                    HStack {
                        Text("Target: \(pinger.pong!.target)")
                        Text("Status: \(pinger.pong!.status.rawValue)")
                    }.padding()

                    if pinger.pong!.status == .success {
                        success
                    } else if pinger.pong!.status == .failure {
                        failed
                    } else if pinger.pong!.status == .off {
                        off
                    }
                }
            }
        }
    }

    var failed: some View {
        Text("Ping Failed")
    }

    var off: some View {
        Text("Ping Not Running")
    }

    var success: some View {
        VStack {
            Text("Duration: \(pinger.humanDuration)")
            Text("Speed Class: \(pinger.pong!.speed != nil ? pinger.pong!.speed!.rawValue : "n/a")")
                    .padding(.bottom)
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StatusView(pinger: PingerVM(settings: .sample))
            Divider()
            StatusView(pinger: PingerVM(settings: .sample, pong: .off(settings: .sample)))
            Divider()
            StatusView(pinger: PingerVM(settings: .sample, pong: .failed(settings: .sample)))
            Divider()
            StatusView(pinger: PingerVM(settings: .sample, pong: .sample))
        }
    }
}
