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
    let purpose: String?
    let amount: Double?
	let unitType: String
    let stepCountForStepper: Double?
	let activeIngredient: String?
	let manufacturer: String?
    let expiryDate: Date?
	let userDescription: String?
}
