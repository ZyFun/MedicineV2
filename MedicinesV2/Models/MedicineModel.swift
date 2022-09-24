//
//  MedicineModel.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 20.09.2022.
//

import Foundation

struct MedicineModel {
    let dateCreated: Date
    let title: String
    let type: String?
    let amount: Double?
    let stepCountForStepper: Double?
    let expiryDate: Date?
}
