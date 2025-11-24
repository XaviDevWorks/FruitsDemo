
import SwiftUI

struct AddFruitView: View {
    
    @Binding var newFruit:Fruit
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $newFruit.name)
            }
            Section(header: Text("Description")) {
                TextEditor(text: $newFruit.description)
            }
            Section(header: Text("Image")) {
                EmojiPicker(emoji: $newFruit.emoji)
                    //TODO: .listRowInsets(EdgeInsets())
            }
        }
    }
}

struct AddFruitView_Previews: PreviewProvider {
    static var previews: some View {
        AddFruitView(newFruit: .constant(FruitStore.defaultFruit))
        AddFruitView(newFruit: .constant(FruitStore.defaultFruit))
            .preferredColorScheme(.dark)
        AddFruitView(newFruit: .constant(FruitStore.defaultFruit))
            .previewLayout(.fixed(width: 480, height: 320))
    }
}
