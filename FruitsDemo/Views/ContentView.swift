import SwiftUI

struct ContentView: View {
    // Usamos un StateObject para mantener el estado de la colección de frutas
    @StateObject private var store = FruitStore()
    
    // Controla si se muestra la pantalla de añadir fruta
    @State private var showingAddFruit = false
    
    // Fruta temporal que se edita en AddFruitView antes de añadirla
    @State private var newFruit = FruitStore.defaultFruit

    var body: some View {
        NavigationView {
            List {
                // Recorremos todas las frutas y mostramos cada fila
                ForEach(store.fruits) { fruit in
                    // NavigationLink permite navegar al detalle de la fruta
                    NavigationLink(destination: DetailFruitView(fruit: fruit)) {
                        FruitRowView(fruit: fruit) // Vista de fila (no se modifica)
                    }
                }
                // Permite eliminar frutas con swipe-to-delete
                .onDelete(perform: deleteFruit)
            }
            .navigationTitle("Fruits") // Título de la pantalla principal
            .toolbar {
                // Botón "+" para añadir fruta
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Reiniciamos la fruta temporal y mostramos el formulario
                        newFruit = FruitStore.defaultFruit
                        showingAddFruit = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                // Botón "Edit" para activar modo edición (borrar elementos)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            //  AddFruitView
            .sheet(isPresented: $showingAddFruit) {
                NavigationView {
                    AddFruitView(newFruit: $newFruit)
                        .navigationTitle("Add Fruit")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            // Botón "Cancel" para cerrar sin añadir
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    showingAddFruit = false
                                }
                            }
                            // Botón "Add" para confirmar
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    addFruit()
                                    showingAddFruit = false
                                }
                                // Deshabilitado si la fruta no es válida
                                .disabled(!isValidFruit(newFruit))
                            }
                        }
                }
            }
        }
    }
    
    // Elimina frutas en los índices seleccionados
    private func deleteFruit(at offsets: IndexSet) {
        store.fruits.remove(atOffsets: offsets)
    }
    
    // Añade una fruta si es válida y no está repetida
    private func addFruit() {
        guard isValidFruit(newFruit),
              !store.fruits.contains(where: { $0.name.lowercased() == newFruit.name.lowercased() }) else { return }
        store.fruits.append(newFruit)
    }
    
    // Comprueba que la fruta tenga al menos un nombre no vacío
    private func isValidFruit(_ fruit: Fruit) -> Bool {
        !fruit.name.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
