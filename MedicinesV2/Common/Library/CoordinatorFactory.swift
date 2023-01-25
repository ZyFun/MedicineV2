//
//  CoordinatorFactory.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 25.01.2023.
//

import Foundation

protocol ICoordinatorFactory {
    func makeLoginCoordinator(router: IRouter)
}
