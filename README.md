![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![IOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
<br/>
![Target](https://img.shields.io/badge/iOS-15.0-blue)
![Version](https://img.shields.io/badge/version-1.2.0-blue)
<br/>
![UIKit](https://img.shields.io/badge/-UIKit-blue)
![SwiftUI](https://img.shields.io/badge/-SwiftUI-blue)
![XIB](https://img.shields.io/badge/-XIB-blue)
![VIPER](https://img.shields.io/badge/-VIPER-blue)
![MVP](https://img.shields.io/badge/-MVP-blue)
![MVVM](https://img.shields.io/badge/-MVVM-blue)
![GCD](https://img.shields.io/badge/-GCD-blue)
![CoreData](https://img.shields.io/badge/-CoreData-blue)
![AutoLayout](https://img.shields.io/badge/-AutoLayout-blue)
![UnitTests](https://img.shields.io/badge/-UnitTests-blue)
<br/>
![SPM](https://img.shields.io/badge/-SPM-blue)
![SwiftLint](https://img.shields.io/badge/-SwiftLint-blue)
![XcodeCloudCI](https://img.shields.io/badge/-XcodeCloudCI-blue)

# Аптечка v2
Второе учебное приложение.

## Screenshots
<img src="https://github.com/ZyFun/MedicineV2/blob/main/Screenshots/Screenshot000.png" width="252" height="497" /> <img src="https://github.com/ZyFun/MedicineV2/blob/main/Screenshots/Screenshot001.png" width="252" height="497" /> <img src="https://github.com/ZyFun/MedicineV2/blob/main/Screenshots/Screenshot002.png" width="252" height="497" /> <img src="https://github.com/ZyFun/MedicineV2/blob/main/Screenshots/Screenshot003.png" width="252" height="497" />

### Splash screen
<img src="https://github.com/ZyFun/MedicineV2/blob/main/Screenshots/Demo.gif" width="252" height="545" />

## Description
Улучшение заключается в том, что теперь лекарства можно распределять по разным аптечкам (домашняя, в автомобиле, в рюкзаке). В первой версии это был единый список. А так же код стал значительно чище и лучше по сравнению с прошлой реализацией.

Затраченное время – сюда не пишу, но смогу сказать точное, установил таймер и отслеживаю затраченное время на каждую задачу, которое записываю в **Jira**.

### Описание используемых технологий
- Многопоточность приложения построена на **GCD**.
- Стараюсь использовать все принципы чистого кода, **DRY, KISS, YAGNI, SOLID и SOA** (Всё еще не идеально. I'm just learning 😅).
- Приложение написано на архитектуре **VIPER**. Пока кривенько, но постепенно переписывается. Это первый проект на этой архитектуре. В этой архитектуре у данного приложения нет необходимости, я использую её только для практики и закрепления навыков. Понимаю, что для данного приложения вполне было бы достаточно MVC или MVP, к примеру с координатором. Но с развитием, простые модули начал писать на **MVP**.
- Для хранения данных используется **CoreData**.
- Для более удобной работы с таблицами с **CoreData** применяется **NSFetchedResultsControll**
- Код частично покрыт Unit тестами.
- Настроен **CI Xcode Cloud** для автоматического запуска тестов.
- Частично, интерфейс написан кодом с помощью **AutoLayout**.
- Вместо **Storyboard** использую **XIB** файлы. 1 экран – 1 **XIB**. В дальнейшем всё будет переделываться под верстку кодом.
- Для подключения фреймворков используется **CocoaPods**
- Часто используемый в разных проектах код, вынесен в **SPM**
- Используется фреймворк **Swiftlint** с кастомными настройками, рекомендованными Тинькофф Образованием + дополнительно своя конфигурация с более жесткими требованиями к стилю кода.
- Весь дизайн приложения был взять из головы.


## News
**xx.10.2024**
<br/>
Новые возможности:
- Добавлены новые поля ввода информации о лекарстве
- Добавлены уведомления о действиях или ошибках

Изменение UI:
- Переработан дизайн экрана детальной информации о лекарстве
- Обновлен дизайн темной темы

Исправления:
- Исправлена опечатка на карточке лекарства
- Исправлена ошибка, из-за которой на карточке лекарства могло появится много знаков после запятой у количества лекарств.

**09.01.2024**
<br/>
Новые возможности:
- Добавлена синхронизация с iCloud

**12.10.2023**
<br/>
Новые возможности:
- Добавлено боковое меню
- Добавлена возможность настройки сортировки
- Добавлена возможность выбора времени доставки уведомлений

Исправления:
- Исправлен алерт, согласно гайдлайнам эпл
- Исправлена ошибка из-за которой приложение падало, когда шаг установки дозы был отрицательным или текстом

Изменение UI:
- Переработан дизайн карточек

Другие изменения:
- Увеличен таргет iOS до 15

**20.10.2022**
- Обновлен дизайн приложения
- Добавлена возможность поиска лекарств и аптечек
- Добавлена анимация при запуске приложения
- Добавлено отображение о просроченных лекарствах внутри аптечки

**07.09.2022**
- Добавлены уведомления о просрочке лекарств

## Installations
Clone and run project in Xcode 15 or newer
