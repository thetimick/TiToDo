//
//  NoteView.swift
//  TiToDo
//
//  Created by Andrey Timofeev on 25.04.2023.
//

import RealmSwift
import SwiftDate
import SwiftUI

struct NoteView: View {
    @ObservedRealmObject private var note: Note

    var body: some View {
        HStack(alignment: .top) {
            Toggle(isOn: $note.isCompleted, label: { })
                .labelsHidden()
                .tint(Color(UIColor.label))

            VStack(alignment: .leading, spacing: 8.0) {
                Text(note.text)
                    .strikethrough(note.isCompleted)
                    .font(.system(size: 15.0))
                    .foregroundColor(note.isCompleted ? Color(UIColor.systemGray) : Color(UIColor.label))

                Text("NoteView.Date \(fetchNoteDate())")
                    .font(.system(size: 13.0))
                    .foregroundColor(Color(UIColor.systemGray3))
            }

            Spacer()
        }
    }

    init(_ note: Note) {
        self.note = note
    }
}

private extension NoteView {
    func fetchNoteDate() -> String {
        note.isAllDay ? note.noteDate.toString(.date(.medium)) : note.noteDate.toString(.dateTimeMixed(dateStyle: .long, timeStyle: .short))
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        return NoteView(Note())
    }
}
