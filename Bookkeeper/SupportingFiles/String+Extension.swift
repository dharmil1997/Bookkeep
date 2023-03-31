//
//  String+Extension.swift
//  Bookkeeper
//
//

extension String {
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).count == 0
    }
}
