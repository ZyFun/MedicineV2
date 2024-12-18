//
//  SocialMediaURL.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.03.2023.
//

import Foundation

public enum SocialMediaURL {
    case telegram
    case vk
    
    var url: String {
        switch self {
        case .telegram: "https://t.me/+8zc4QsHHac03ZGYy"
        case .vk: "https://vk.com/public218412067"
        }
    }
}
