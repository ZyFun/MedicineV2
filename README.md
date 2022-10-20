![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![IOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
<br/>
![Target](https://img.shields.io/badge/iOS-13.0-blue)
![Version](https://img.shields.io/badge/version-0.5.0-blue)
<br/>
![UIKit](https://img.shields.io/badge/-UIKit-blue)
![XIB](https://img.shields.io/badge/-XIB-blue)
![VIPER](https://img.shields.io/badge/-VIPER-blue)
![GCD](https://img.shields.io/badge/-GCD-blue)
![CoreData](https://img.shields.io/badge/-CoreData-blue)
![CocoaPods](https://img.shields.io/badge/-CocoaPods-blue)
![SwiftLint](https://img.shields.io/badge/-SwiftLint-blue)
![AutoLayout](https://img.shields.io/badge/-AutoLayout-blue)
<!-- ![UserDefaults](https://img.shields.io/badge/-UserDefaults-blue) -->
<!-- ![UnitTests](https://img.shields.io/badge/-UnitTests-blue) -->

# Аптечка v2
Второе учебное приложение.

### News
**20.10.2022**
- Обновлен дизайн приложения
- Добавлена возможность поиска лекарств и аптечек
- Добавлена анимация при запуске приложения
- Добавлено отображение о просроченных лекарствах внутри аптечки

**07.09.2022**
- Добавлены уведомления о просрочке лекарств

## Description
Улучшение заключается в том, что теперь лекарства можно распределять по разным аптечкам (домашняя, в автомобиле, в рюкзаке). В первой версии это был единый список. А так же код стал значительно чище и лучше по сравнению с прошлой реализацией.

Затраченное время – сюда не пишу, но смогу сказать точное, установил таймер и отслеживаю затраченное время на каждую задачу, которое записываю в **Jira**.

### Описание используемых технологий
- Многопоточность приложения построена на **GCD**.
- Стараюсь использовать все принципы чистого кода, **DRY, KISS, YAGNI, SOLID и SOA** (Всё еще не идеально. I'm just learning 😅).
- Приложение написано на архитектуре **VIPER**. Пока кривенько, но постепенно переписывается. Это первый проект на этой архитектуре. В этой архитектуре у данного приложения нет необходимости, я использую её только для практики и закрепления навыков. Понимаю, что для данного приложения вполне было бы достаточно MVC или MVP, к примеру с координатором.
- Для хранения данных используется **CoreData**.
- Для более удобной работы с таблицами с **CoreData** применяется **NSFetchedResultsControll**
<!-- - Используется UserDefaults для хранения избранной валюты. -->
<!-- - Код частично покрыт Unit тестами. -->
- Частично, интерфейс написан кодом с помощью **AutoLayout**.
- Вместо **Storyboard** использую **XIB** файлы. 1 экран – 1 **XIB**. В дальнейшем всё будет переделываться под верстку кодом.
- Для подключения фреймворков используется **CocoaPods**
- Используется фреймворк **Swiftlint** с кастомными настройками, рекомендованными Тинькофф Образованием + дополнительно своя конфигурация с более жесткими требованиями к стилю кода.
- Весь дизайн приложения был взять из головы.

## Installations
Clone and run project in Xcode 14 or newer
