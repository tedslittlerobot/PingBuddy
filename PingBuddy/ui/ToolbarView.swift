import SwiftUI

struct ToolbarView: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                print("Termination Requested!")
                NSApplication.shared.terminate(self)
            }) {
                Text("Quit")
            }.padding()
        }
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
    }
}
