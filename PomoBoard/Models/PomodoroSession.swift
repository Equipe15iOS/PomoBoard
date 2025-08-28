//
//  PomodoroSession.swift
//  PomoBoard
//
//  Created by iredefbmac_31 on 07/08/25.
//
import Foundation
import SwiftData

@Model
class PomodoroSession {
    var data: Date
    var duracao: Int  // duração em minutos
    var completo: Bool

    init(data: Date = Date(), duracao: Int, completo: Bool = false) {
        self.data = data
        self.duracao = duracao
        self.completo = completo
    }
}


