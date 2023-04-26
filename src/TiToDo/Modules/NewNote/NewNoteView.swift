//
//  NewNoteView.swift
//  TiToDo
//
//  Created by Andrey Timofeev on 25.04.2023.
//

import RealmSwift
import SwiftUI

struct NewNoteView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedRealmObject var note = Note()
    var completed: (Note) -> Void

    var body: some View {
        VStack(spacing: 14.0) {
            Text("NewNote.Title")
                .font(.system(size: 34.0, weight: .bold))

            TextField("NewNote.TextPlaceholder", text: $note.text)
            DatePicker(
                selection: $note.noteDate,
                displayedComponents: note.isAllDay ? [.date] : [.date, .hourAndMinute],
                label: {
                    Text("NewNote.NoteDate")
                }
            )
            Toggle(
                isOn: $note.isAllDay,
                label: {
                    Text("NewNote.AllDay")
                }
            )
            .tint(Color(UIColor.label))

            Button {
                completed(note)
                dismiss()
            } label: {
                Text("NewNote.Save")
            }
            .buttonStyle(.bordered)
            .tint(Color(UIColor.label))
            .disabled(note.text.isEmpty)
        }
        .padding()
    }
}

struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView(completed: { _ in })
    }
}
