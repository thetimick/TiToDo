//
//  MainView.swift
//  TiToDo
//
//  Created by Andrey Timofeev on 25.04.2023.
//

import RealmSwift
import SwiftDate
import SwiftUI

struct MainView: View {
    @ObservedResults(Note.self)
    var notes

    @State var isShowAddNoteView = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                List {
                    // MARK: - Сегодня

                    Text("MainView.TodayTitle")
                        .font(.system(size: 34.0, weight: .bold))
                        .listRowSeparator(.hidden)

                    if let data = fetchNotes(.isToday) {
                        ForEach(data) { item in
                            NoteView(item)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        $notes.remove(item)
                                    } label: {
                                        Text("MainView.Delete")
                                    }
                                }
                        }
                        .listRowSeparator(.hidden)
                    } else {
                        Text("MainView.NotTasks")
                            .font(.system(size: 15.0))
                            .foregroundColor(Color(UIColor.systemGray))
                            .listRowSeparator(.hidden)
                    }

                    // MARK: - Завтра

                    if let data = fetchNotes(.isTomorrow) {
                        Text("MainView.TomorrowTitle")
                            .font(.system(size: 34.0, weight: .bold))
                            .listRowSeparator(.hidden)

                        ForEach(data) { item in
                            NoteView(item)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        $notes.remove(item)
                                    } label: {
                                        Text("MainView.Delete")
                                    }
                                }
                        }
                        .listRowSeparator(.hidden)
                    }

                    // MARK: - Позже

                    if let data = fetchNotes(.isFuture) {
                        Text("MainView.FutureTitle")
                            .font(.system(size: 34.0, weight: .bold))
                            .listRowSeparator(.hidden)

                        ForEach(data) { item in
                            NoteView(item)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        $notes.remove(item)
                                    } label: {
                                        Text("MainView.Delete")
                                    }
                                }
                        }
                        .onDelete(perform: $notes.remove)
                        .listRowSeparator(.hidden)
                    }

                    // MARK: - Прошедшие

                    if let data = fetchNotes(.isPast) {
                        Text("MainView.PastTitle")
                            .font(.system(size: 34.0, weight: .bold))
                            .listRowSeparator(.hidden)

                        ForEach(data) { item in
                            NoteView(item)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        $notes.remove(item)
                                    } label: {
                                        Text("MainView.Delete")
                                    }
                                }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.inset)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isShowAddNoteView = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 42.0, height: 42.0)
                                .padding()
                                .tint(Color(UIColor.label))
                        }
                    }
                }
            }
        }
        .sheet(
            isPresented: $isShowAddNoteView,
            onDismiss: {
                isShowAddNoteView = false
            }, content: {
                NewNoteView { note in
                    $notes.append(note)
                }
                .presentationDetents([.medium, .large])
            }
        )
    }
}

// MARK: - Private Methods

private extension MainView {
    enum Category {
        case isPast
        case isToday
        case isTomorrow
        case isFuture
    }

    func fetchNotes(_ category: Category) -> [Note]? {
        switch category {
        case .isPast:
            let data = notes
                .filter({ $0.isAllDay ? $0.noteDate.isInPast && !$0.noteDate.isToday : $0.noteDate.isInPast })
                .sorted(by: { $0.noteDate > $1.noteDate })
            return data.isEmpty ? nil : data

        case .isToday:
            let data = notes
                .filter({ $0.isAllDay ? $0.noteDate.isToday : $0.noteDate.isToday && !$0.noteDate.isInPast })
                .sorted(by: { $0.noteDate > $1.noteDate })
            return data.isEmpty ? nil : data

        case .isTomorrow:
            let data = notes
                .filter({ $0.noteDate.isTomorrow })
                .sorted(by: { $0.noteDate > $1.noteDate })
            return data.isEmpty ? nil : data

        case .isFuture:
            let data = notes
                .filter({ $0.noteDate.isInFuture && !$0.noteDate.isTomorrow })
                .sorted(by: { $0.noteDate > $1.noteDate })
            return data.isEmpty ? nil : data
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        return MainView()
    }
}
