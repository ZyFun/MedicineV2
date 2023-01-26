//
//  Di.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 25.01.2023.
//

import UIKit

final class Di {
    fileprivate let screenFactory: ScreenFactory
    
    init() {
        screenFactory = ScreenFactory()
        screenFactory.di = self
    }
}

protocol IScreenFactory {
    func makeMainScreen() -> FirstAidKitsViewController
//        func makeSplashScreen() -> SplashScreenVC<SplashScreenViewImpl>
//        func makeLoginScreen() -> LoginScreenVC<LoginScreenViewImpl>
//        func makeMoviesScreen() -> MoviesScreenVC<MoviesScreenViewImp>
//        func makeMovieScreen(id: Movie.Id) -> MovieScreenVC<MovieScreenViewImpl>
}

final class ScreenFactory: IScreenFactory {
    func makeMainScreen() -> FirstAidKitsViewController {
        <#code#>
    }
    
    fileprivate weak var di: Di!
    fileprivate init() {}
    
//        func makeSplashScreen() -> SplashScreenVC<SplashScreenViewImpl> {
//            return SplashScreenVC<SplashScreenViewImpl>(loginStatusProvider: di.loginStatusProvider)
//        }
    
//        func makeLoginScreen() -> LoginScreenVC<LoginScreenViewImpl> {
//            return LoginScreenVC<LoginScreenViewImpl>(loginProvider: di.loginProvider)
//        }
//
//        func makeMoviesScreen() -> MoviesScreenVC<MoviesScreenViewImp> {
//            return MoviesScreenVC<MoviesScreenViewImp>(moviesPagerProvider: di.moviesPagerProvider)
//        }
//
//        func makeMovieScreen(id: Movie.Id) -> MovieScreenVC<MovieScreenViewImpl> {
//            return MovieScreenVC<MovieScreenViewImpl>(movieProvider: di.movieProvider, id: id)
//        }
}
