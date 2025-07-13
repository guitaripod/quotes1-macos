import SwiftUI

struct ContentView: View {
    
    @State private var quotes: [Quote] = []
    
    var body: some View {
        List(quotes) { quote in
            VStack(alignment: .leading) {
                Text(quote.quote)
                    .font(.headline)
                Text(quote.author)
                    .font(.subheadline)
            }
        }
        .task {
            await getQuotes()
        }
    }
    
    func getQuotes() async {
        let url = URL(string: "http://127.0.0.1:8080/quotes")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            quotes = try JSONDecoder().decode([Quote].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

struct Quote: Codable, Identifiable {
    var id: UUID { UUID() }
    let quote, author: String
}


#Preview {
    ContentView()
}
