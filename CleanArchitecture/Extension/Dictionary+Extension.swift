//
//  Dictionary+Extension.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/30.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any? {
    func toParams() -> [String: Any] {
        return self.compactMapValues { $0 }
    }
}
