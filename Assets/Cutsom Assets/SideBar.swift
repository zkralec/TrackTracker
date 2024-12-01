import SwiftUI

// This is the side bar for enhanced navigation
struct SideBar: View {
    @Binding var isSideMenuOpen: Bool
    @Environment(\.colorScheme) var colorScheme
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
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
                            NavigationLink {
                                HomeView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack {
                                    Image(systemName: "house")
                                        .foregroundStyle(.blue)
                                    Text("Home")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .onTapGesture {
                                isSideMenuOpen.toggle()
                            }
                            .padding(6)
                            
                            // Events button
                            NavigationLink {
                                EventView(events: $events)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack {
                                    Image(systemName: "figure.track.and.field")
                                        .foregroundStyle(.blue)
                                    Text("Your Events")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .onTapGesture {
                                isSideMenuOpen.toggle()
                            }
                            .padding(6)
                            
                            // Meets button
                            NavigationLink {
                                MeetView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(.blue)
                                    Text("Meet Days")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .onTapGesture {
                                isSideMenuOpen.toggle()
                            }
                            .padding(6)
                            
                            // Injury log button
                            NavigationLink {
                                InjuryView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack {
                                    Image(systemName: "cross")
                                        .foregroundStyle(.blue)
                                    Text("Injury Log")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .onTapGesture {
                                isSideMenuOpen.toggle()
                            }
                            .padding(6)
                            
                            // Training log button
                            NavigationLink {
                                TrainingLogView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack {
                                    Image(systemName: "note.text")
                                        .foregroundStyle(.blue)
                                    Text("Training Log")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .onTapGesture {
                                isSideMenuOpen.toggle()
                            }
                            .padding(6)
                            
                            // Starter pistol button
                            NavigationLink {
                                StarterPistolView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack {
                                    Image(systemName: "autostartstop")
                                        .foregroundStyle(.blue)
                                    Text("Auto Starter")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .onTapGesture {
                                isSideMenuOpen.toggle()
                            }
                            .padding(6)
                            
                            // Settings button
                            NavigationLink {
                                SettingsView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack {
                                    Image(systemName: "gearshape")
                                        .foregroundStyle(.blue)
                                    Text("Settings")
                                        .padding(.vertical)
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                            }
                            .onTapGesture {
                                isSideMenuOpen.toggle()
                            }
                            .padding(6)
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // App version
                    Text("App Version: 1.0.0 - beta")
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
