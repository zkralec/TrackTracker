import SwiftUI

struct SideBar: View {
    @Binding var currPage: Int
    @Binding var isSideMenuOpen: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Gray out the rest of the screen
            if isSideMenuOpen {
                Color.secondary.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isSideMenuOpen = false
                        }
                    }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Menu")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                        .padding(.leading, 25)
                    
                    Spacer()
                    
                    // Menu items
                    HStack {
                        VStack(alignment: .leading) {
                            // Home button
                            Button(action: {
                                withAnimation {
                                    currPage = 3
                                    isSideMenuOpen.toggle()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "house")
                                        .foregroundStyle(.blue)
                                    Text("Home")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .padding(6)
                            
                            // Events button
                            Button(action: {
                                withAnimation {
                                    currPage = 5
                                    isSideMenuOpen.toggle()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "figure.track.and.field")
                                        .foregroundStyle(.blue)
                                    Text("Your Events")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .padding(6)
                            
                            // Meets button
                            Button(action: {
                                withAnimation {
                                    currPage = 6
                                    isSideMenuOpen.toggle()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(.blue)
                                    Text("Meet Days")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .padding(6)
                            
                            // Training log button
                            Button(action: {
                                withAnimation {
                                    currPage = 8
                                    isSideMenuOpen.toggle()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "note.text")
                                        .foregroundStyle(.blue)
                                    Text("Training Log")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .padding(6)
                            
                            // Settings button
                            Button(action: {
                                withAnimation {
                                    currPage = 4
                                    isSideMenuOpen.toggle()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "gearshape")
                                        .foregroundStyle(.blue)
                                    Text("Settings")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .padding(6)
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text("App Version: 0.1.1 - alpha")
                        .font(.footnote)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .padding(.leading, 25)
                }
                .frame(width: UIScreen.main.bounds.width * 0.60)
                .transition(.move(edge: .leading))
                .padding(.top, -8)
                .background(colorScheme == .dark ? Color.black : Color.white)
                .offset(x: isSideMenuOpen ? 0 : -UIScreen.main.bounds.width)
                
                Spacer()
            }
        }
    }
}
