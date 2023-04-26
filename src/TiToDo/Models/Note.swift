//
//  Note.swift
//  TiToDo
//
//  Created by Andrey Timofeev on 25.04.2023.
//

import Foundation
import RealmSwift

// swiftlint:disable identifier_name

final class Note: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var _id: ObjectId

    @Persisted var text: String
    @Persisted var noteDate: Date
    @Persisted var isCompleted = false
    @Persisted var isAllDay = false
}
