//
//  URLProvider.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.03.2023.
//

import Foundation

public struct URLProvider {
    public static func fetchSocialMediaUrl(with service: SocialMediaURL) -> String {
        return service.url
    }
}
